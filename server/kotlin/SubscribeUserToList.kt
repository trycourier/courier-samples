import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.models.lists.subscriptions.SubscriptionSubscribeUserParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val listId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID")
    val userId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = SubscriptionSubscribeUserParams.builder()
        .listId(listId)
        .userId(userId)
        .body(SubscriptionSubscribeUserParams.Body.builder().build())
        .build()

    client.lists().subscriptions().subscribeUser(params)
}

