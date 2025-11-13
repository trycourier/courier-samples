import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Utility class for making HTTP requests to the Courier API.
 */
public class CourierClient {
    private static final String BASE_URL = "https://api.courier.com";
    private final HttpClient httpClient;
    private final String apiKey;
    private final ObjectMapper objectMapper;

    public CourierClient(String apiKey) {
        this.apiKey = apiKey;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Makes a POST request to the Courier API.
     */
    public JsonNode post(String endpoint, Object body) throws IOException, InterruptedException {
        String jsonBody = objectMapper.writeValueAsString(body);
        
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                .timeout(Duration.ofSeconds(30))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() >= 200 && response.statusCode() < 300) {
            String responseBody = response.body();
            if (responseBody == null || responseBody.isEmpty()) {
                // Return success object for empty responses
                return objectMapper.createObjectNode().put("success", true);
            }
            return objectMapper.readTree(responseBody);
        } else {
            String errorBody = response.body();
            if (errorBody != null && !errorBody.isEmpty()) {
                try {
                    return objectMapper.readTree(errorBody);
                } catch (Exception e) {
                    // If parsing fails, create error object
                    JsonNode errorNode = objectMapper.createObjectNode()
                            .put("error", errorBody)
                            .put("statusCode", response.statusCode());
                    return errorNode;
                }
            }
            JsonNode errorNode = objectMapper.createObjectNode()
                    .put("error", "Request failed")
                    .put("statusCode", response.statusCode());
            return errorNode;
        }
    }

    /**
     * Makes a GET request to the Courier API.
     */
    public JsonNode get(String endpoint) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + apiKey)
                .header("Accept", "application/json")
                .GET()
                .timeout(Duration.ofSeconds(30))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() >= 200 && response.statusCode() < 300) {
            String responseBody = response.body();
            if (responseBody == null || responseBody.isEmpty()) {
                return objectMapper.createObjectNode().put("success", true);
            }
            return objectMapper.readTree(responseBody);
        } else {
            String errorBody = response.body();
            if (errorBody != null && !errorBody.isEmpty()) {
                try {
                    return objectMapper.readTree(errorBody);
                } catch (Exception e) {
                    JsonNode errorNode = objectMapper.createObjectNode()
                            .put("error", errorBody)
                            .put("statusCode", response.statusCode());
                    return errorNode;
                }
            }
            JsonNode errorNode = objectMapper.createObjectNode()
                    .put("error", "Request failed")
                    .put("statusCode", response.statusCode());
            return errorNode;
        }
    }

    /**
     * Makes a PUT request to the Courier API.
     */
    public JsonNode put(String endpoint, Object body) throws IOException, InterruptedException {
        String jsonBody = objectMapper.writeValueAsString(body);
        
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .header("Accept", "application/json")
                .PUT(HttpRequest.BodyPublishers.ofString(jsonBody))
                .timeout(Duration.ofSeconds(30))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() >= 200 && response.statusCode() < 300) {
            String responseBody = response.body();
            if (responseBody == null || responseBody.isEmpty()) {
                return objectMapper.createObjectNode().put("success", true);
            }
            return objectMapper.readTree(responseBody);
        } else {
            String errorBody = response.body();
            if (errorBody != null && !errorBody.isEmpty()) {
                try {
                    return objectMapper.readTree(errorBody);
                } catch (Exception e) {
                    JsonNode errorNode = objectMapper.createObjectNode()
                            .put("error", errorBody)
                            .put("statusCode", response.statusCode());
                    return errorNode;
                }
            }
            JsonNode errorNode = objectMapper.createObjectNode()
                    .put("error", "Request failed")
                    .put("statusCode", response.statusCode());
            return errorNode;
        }
    }

    /**
     * Makes a DELETE request to the Courier API.
     */
    public JsonNode delete(String endpoint) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(BASE_URL + endpoint))
                .header("Authorization", "Bearer " + apiKey)
                .header("Accept", "application/json")
                .DELETE()
                .timeout(Duration.ofSeconds(30))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() >= 200 && response.statusCode() < 300) {
            String responseBody = response.body();
            if (responseBody == null || responseBody.isEmpty()) {
                return objectMapper.createObjectNode().put("success", true);
            }
            return objectMapper.readTree(responseBody);
        } else {
            String errorBody = response.body();
            if (errorBody != null && !errorBody.isEmpty()) {
                try {
                    return objectMapper.readTree(errorBody);
                } catch (Exception e) {
                    JsonNode errorNode = objectMapper.createObjectNode()
                            .put("error", errorBody)
                            .put("statusCode", response.statusCode());
                    return errorNode;
                }
            }
            JsonNode errorNode = objectMapper.createObjectNode()
                    .put("error", "Request failed")
                    .put("statusCode", response.statusCode());
            return errorNode;
        }
    }
}

