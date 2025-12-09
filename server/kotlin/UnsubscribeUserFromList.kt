import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.models.lists.subscriptions.SubscriptionUnsubscribeUserParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val listId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID")
    val userId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = SubscriptionUnsubscribeUserParams.builder()
        .listId(listId)
        .userId(userId)
        .build()

    client.lists().subscriptions().unsubscribeUser(params)
}

