import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.lists.ListUpdateParams
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Create or update a notification list using the Courier Java SDK.
 */
fun main() {
    try {
        val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
        val listId = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_ID")
        val listName = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_NAME", "My List Name")

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Error: COURIER_API_KEY environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (listId == null || listId.isEmpty()) {
            System.err.println("Error: COURIER_CREATE_LIST_LIST_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        // Initialize Courier client using the SDK
        val client: CourierClient = CourierOkHttpClient.builder()
            .apiKey(apiKey)
            .build()

        // Build request parameters using the SDK's builder pattern
        val preferencesMap = mutableMapOf<String, Any>()
        preferencesMap["categories"] = mutableMapOf<String, Any>()
        preferencesMap["notifications"] = mutableMapOf<String, Any>()
        
        val bodyBuilder = ListUpdateParams.Body.builder()
            .name(listName ?: "My List Name")
        bodyBuilder.preferences(JsonValue.from(preferencesMap))
        
        val params = ListUpdateParams.builder()
            .listId(listId)
            .body(bodyBuilder.build())
            .build()

        // Create or update list using the SDK (returns void)
        client.lists().update(params)
        
        // Print success message since update returns void
        val successResponse = mapOf(
            "success" to true,
            "message" to "List '$listId' created/updated successfully",
            "list_id" to listId,
            "list_name" to listName
        )

        // Print response as JSON
        val mapper = ObjectMapper()
        println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(successResponse))
    } catch (e: Exception) {
        System.err.println("Error: ${e.message}")
        e.printStackTrace()
        kotlin.system.exitProcess(1)
    }
}
