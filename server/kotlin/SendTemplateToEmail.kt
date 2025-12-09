import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.send.SendMessageParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val email = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL")
    val templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = SendMessageParams.builder()
        .message(
            SendMessageParams.Message.builder()
                .to(JsonValue.from(mapOf("email" to email)))
                .template(templateId)
                .data(JsonValue.from(mapOf("name" to "Your Name")))
                .build()
        )
        .build()

    val response = client.send().message(params)
    println(response)
}

