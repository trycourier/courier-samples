import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.lists.ListUpdateParams

fun main() {
    val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
    val listId = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_ID")
    val listName = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_NAME", "My List Name")

    val client = CourierOkHttpClient.builder()
        .apiKey(apiKey)
        .build()

    val params = ListUpdateParams.builder()
        .listId(listId)
        .body(
            ListUpdateParams.Body.builder()
                .name(listName ?: "My List Name")
                .preferences(JsonValue.from(mapOf("categories" to mapOf<String, Any>(), "notifications" to mapOf<String, Any>())))
                .build()
        )
        .build()

    client.lists().update(params)
}
