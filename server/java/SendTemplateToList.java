import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.send.SendMessageParams;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Send notifications to a list using the Courier Java SDK.
 */
public class SendTemplateToList {
    public static void main(String[] args) {
        try {
            String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
            String listId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID");
            String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID");

            if (apiKey == null || apiKey.isEmpty()) {
                System.err.println("Error: COURIER_API_KEY environment variable is required");
                System.exit(1);
            }

            if (listId == null || listId.isEmpty()) {
                System.err.println("Error: COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID environment variable is required");
                System.exit(1);
            }

            if (templateId == null || templateId.isEmpty()) {
                System.err.println("Error: COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID environment variable is required");
                System.exit(1);
            }

            // Initialize Courier client using the SDK
            CourierClient client = CourierOkHttpClient.builder()
                    .apiKey(apiKey)
                    .build();

            // Build request parameters using the SDK's builder pattern
            SendMessageParams params = SendMessageParams.builder()
                    .message(SendMessageParams.Message.builder()
                            .to(JsonValue.from(java.util.Map.of("list_id", listId)))
                            .template(templateId)
                            .build())
                    .build();

            // Send message using the SDK
            var response = client.send().message(params);

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

