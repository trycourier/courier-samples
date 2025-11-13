import java.io.File
import java.net.HttpURLConnection
import java.net.URL

// Load environment variables from .env file in server directory (shared across all language examples)
fun loadEnv(): Map<String, String> {
    val envFile = File("..").resolve(".env")
    val env = mutableMapOf<String, String>()
    if (envFile.exists()) {
        envFile.readLines().forEach { line ->
            val trimmed = line.trim()
            if (trimmed.isNotEmpty() && !trimmed.startsWith("#") && trimmed.contains("=")) {
                val parts = trimmed.split("=", limit = 2)
                if (parts.size == 2) {
                    var key = parts[0].trim()
                    var value = parts[1].trim()
                    if (value.startsWith("\"") && value.endsWith("\"")) {
                        value = value.substring(1, value.length - 1)
                    }
                    env[key] = value
                }
            }
        }
    }
    return env
}

val env = loadEnv()
val apiKey = env["COURIER_API_KEY"] ?: ""
val userId = env["COURIER_UPSERT_USER_USER_ID"] ?: ""
val email = env["COURIER_UPSERT_USER_EMAIL"] ?: ""
val name = env["COURIER_UPSERT_USER_NAME"] ?: ""
val phoneNumber = env["COURIER_UPSERT_USER_PHONE_NUMBER"] ?: ""

fun main() {
    // Build profile object dynamically, only including fields that are set
    // Note: All profile fields are optional. If you skip them, an empty profile will be created.
    val profileParts = mutableListOf<String>()
    if (email.isNotEmpty()) {
        profileParts.add("\"email\": \"${email.replace("\"", "\\\"")}\"")
    }
    if (name.isNotEmpty()) {
        profileParts.add("\"name\": \"${name.replace("\"", "\\\"")}\"")
    }
    if (phoneNumber.isNotEmpty()) {
        profileParts.add("\"phone_number\": \"${phoneNumber.replace("\"", "\\\"")}\"")
    }
    val profileJson = "{${profileParts.joinToString(", ")}}"

    // Build request body
    val requestBody = """
        {
            "profile": $profileJson
        }
    """.trimIndent()

    // Make API request
    val url = URL("https://api.courier.com/profiles/$userId")
    val connection = url.openConnection() as HttpURLConnection
    connection.requestMethod = "POST"
    connection.setRequestProperty("Authorization", "Bearer $apiKey")
    connection.setRequestProperty("Content-Type", "application/json")
    connection.setRequestProperty("Accept", "application/json")
    connection.doOutput = true

    try {
        connection.outputStream.use { output ->
            output.write(requestBody.toByteArray())
        }

        val responseCode = connection.responseCode
        val responseBody = if (responseCode >= 200 && responseCode < 300) {
            connection.inputStream.bufferedReader().use { it.readText() }
        } else {
            connection.errorStream?.bufferedReader()?.use { it.readText() } ?: ""
        }

        if (responseCode >= 200 && responseCode < 300) {
            println(responseBody)
        } else {
            println(responseBody)
            kotlin.system.exitProcess(1)
        }
    } catch (e: Exception) {
        println("{\"error\": \"${e.message}\"}")
        kotlin.system.exitProcess(1)
    } finally {
        connection.disconnect()
    }
}

