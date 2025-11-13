import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Generate JWT tokens for user authentication.
 */
public class GenerateJwt {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String userId = EnvLoader.getEnv("COURIER_GENERATE_JWT_USER_ID");
            String expiresInDays = EnvLoader.getEnv("COURIER_EXPIRES_IN_DAYS", "30");

            CourierClient client = new CourierClient(apiKey);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("scope", "user_id:" + userId + " write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands");
            requestBody.put("expires_in", expiresInDays + " days");

            JsonNode response = client.post("/auth/issue-token", requestBody);

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

