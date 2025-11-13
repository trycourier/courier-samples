import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Unsubscribe a user from a list.
 */
public class UnsubscribeUser {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID");
            String userId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID");

            CourierClient client = new CourierClient(apiKey);

            JsonNode response = client.delete("/lists/" + listId + "/subscriptions/" + userId);

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

