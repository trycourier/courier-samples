import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.send.SendMessageParams
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Send notifications to a tenant using the Courier Java SDK.
 */
fun main() {
    try {
        val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
        val tenantId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID")
        val templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID")

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Error: COURIER_API_KEY environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (tenantId == null || tenantId.isEmpty()) {
            System.err.println("Error: COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (templateId == null || templateId.isEmpty()) {
            System.err.println("Error: COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID environment variable is required")
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
                    .to(JsonValue.from(mapOf("tenant_id" to tenantId)))
                    .template(templateId)
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

