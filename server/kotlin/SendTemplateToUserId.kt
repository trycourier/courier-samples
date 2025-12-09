import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.send.SendMessageParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val userId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID")
    val templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = SendMessageParams.builder()
        .message(
            SendMessageParams.Message.builder()
                .to(JsonValue.from(mapOf("user_id" to userId)))
                .template(templateId)
                .data(JsonValue.from(mapOf("name" to "Your Name")))
                .build()
        )
        .build()

    val response = client.send().message(params)
    println(response)
}

