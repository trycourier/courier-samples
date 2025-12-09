import com.courier.client.CourierClient;
import com.courier.client.okhttp.CourierOkHttpClient;
import com.courier.core.JsonValue;
import com.courier.models.send.SendMessageParams;

public class SendTemplateToTenant {
    public static void main(String[] args) {
        String apiKey = EnvLoader.getEnv("COURIER_API_KEY");
        String tenantId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID");
        String templateId = EnvLoader.getEnv("COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID");

        CourierClient client = CourierOkHttpClient.builder()
                .apiKey(apiKey)
                .build();

        SendMessageParams params = SendMessageParams.builder()
                .message(SendMessageParams.Message.builder()
                        .to(JsonValue.from(java.util.Map.of("tenant_id", tenantId)))
                        .template(templateId)
                        .build())
                .build();

        var response = client.send().message(params);
        System.out.println(response);
    }
}

