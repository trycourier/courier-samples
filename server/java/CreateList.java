import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.lists.ListUpdateParams;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

/**
 * Create or update a notification list using the Courier Java SDK.
 */
public class CreateList {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_ID");
            String listName = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_NAME", "My List Name");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (listId == null || listId.isEmpty()) {
                System.err.println("Error: COURIER_CREATE_LIST_LIST_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                    .apiKey(apiKey)
                    .build();

            // Build request parameters using the SDK's builder pattern
            Map<String, Object> preferencesMap = new HashMap<>();
            preferencesMap.put("categories", new HashMap<>());
            preferencesMap.put("notifications", new HashMap<>());
            
            ListUpdateParams params = ListUpdateParams.builder()
                    .listId(listId)
                    .body(ListUpdateParams.Body.builder()
                            .name(listName)
                            .preferences(JsonValue.from(preferencesMap))
                            .build())
                    .build();

            // Create or update list using the SDK (returns void)
            client.lists().update(params);
            
            // Print success message since update returns void
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("success", true);
            successResponse.put("message", "List '" + listId + "' created/updated successfully");
            successResponse.put("list_id", listId);
            successResponse.put("list_name", listName);
            var response = successResponse;

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

