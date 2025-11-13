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
val audienceId = env["COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID"] ?: ""
val templateId = env["COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID"] ?: ""

fun main() {
    // Build request body
    val requestBody = """
        {
            "message": {
                "to": {
                    "audience_id": "$audienceId"
                },
                "template": "$templateId"
            }
        }
    """.trimIndent()

    // Make API request
    val url = URL("https://api.courier.com/send")
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

