import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Send notifications to an email address.
 */
public class SendTemplateToEmail {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String email = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL");
            String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID");

            CourierClient client = new CourierClient(apiKey);

            Map<String, Object> to = new HashMap<>();
            to.put("email", email);

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

