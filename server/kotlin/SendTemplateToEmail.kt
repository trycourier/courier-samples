import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.send.SendMessageParams
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Send notifications to an email address using the Courier Java SDK.
 */
fun main() {
    try {
        val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
        val email = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL")
        val templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID")

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Error: COURIER_API_KEY environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (email == null || email.isEmpty()) {
            System.err.println("Error: COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (templateId == null || templateId.isEmpty()) {
            System.err.println("Error: COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        // Initialize Courier client using the SDK
        val client: CourierClient = CourierOkHttpClient.builder()
            .apiKey(apiKey)
            .build()

        // Build request parameters using the SDK's builder pattern
        val params = SendMessageParams.builder()
            .message(
                SendMessageParams.Message.builder()
                    .to(JsonValue.from(mapOf("email" to email)))
                    .template(templateId)
                    .data(JsonValue.from(mapOf("name" to "Your Name")))
                    .build()
            )
            .build()

        // Send message using the SDK
        val response = client.send().message(params)

        // Print response as JSON
        val mapper = ObjectMapper()
        println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(response))
    } catch (e: Exception) {
        System.err.println("Error: ${e.message}")
        e.printStackTrace()
        kotlin.system.exitProcess(1)
    }
}

