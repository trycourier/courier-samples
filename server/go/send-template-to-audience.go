package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables from .env file in server directory (shared across all language examples)
	envPath := filepath.Join("..", ".env")
	godotenv.Load(envPath)

	apiKey := os.Getenv("COURIER_API_KEY")
	audienceID := os.Getenv("COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID")
	templateID := os.Getenv("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID")

	// Build request body
	requestBody := map[string]interface{}{
		"message": map[string]interface{}{
			"to": map[string]interface{}{
				"audience_id": audienceID,
			},
			"template": templateID,
		},
	}

	jsonData, err := json.Marshal(requestBody)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error marshaling JSON: %v\n", err)
		os.Exit(1)
	}

	// Make API request
	req, err := http.NewRequest("POST", "https://api.courier.com/send", bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating request: %v\n", err)
		os.Exit(1)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", apiKey))
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error making request: %v\n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading response: %v\n", err)
		os.Exit(1)
	}

	// Print response
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		var response map[string]interface{}
		if err := json.Unmarshal(body, &response); err == nil {
			output, _ := json.MarshalIndent(response, "", "  ")
			fmt.Println(string(output))
		} else {
			fmt.Println(string(body))
		}
	} else {
		var errorResp map[string]interface{}
		if err := json.Unmarshal(body, &errorResp); err == nil {
			output, _ := json.MarshalIndent(errorResp, "", "  ")
			fmt.Fprintf(os.Stderr, "Error: %s\n", string(output))
		} else {
			fmt.Fprintf(os.Stderr, "Error: HTTP %d - %s\n", resp.StatusCode, string(body))
		}
		os.Exit(1)
	}
}

