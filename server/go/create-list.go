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
	listID := os.Getenv("COURIER_CREATE_LIST_LIST_ID")
	listName := os.Getenv("COURIER_CREATE_LIST_LIST_NAME")
	if listName == "" {
		listName = "My List Name"
	}

	// Build request body
	requestBody := map[string]interface{}{
		"name": listName,
		"preferences": map[string]interface{}{
			"categories":    map[string]interface{}{},
			"notifications": map[string]interface{}{},
		},
	}

	jsonData, err := json.Marshal(requestBody)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error marshaling JSON: %v\n", err)
		os.Exit(1)
	}

	// Make API request
	url := fmt.Sprintf("https://api.courier.com/lists/%s", listID)
	req, err := http.NewRequest("PUT", url, bytes.NewBuffer(jsonData))
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

	// Handle response
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		// Success - lists.update returns void, so print success message
		successResponse := map[string]interface{}{
			"success":  true,
			"message": fmt.Sprintf("List '%s' created/updated successfully", listID),
			"list_id": listID,
			"name":    listName,
		}
		output, _ := json.MarshalIndent(successResponse, "", "  ")
		fmt.Println(string(output))
	} else {
		// Error response
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

