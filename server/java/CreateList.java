import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.lists.ListUpdateParams;
import java.util.Map;

public class CreateList {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String listId = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_ID");
        String listName = EnvLoader.getEnv("COURIER_CREATE_LIST_LIST_NAME", "My List Name");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        ListUpdateParams params = ListUpdateParams.builder()
                .listId(listId)
                .body(ListUpdateParams.Body.builder()
                        .name(listName)
                        .preferences(JsonValue.from(Map.of("categories", Map.of(), "notifications", Map.of())))
                        .build())
                .build();

        client.lists().update(params);
    }
}

