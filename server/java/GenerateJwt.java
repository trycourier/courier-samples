import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.auth.AuthIssueTokenParams;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Generate JWT tokens for user authentication using the Courier Java SDK.
 */
public class GenerateJwt {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String userId = EnvLoader.getEnv("COURIER_GENERATE_JWT_USER_ID");
            String expiresInDays = EnvLoader.getEnv("COURIER_EXPIRES_IN_DAYS", "30");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (userId == null || userId.isEmpty()) {
                System.err.println("Error: COURIER_GENERATE_JWT_USER_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

            // Build request parameters using the SDK's builder pattern
            String scope = "user_id:" + userId + " write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands";
            String expiresIn = expiresInDays + " days";
            
            AuthIssueTokenParams params = AuthIssueTokenParams.builder()
                .body(AuthIssueTokenParams.Body.builder()
                    .scope(scope)
                    .expiresIn(expiresIn)
                    .build())
                .build();

            // Issue token using the SDK
            var response = client.auth().issueToken(params);

            // Print response as JSON
            ObjectMapper mapper = new ObjectMapper();
            System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(response));
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

