import java.io.File
import java.nio.file.Paths

/**
 * Utility object for loading environment variables from .env file.
 */
object EnvLoader {
    private var cachedEnv: Map<String, String>? = null
    
    /**
     * Loads environment variables from .env file in server directory.
     */
    fun loadEnv(): Map<String, String> {
        if (cachedEnv != null) {
            return cachedEnv!!
        }
        
        val env = mutableMapOf<String, String>()
        
        // Get the parent directory (server/) where .env file is located
        val currentPath = Paths.get(System.getProperty("user.dir"))
        val envPath = currentPath.parent.resolve(".env")
        val envFile = envPath.toFile()
        
        if (envFile.exists()) {
            try {
                envFile.readLines().forEach { line ->
                    val trimmed = line.trim()
                    
                    // Skip empty lines and comments
                    if (trimmed.isEmpty() || trimmed.startsWith("#")) {
                        return@forEach
                    }
                    
                    // Parse key=value pairs
                    val equalsIndex = trimmed.indexOf('=')
                    if (equalsIndex > 0) {
                        val key = trimmed.substring(0, equalsIndex).trim()
                        var value = trimmed.substring(equalsIndex + 1).trim()
                        
                        // Remove quotes if present
                        if (value.startsWith("\"") && value.endsWith("\"") && value.length > 1) {
                            value = value.substring(1, value.length - 1)
                        } else if (value.startsWith("'") && value.endsWith("'") && value.length > 1) {
                            value = value.substring(1, value.length - 1)
                        }
                        
                        env[key] = value
                    }
                }
            } catch (e: Exception) {
                System.err.println("Warning: Could not read .env file: ${e.message}")
            }
        } else {
            System.err.println("Warning: .env file not found at: $envPath")
        }
        
        cachedEnv = env
        return env
    }
    
    /**
     * Gets an environment variable, with fallback to system environment.
     */
    fun getEnv(key: String, defaultValue: String = ""): String {
        val env = loadEnv()
        val value = env[key]
        if (value == null || value.isEmpty()) {
            val systemValue = System.getenv(key)
            return systemValue ?: defaultValue
        }
        return value
    }
}

