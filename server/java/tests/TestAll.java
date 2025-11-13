import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Quick test script to validate all Java code samples.
 * This script checks:
 * 1. Java syntax validity (basic structure)
 * 2. Import dependencies
 * 3. Basic structure validation
 */
public class TestAll {
    private static final String GREEN = "\033[92m";
    private static final String RED = "\033[91m";
    private static final String YELLOW = "\033[93m";
    private static final String BLUE = "\033[94m";
    private static final String RESET = "\033[0m";

    public static void main(String[] args) {
        // Test files are in tests/ directory, but Java samples are one level up
        Path scriptDir = Paths.get(System.getProperty("user.dir"));
        Path parentDir = scriptDir.getParent();
        
        File[] javaFiles = parentDir.toFile().listFiles((dir, name) -> 
            name.endsWith(".java") && !name.equals("TestAll.java") && 
            !name.equals("CourierClient.java") && !name.equals("EnvLoader.java"));
        
        if (javaFiles == null || javaFiles.length == 0) {
            System.out.println(RED + "No Java files found to test" + RESET);
            System.exit(1);
        }
        
        System.out.println(BLUE + "Testing " + javaFiles.length + " Java sample files..." + RESET + "\n");
        
        List<TestResult> results = new ArrayList<>();
        
        for (File file : javaFiles) {
            System.out.println(BLUE + "Testing: " + file.getName() + RESET);
            
            TestResult syntaxResult = checkSyntax(file);
            TestResult importsResult = checkImports(file);
            TestResult structureResult = checkStructure(file);
            
            boolean allOk = syntaxResult.passed && importsResult.passed && structureResult.passed;
            
            printResult(syntaxResult);
            printResult(importsResult);
            printResult(structureResult);
            
            results.add(new TestResult(file.getName(), allOk));
            System.out.println();
        }
        
        // Summary
        System.out.println(BLUE + "=".repeat(60) + RESET);
        System.out.println(BLUE + "Summary:" + RESET + "\n");
        
        long passed = results.stream().filter(r -> r.passed).count();
        int total = results.size();
        
        for (TestResult result : results) {
            String status = result.passed ? 
                GREEN + "✓ PASS" + RESET : 
                YELLOW + "⚠ PARTIAL" + RESET;
            System.out.println("  " + status + " - " + result.name);
        }
        
        System.out.println("\n" + BLUE + "Results: " + passed + "/" + total + " files passed all checks" + RESET);
        
        if (passed == total) {
            System.out.println(GREEN + "All files are valid! ✓" + RESET);
            System.exit(0);
        } else {
            System.out.println(YELLOW + "Some files need attention (likely missing dependencies)" + RESET);
            System.out.println(YELLOW + "Run: mvn clean install" + RESET);
            System.exit(1);
        }
    }
    
    private static TestResult checkSyntax(File file) {
        try {
            String content = Files.readString(file.toPath());
            
            // Basic syntax checks
            boolean hasClass = content.contains("public class");
            boolean hasMain = content.contains("public static void main");
            boolean hasBraces = countOccurrences(content, "{") == countOccurrences(content, "}");
            
            if (hasClass && hasMain && hasBraces) {
                return new TestResult(true, "✓ Syntax valid");
            } else {
                return new TestResult(false, "✗ Syntax issues detected");
            }
        } catch (Exception e) {
            return new TestResult(false, "✗ Error reading file: " + e.getMessage());
        }
    }
    
    private static TestResult checkImports(File file) {
        try {
            String content = Files.readString(file.toPath());
            
            // Check for required imports/patterns
            boolean hasJsonImport = content.contains("com.fasterxml.jackson") || 
                                   content.contains("import") && content.contains("JsonNode");
            boolean hasEnvLoader = content.contains("EnvLoader") || content.contains("getEnv");
            boolean hasCourierClient = content.contains("CourierClient") || content.contains("new CourierClient");
            
            List<String> missing = new ArrayList<>();
            if (!hasJsonImport) {
                missing.add("Jackson JSON");
            }
            if (!hasEnvLoader && !hasCourierClient) {
                missing.add("Utility classes");
            }
            
            if (missing.isEmpty()) {
                return new TestResult(true, "✓ Imports valid");
            } else {
                return new TestResult(false, "✗ Missing components: " + String.join(", ", missing));
            }
        } catch (Exception e) {
            return new TestResult(false, "✗ Error checking imports: " + e.getMessage());
        }
    }
    
    private static TestResult checkStructure(File file) {
        try {
            String content = Files.readString(file.toPath());
            
            // Check for key patterns
            List<String> checks = new ArrayList<>();
            if (content.contains("CourierClient") || content.contains("new CourierClient")) {
                checks.add("CourierClient usage");
            }
            if (content.contains("EnvLoader") || content.contains("getEnv")) {
                checks.add("Environment loading");
            }
            if (content.contains("main") && content.contains("String[] args")) {
                checks.add("Main method");
            }
            
            if (checks.size() >= 2) {
                return new TestResult(true, "✓ Structure valid (" + String.join(", ", checks) + ")");
            } else {
                return new TestResult(false, "✗ Missing key components");
            }
        } catch (Exception e) {
            return new TestResult(false, "✗ Error checking structure: " + e.getMessage());
        }
    }
    
    private static int countOccurrences(String text, String pattern) {
        return text.length() - text.replace(pattern, "").length();
    }
    
    private static void printResult(TestResult result) {
        String color = result.passed ? GREEN : YELLOW;
        System.out.println("  " + color + result.message + RESET);
    }
    
    private static class TestResult {
        boolean passed;
        String message;
        String name;
        
        TestResult(boolean passed, String message) {
            this.passed = passed;
            this.message = message;
        }
        
        TestResult(String name, boolean passed) {
            this.name = name;
            this.passed = passed;
        }
    }
}

