import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.profiles.ProfileReplaceParams;
import java.util.HashMap;
import java.util.Map;

public class UpsertUser {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String userId = EnvLoader.getEnv("COURIER_UPSERT_USER_USER_ID");
        String email = EnvLoader.getEnv("COURIER_UPSERT_USER_EMAIL");
        String name = EnvLoader.getEnv("COURIER_UPSERT_USER_NAME");
        String phoneNumber = EnvLoader.getEnv("COURIER_UPSERT_USER_PHONE_NUMBER");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        Map<String, Object> profileMap = new HashMap<>();
        if (email != null && !email.isEmpty()) profileMap.put("email", email);
        if (name != null && !name.isEmpty()) profileMap.put("name", name);
        if (phoneNumber != null && !phoneNumber.isEmpty()) profileMap.put("phone_number", phoneNumber);

        ProfileReplaceParams params = ProfileReplaceParams.builder()
                .userId(userId)
                .body(ProfileReplaceParams.Body.builder()
                        .profile(JsonValue.from(profileMap))
                        .build())
                .build();

        var response = client.profiles().replace(params);
        System.out.println(response);
    }
}

