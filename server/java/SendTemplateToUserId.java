import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Send notifications to a user ID.
 */
public class SendTemplateToUserId {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String userId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID");
            String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID");

            CourierClient client = new CourierClient(apiKey);

            Map<String, Object> to = new HashMap<>();
            to.put("user_id", userId);

            Map<String, Object> data = new HashMap<>();
            data.put("name", "Your Name");

            Map<String, Object> message = new HashMap<>();
            message.put("to", to);
            message.put("template", templateId);
            message.put("data", data);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("message", message);

            JsonNode response = client.post("/send", requestBody);

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

