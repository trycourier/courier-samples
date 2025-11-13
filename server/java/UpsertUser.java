import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Create or update a user profile.
 */
public class UpsertUser {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String userId = EnvLoader.getEnv("COURIER_UPSERT_USER_USER_ID");
            String email = EnvLoader.getEnv("COURIER_UPSERT_USER_EMAIL");
            String name = EnvLoader.getEnv("COURIER_UPSERT_USER_NAME");
            String phoneNumber = EnvLoader.getEnv("COURIER_UPSERT_USER_PHONE_NUMBER");

            CourierClient client = new CourierClient(apiKey);

            // Build profile object dynamically, only including fields that are set
            // Note: All profile fields are optional. If you skip them, an empty profile will be created.
            Map<String, Object> profile = new HashMap<>();
            if (email != null && !email.isEmpty()) {
                profile.put("email", email);
            }
            if (name != null && !name.isEmpty()) {
                profile.put("name", name);
            }
            if (phoneNumber != null && !phoneNumber.isEmpty()) {
                profile.put("phone_number", phoneNumber);
            }

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("profile", profile);

            JsonNode response = client.put("/profiles/" + userId, requestBody);

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

