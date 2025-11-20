import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.send.SendMessageParams;

public class SendTemplateToEmail {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String email = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL");
        String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        SendMessageParams params = SendMessageParams.builder()
                .message(SendMessageParams.Message.builder()
                        .to(JsonValue.from(java.util.Map.of("email", email)))
                        .template(templateId)
                        .data(JsonValue.from(java.util.Map.of("name", "Your Name")))
                        .build())
                .build();

        var response = client.send().message(params);
        System.out.println(response);
    }
}

