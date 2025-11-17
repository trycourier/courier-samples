import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.lists.subscriptions.SubscriptionSubscribeUserParams;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

/**
 * Subscribe a user to a list using the Courier Java SDK.
 */
public class SubscribeUser {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID");
            String userId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (listId == null || listId.isEmpty()) {
                System.err.println("Error: COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID environment variable is required");
                System.exit(1);
            }

            if (userId == null || userId.isEmpty()) {
                System.err.println("Error: COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                    .apiKey(apiKey)
                    .build();

            // Build request parameters using the SDK's builder pattern
            SubscriptionSubscribeUserParams params = SubscriptionSubscribeUserParams.builder()
                    .listId(listId)
                    .userId(userId)
                    .body(SubscriptionSubscribeUserParams.Body.builder()
                            .build())
                    .build();

            // Subscribe user to list using the SDK (returns void)
            client.lists().subscriptions().subscribeUser(params);

            // Print success message since subscribeUser returns void
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("status", "success");
            successResponse.put("message", "User subscribed successfully");
            ObjectMapper mapper = new ObjectMapper();
            System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(successResponse));
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

