import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.send.SendMessageParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val tenantId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID")
    val templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = SendMessageParams.builder()
        .message(
            SendMessageParams.Message.builder()
                .to(JsonValue.from(mapOf("tenant_id" to tenantId)))
                .template(templateId)
                .build()
        )
        .build()

    val response = client.send().message(params)
    println(response)
}

