import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.models.profiles.ProfileRetrieveParams;

public class GetUserProfile {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String userId = EnvLoader.getEnv("COURIER_GET_USER_PROFILE_USER_ID");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        ProfileRetrieveParams params = ProfileRetrieveParams.builder()
                .userId(userId)
                .build();

        var response = client.profiles().retrieve(params);
        System.out.println(response);
    }
}

