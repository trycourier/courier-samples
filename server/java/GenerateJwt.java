import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.auth.AuthIssueTokenParams;

public class GenerateJwt {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String userId = EnvLoader.getEnv("COURIER_GENERATE_JWT_USER_ID");
        String expiresInDays = EnvLoader.getEnv("COURIER_EXPIRES_IN_DAYS", "30");

        CourierClient client = CourierOkHttpClient.builder()
            .apiKey(apiKey)
            .build();

        AuthIssueTokenParams params = AuthIssueTokenParams.builder()
            .body(AuthIssueTokenParams.Body.builder()
                .scope("user_id:" + userId + " write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands")
                .expiresIn(expiresInDays + " days")
                .build())
            .build();

        var response = client.auth().issueToken(params);
        System.out.println(response);
    }
}

