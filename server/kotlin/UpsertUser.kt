import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.profiles.ProfileCreateParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val userId = EnvLoader.getEnv("COURIER_UPSERT_USER_USER_ID")
    val email = EnvLoader.getEnv("COURIER_UPSERT_USER_EMAIL")
    val name = EnvLoader.getEnv("COURIER_UPSERT_USER_NAME")
    val phoneNumber = EnvLoader.getEnv("COURIER_UPSERT_USER_PHONE_NUMBER")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val profileMap = mutableMapOf<String, Any>()
    if (!email.isNullOrEmpty()) profileMap["email"] = email
    if (!name.isNullOrEmpty()) profileMap["name"] = name
    if (!phoneNumber.isNullOrEmpty()) profileMap["phone_number"] = phoneNumber

    val params = ProfileCreateParams.builder()
        .userId(userId)
        .body(
            ProfileCreateParams.Body.builder()
                .profile(JsonValue.from(profileMap))
                .build()
        )
        .build()

    val response = client.profiles().create(params)
    println(response)
}

