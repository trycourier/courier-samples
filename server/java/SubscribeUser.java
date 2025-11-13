import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Subscribe a user to a list.
 */
public class SubscribeUser {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID");
            String userId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID");

            CourierClient client = new CourierClient(apiKey);

            JsonNode response = client.put("/lists/" + listId + "/subscriptions/" + userId, new java.util.HashMap<>());

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

