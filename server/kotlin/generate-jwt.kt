import com.courier.client.CourierClient
import com.courier.client.okhttp.CourierOkHttpClient
import com.courier.models.auth.AuthIssueTokenParams
import com.fasterxml.jackson.databind.ObjectMapper

/**
 * Generate JWT tokens for user authentication using the Courier Java SDK.
 */
fun main() {
    try {
        val apiKey = EnvLoader.getEnv("COURIER_API_KEY")
        val userId = EnvLoader.getEnv("COURIER_GENERATE_JWT_USER_ID")
        val expiresInDays = EnvLoader.getEnv("COURIER_EXPIRES_IN_DAYS") ?: "30"

        if (apiKey == null || apiKey.isEmpty()) {
            System.err.println("Error: COURIER_API_KEY environment variable is required")
            kotlin.system.exitProcess(1)
        }

        if (userId == null || userId.isEmpty()) {
            System.err.println("Error: COURIER_GENERATE_JWT_USER_ID environment variable is required")
            kotlin.system.exitProcess(1)
        }

        // Initialize Courier client using the SDK
        val client: CourierClient = CourierOkHttpClient.builder()
            .apiKey(apiKey)
            .build()

        // Build request parameters using the SDK's builder pattern
        val scope = "user_id:$userId write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands"
        val expiresIn = "$expiresInDays days"
        
        val params = AuthIssueTokenParams.builder()
            .body(
                AuthIssueTokenParams.Body.builder()
                    .scope(scope)
                    .expiresIn(expiresIn)
                    .build()
            )
            .build()

        // Issue token using the SDK
        val response = client.auth().issueToken(params)

        // Print response as JSON
        val mapper = ObjectMapper()
        println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(response))
    } catch (e: Exception) {
        System.err.println("Error: ${e.message}")
        e.printStackTrace()
        kotlin.system.exitProcess(1)
    }
}

