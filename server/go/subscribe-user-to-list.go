package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
	"github.com/trycourier/courier-go/v4"
	"github.com/trycourier/courier-go/v4/option"
)

func main() {
	// Load environment variables from .env file in server directory (shared across all language examples)
	envPath := filepath.Join("..", ".env")
	godotenv.Load(envPath)

	apiKey := os.Getenv("COURIER_API_KEY")
	listID := os.Getenv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID")
	userID := os.Getenv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID")

	// Build request body
	requestBody := map[string]interface{}{
		"preferences": map[string]interface{}{
			"categories":    map[string]interface{}{},
			"notifications": map[string]interface{}{},
		},
	}

	// Initialize Courier client
	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	// Make API request using the SDK
	var response map[string]interface{}
	err := client.Put(
		context.Background(),
		fmt.Sprintf("/lists/%s/subscriptions/%s", listID, userID),
		requestBody,
		&response,
	)

	if err != nil {
		// Check if error is due to empty response (EOF) - this is expected for 204 No Content
		errMsg := err.Error()
		isEOFError := errMsg == "error parsing response json: EOF" || 
		              errMsg == "EOF" ||
		              (len(errMsg) >= 3 && errMsg[len(errMsg)-3:] == "EOF")
		
		// Handle SDK errors
		var apierr *courier.Error
		if errors.As(err, &apierr) {
			// Check if it's a 2xx status code (success) - empty body is expected for 204
			if apierr.StatusCode >= 200 && apierr.StatusCode < 300 {
				// Success with empty response - continue to print success message
			} else {
				fmt.Fprintf(os.Stderr, "Error: HTTP %d - %s\n", apierr.StatusCode, err.Error())
				os.Exit(1)
			}
		} else if isEOFError {
			// EOF error without courier.Error wrapper - likely a successful 204 response
			// Continue to print success message
		} else {
			fmt.Fprintf(os.Stderr, "Error making request: %v\n", err)
			os.Exit(1)
		}
	}

	// Success - subscribe returns void/204, so print success message
	successResponse := map[string]interface{}{
		"status":  "success",
		"message": "User subscribed successfully",
	}
	output, _ := json.MarshalIndent(successResponse, "", "  ")
	fmt.Println(string(output))
}

