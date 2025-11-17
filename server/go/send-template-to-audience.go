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

	// Initialize Courier client
	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	// Make API request using the SDK
	var response map[string]interface{}
	err := client.Post(
		context.Background(),
		"/send",
		requestBody,
		&response,
	)

	if err != nil {
		// Handle SDK errors
		var apierr *courier.Error
		if errors.As(err, &apierr) {
			fmt.Fprintf(os.Stderr, "Error: HTTP %d - %s\n", apierr.StatusCode, err.Error())
		} else {
			fmt.Fprintf(os.Stderr, "Error making request: %v\n", err)
		}
		os.Exit(1)
	}

	// Print response
	output, err := json.MarshalIndent(response, "", "  ")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error formatting response: %v\n", err)
		os.Exit(1)
	}
	fmt.Println(string(output))
}

