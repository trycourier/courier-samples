import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.profiles.ProfileRetrieveParams;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Retrieve a user profile using the Courier Java SDK.
 */
public class GetUserProfile {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String userId = EnvLoader.getEnv("COURIER_GET_USER_PROFILE_USER_ID");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (userId == null || userId.isEmpty()) {
                System.err.println("Error: COURIER_GET_USER_PROFILE_USER_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                    .apiKey(apiKey)
                    .build();

            // Build request parameters using the SDK's builder pattern
            ProfileRetrieveParams params = ProfileRetrieveParams.builder()
                    .userId(userId)
                    .build();

            // Retrieve user profile using the SDK
            var response = client.profiles().retrieve(params);

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

