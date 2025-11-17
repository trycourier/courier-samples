import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.profiles.ProfileReplaceParams;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

/**
 * Create or update a user profile using the Courier Java SDK.
 */
public class UpsertUser {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String userId = EnvLoader.getEnv("COURIER_UPSERT_USER_USER_ID");
            String email = EnvLoader.getEnv("COURIER_UPSERT_USER_EMAIL");
            String name = EnvLoader.getEnv("COURIER_UPSERT_USER_NAME");
            String phoneNumber = EnvLoader.getEnv("COURIER_UPSERT_USER_PHONE_NUMBER");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (userId == null || userId.isEmpty()) {
                System.err.println("Error: COURIER_UPSERT_USER_USER_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                    .apiKey(apiKey)
                    .build();

            // Build profile object dynamically, only including fields that are set
            // Note: All profile fields are optional. If you skip them, an empty profile will be created.
            Map<String, Object> profileMap = new HashMap<>();
            if (email != null && !email.isEmpty()) {
                profileMap.put("email", email);
            }
            if (name != null && !name.isEmpty()) {
                profileMap.put("name", name);
            }
            if (phoneNumber != null && !phoneNumber.isEmpty()) {
                profileMap.put("phone_number", phoneNumber);
            }

            // Build request parameters using the SDK's builder pattern
            ProfileReplaceParams params = ProfileReplaceParams.builder()
                    .userId(userId)
                    .body(ProfileReplaceParams.Body.builder()
                            .profile(JsonValue.from(profileMap))
                            .build())
                    .build();

            // Create or update user profile using the SDK
            var response = client.profiles().replace(params);

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

