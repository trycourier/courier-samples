import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.lists.subscriptions.SubscriptionUnsubscribeUserParams;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

/**
 * Unsubscribe a user from a list using the Courier Java SDK.
 */
public class UnsubscribeUser {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID");
            String userId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (listId == null || listId.isEmpty()) {
                System.err.println("Error: COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID environment variable is required");
                System.exit(1);
            }

            if (userId == null || userId.isEmpty()) {
                System.err.println("Error: COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                    .apiKey(apiKey)
                    .build();

            // Build request parameters using the SDK's builder pattern
            SubscriptionUnsubscribeUserParams params = SubscriptionUnsubscribeUserParams.builder()
                    .listId(listId)
                    .userId(userId)
                    .build();

            // Unsubscribe user from list using the SDK (returns void)
            client.lists().subscriptions().unsubscribeUser(params);

            // Print success message since unsubscribeUser returns void
            Map<String, Object> successResponse = new HashMap<>();
            successResponse.put("status", "success");
            successResponse.put("message", "User unsubscribed successfully");
            ObjectMapper mapper = new ObjectMapper();
            System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(successResponse));
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

