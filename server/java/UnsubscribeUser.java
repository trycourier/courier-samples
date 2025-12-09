import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.lists.subscriptions.SubscriptionUnsubscribeUserParams;

public class UnsubscribeUser {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String listId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID");
        String userId = EnvLoader.getEnv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        SubscriptionUnsubscribeUserParams params = SubscriptionUnsubscribeUserParams.builder()
                .listId(listId)
                .userId(userId)
                .build();

        client.lists().subscriptions().unsubscribeUser(params);
    }
}

