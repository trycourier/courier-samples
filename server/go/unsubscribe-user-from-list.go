package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables from .env file in server/curl directory (shared with curl scripts)
	envPath := filepath.Join("..", "curl", ".env")
	godotenv.Load(envPath)

	apiKey := os.Getenv("COURIER_API_KEY")
	listID := os.Getenv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID")
	userID := os.Getenv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID")

	// Make API request
	url := fmt.Sprintf("https://api.courier.com/lists/%s/subscriptions/%s", listID, userID)
	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating request: %v\n", err)
		os.Exit(1)
	}

	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", apiKey))
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

	// Handle response (unsubscribe returns void/204)
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		if resp.StatusCode == 204 || len(body) == 0 {
			// Success with no body
			successResponse := map[string]interface{}{
				"status":  "success",
				"message": "User unsubscribed successfully",
			}
			output, _ := json.MarshalIndent(successResponse, "", "  ")
			fmt.Println(string(output))
		} else {
			var response map[string]interface{}
			if err := json.Unmarshal(body, &response); err == nil {
				output, _ := json.MarshalIndent(response, "", "  ")
				fmt.Println(string(output))
			} else {
				fmt.Println(string(body))
			}
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

