import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.models.lists.subscriptions.SubscriptionSubscribeUserParams
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Subscribe a user to a list using the Courier Java SDK.
 */
fun main() {
    try {
        val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
        val listId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID")
        val userId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID")

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Error: COURIER_API_KEY environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (listId == null || listId.isEmpty()) {
            System.err.println("Error: COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (userId == null || userId.isEmpty()) {
            System.err.println("Error: COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        // Initialize Courier client using the SDK
        val client: CourierClient = CourierOkHttpClient.builder()
            .apiKey(apiKey)
            .build()

        // Build request parameters using the SDK's builder pattern
        val params = SubscriptionSubscribeUserParams.builder()
            .listId(listId)
            .userId(userId)
            .body(
                SubscriptionSubscribeUserParams.Body.builder()
                    .build()
            )
            .build()

        // Subscribe user to list using the SDK (returns void)
        client.lists().subscriptions().subscribeUser(params)

        // Print success message since subscribeUser returns void
        val successResponse = mapOf(
            "status" to "success",
            "message" to "User subscribed successfully"
        )
        val mapper = ObjectMapper()
        println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(successResponse))
    } catch (e: Exception) {
        System.err.println("Error: ${e.message}")
        e.printStackTrace()
        kotlin.system.exitProcess(1)
    }
}

