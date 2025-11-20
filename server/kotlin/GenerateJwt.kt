import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.models.auth.AuthIssueTokenParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val userId = EnvLoader.getEnv("COURIER_GENERATE_JWT_USER_ID")
    val expiresInDays = EnvLoader.getEnv("COURIER_EXPIRES_IN_DAYS") ?: "30"

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = AuthIssueTokenParams.builder()
        .body(
            AuthIssueTokenParams.Body.builder()
                .scope("user_id:$userId write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands")
                .expiresIn("$expiresInDays days")
                .build()
        )
        .build()

    val response = client.auth().issueToken(params)
    println(response)
}

