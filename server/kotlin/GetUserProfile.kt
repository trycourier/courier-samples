import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.models.profiles.ProfileRetrieveParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val userId = EnvLoader.getEnv("COURIER_GET_USER_PROFILE_USER_ID")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = ProfileRetrieveParams.builder()
        .userId(userId)
        .build()

    val response = client.profiles().retrieve(params)
    println(response)
}

