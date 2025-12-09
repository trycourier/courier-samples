import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.lists.subscriptions.SubscriptionSubscribeUserParams;

public class SubscribeUser {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String listId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID");
        String userId = EnvLoader.getEnv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        SubscriptionSubscribeUserParams params = SubscriptionSubscribeUserParams.builder()
                .listId(listId)
                .userId(userId)
                .body(SubscriptionSubscribeUserParams.Body.builder().build())
                .build();

        client.lists().subscriptions().subscribeUser(params);
    }
}

