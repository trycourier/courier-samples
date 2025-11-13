import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Send notifications to a list.
 */
public class SendTemplateToList {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID");
            String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID");

            CourierClient client = new CourierClient(apiKey);

            Map<String, Object> to = new HashMap<>();
            to.put("list_id", listId);

            Map<String, Object> message = new HashMap<>();
            message.put("to", to);
            message.put("template", templateId);

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

