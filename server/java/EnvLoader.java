import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/**
 * Utility class for loading environment variables from .env file.
 * Uses manual parsing to avoid dependency on dotenv-java at runtime.
 */
public class EnvLoader {
    private static Map<String, String> cachedEnv = null;
    
    /**
     * Loads environment variables from .env file in server directory.
     */
    public static Map<String, String> loadEnv() {
        if (cachedEnv != null) {
            return cachedEnv;
        }
        
        Map<String, String> env = new HashMap<>();
        
        // Get the parent directory (server/) where .env file is located
        Path currentPath = Paths.get(System.getProperty("user.dir"));
        Path envPath = currentPath.getParent().resolve(".env");
        
        File envFile = envPath.toFile();
        
        if (envFile.exists()) {
            try (Scanner scanner = new Scanner(envFile)) {
                while (scanner.hasNextLine()) {
                    String line = scanner.nextLine().trim();
                    
                    // Skip empty lines and comments
                    if (line.isEmpty() || line.startsWith("#")) {
                        continue;
                    }
                    
                    // Parse key=value pairs
                    int equalsIndex = line.indexOf('=');
                    if (equalsIndex > 0) {
                        String key = line.substring(0, equalsIndex).trim();
                        String value = line.substring(equalsIndex + 1).trim();
                        
                        // Remove quotes if present
                        if (value.startsWith("\"") && value.endsWith("\"") && value.length() > 1) {
                            value = value.substring(1, value.length() - 1);
                        } else if (value.startsWith("'") && value.endsWith("'") && value.length() > 1) {
                            value = value.substring(1, value.length() - 1);
                        }
                        
                        env.put(key, value);
                    }
                }
            } catch (Exception e) {
                System.err.println("Warning: Could not read .env file: " + e.getMessage());
            }
        } else {
            System.err.println("Warning: .env file not found at: " + envPath);
        }
        
        cachedEnv = env;
        return env;
    }
    
    /**
     * Gets an environment variable, with fallback to system environment.
     */
    public static String getEnv(String key, String defaultValue) {
        Map<String, String> env = loadEnv();
        String value = env.get(key);
        if (value == null || value.isEmpty()) {
            value = System.getenv(key);
        }
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }
    
    /**
     * Gets an environment variable.
     */
    public static String getEnv(String key) {
        return getEnv(key, null);
    }
}

