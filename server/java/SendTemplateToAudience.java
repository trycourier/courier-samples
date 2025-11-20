import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.send.SendMessageParams;

public class SendTemplateToAudience {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String audienceId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID");
        String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        SendMessageParams params = SendMessageParams.builder()
                .message(SendMessageParams.Message.builder()
                        .to(JsonValue.from(java.util.Map.of("audience_id", audienceId)))
                        .template(templateId)
                        .build())
                .build();

        var response = client.send().message(params);
        System.out.println(response);
    }
}

