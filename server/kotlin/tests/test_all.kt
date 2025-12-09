import java.io.File

// Colors for output
val GREEN = "\u001B[92m"
val RED = "\u001B[91m"
val YELLOW = "\u001B[93m"
val BLUE = "\u001B[94m"
val RESET = "\u001B[0m"

fun checkSyntax(filePath: File): Pair<Boolean, String> {
    try {
        // Use kotlinc to check syntax (compile only, don't run)
        val tempJar = File.createTempFile("test_${filePath.nameWithoutExtension}", ".jar")
        val process = ProcessBuilder("kotlinc", filePath.absolutePath, "-include-runtime", "-d", tempJar.absolutePath)
            .redirectErrorStream(true)
            .start()
        val exitCode = process.waitFor()
        val error = process.inputStream.bufferedReader().readText()
        tempJar.delete()
        
        if (exitCode == 0) {
            return Pair(true, "✓ Syntax valid")
        } else {
            val errorMsg = error.lines().filter { it.contains("error:") }.firstOrNull() ?: error.take(100)
            return Pair(false, "✗ Syntax error: $errorMsg")
        }
    } catch (e: Exception) {
        return Pair(false, "✗ Error checking syntax: ${e.message}")
    }
}

fun checkImports(filePath: File): Pair<Boolean, String> {
    try {
        val content = filePath.readText()
        
        // Check for required patterns
        val hasHttp = content.contains("HttpURLConnection") || content.contains("java.net")
        val hasEnv = content.contains("loadEnv") || content.contains(".env")
        
        if (!hasHttp) {
            return Pair(false, "✗ Missing HTTP client (java.net.HttpURLConnection)")
        }
        if (!hasEnv) {
            return Pair(false, "✗ Missing environment loading")
        }
        
        return Pair(true, "✓ Imports valid")
    } catch (e: Exception) {
        return Pair(false, "✗ Error checking imports: ${e.message}")
    }
}

fun checkStructure(filePath: File): Pair<Boolean, String> {
    try {
        val content = filePath.readText()
        
        val checks = mutableListOf<String>()
        if (content.contains("loadEnv") || content.contains(".env")) {
            checks.add("Environment loading")
        }
        if (content.contains("COURIER_API_KEY")) {
            checks.add("API key reference")
        }
        if (content.contains("HttpURLConnection") || content.contains("URL")) {
            checks.add("HTTP client")
        }
        if (content.contains("Authorization") && content.contains("Bearer")) {
            checks.add("Authorization header")
        }
        
        if (checks.size >= 2) {
            return Pair(true, "✓ Structure valid (${checks.joinToString(", ")})")
        } else {
            return Pair(false, "✗ Missing key components")
        }
    } catch (e: Exception) {
        return Pair(false, "✗ Error checking structure: ${e.message}")
    }
}

fun main() {
    // Get parent directory (server/kotlin)
    val testDir = File(".")
    val parentDir = testDir.parentFile
    
    // Find all .kt files in parent directory
    val allFiles = parentDir.listFiles() ?: arrayOf<File>()
    val ktFiles = allFiles.filter { file ->
        file.isFile && file.name.endsWith(".kt") && !file.name.startsWith("test_")
    }.sortedBy { it.name }
    
    if (ktFiles.isEmpty()) {
        println("${RED}No Kotlin files found to test$RESET")
        kotlin.system.exitProcess(1)
    }
    
    println("${BLUE}Testing ${ktFiles.size} Kotlin sample files...$RESET\n")
    
    val results = mutableListOf<Pair<String, Boolean>>()
    for (file in ktFiles) {
        val fileName = file.name
        println("${BLUE}Testing: $fileName$RESET")
        
        val syntax = checkSyntax(file)
        val imports = checkImports(file)
        val structure = checkStructure(file)
        
        if (syntax.first) {
            println("  ${GREEN}${syntax.second}$RESET")
        } else {
            println("  ${RED}${syntax.second}$RESET")
        }
        
        if (imports.first) {
            println("  ${GREEN}${imports.second}$RESET")
        } else {
            println("  ${YELLOW}${imports.second}$RESET")
        }
        
        if (structure.first) {
            println("  ${GREEN}${structure.second}$RESET")
        } else {
            println("  ${YELLOW}${structure.second}$RESET")
        }
        
        val allOk = syntax.first && imports.first && structure.first
        results.add(Pair(fileName, allOk))
        println()
    }
    
    // Summary
    println("${BLUE}${"=".repeat(60)}$RESET")
    println("${BLUE}Summary:$RESET\n")
    
    var passed = 0
    for ((name, ok) in results) {
        if (ok) {
            println("  ${GREEN}✓ PASS$RESET - $name")
            passed++
        } else {
            println("  ${YELLOW}⚠ PARTIAL$RESET - $name")
        }
    }
    
    val total = results.size
    println("\n${BLUE}Results: $passed/$total files passed all checks$RESET")
    
    if (passed == total) {
        println("${GREEN}All files are valid! ✓$RESET")
        kotlin.system.exitProcess(0)
    } else {
        println("${YELLOW}Some files need attention$RESET")
        kotlin.system.exitProcess(1)
    }
}
