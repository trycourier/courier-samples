import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Create or update a notification list.
 */
public class CreateList {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_ID");
            String listName = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_NAME", "My List Name");

            CourierClient client = new CourierClient(apiKey);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("name", listName);
            
            Map<String, Object> preferences = new HashMap<>();
            preferences.put("categories", new HashMap<>());
            preferences.put("notifications", new HashMap<>());
            requestBody.put("preferences", preferences);

            JsonNode response = client.put("/lists/" + listId, requestBody);

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

