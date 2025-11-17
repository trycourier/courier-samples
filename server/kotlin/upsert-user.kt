import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.core.JsonValue
import com.courier.models.profiles.ProfileReplaceParams
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Create or update a user profile using the Courier Java SDK.
 */
fun main() {
    try {
        val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
        val userId = EnvLoader.getEnv("COURIER_UPSERT_USER_USER_ID")
        val email = EnvLoader.getEnv("COURIER_UPSERT_USER_EMAIL")
        val name = EnvLoader.getEnv("COURIER_UPSERT_USER_NAME")
        val phoneNumber = EnvLoader.getEnv("COURIER_UPSERT_USER_PHONE_NUMBER")

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Error: COURIER_API_KEY environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (userId == null || userId.isEmpty()) {
            System.err.println("Error: COURIER_UPSERT_USER_USER_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        // Initialize Courier client using the SDK
        val client: CourierClient = CourierOkHttpClient.builder()
            .apiKey(apiKey)
            .build()

        // Build profile object dynamically, only including fields that are set
        // Note: All profile fields are optional. If you skip them, an empty profile will be created.
        val profileMap = mutableMapOf<String, Any>()
        if (!email.isNullOrEmpty()) {
            profileMap["email"] = email
        }
        if (!name.isNullOrEmpty()) {
            profileMap["name"] = name
        }
        if (!phoneNumber.isNullOrEmpty()) {
            profileMap["phone_number"] = phoneNumber
        }

        // Build request parameters using the SDK's builder pattern
        val params = ProfileReplaceParams.builder()
            .userId(userId)
            .body(
                ProfileReplaceParams.Body.builder()
                    .profile(JsonValue.from(profileMap))
                    .build()
            )
            .build()

        // Create or update user profile using the SDK
        val response = client.profiles().replace(params)

        // Print response as JSON
        val mapper = ObjectMapper()
        println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(response))
    } catch (e: Exception) {
        System.err.println("Error: ${e.message}")
        e.printStackTrace()
        kotlin.system.exitProcess(1)
    }
}

