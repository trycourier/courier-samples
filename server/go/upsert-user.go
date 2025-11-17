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
	userID := os.Getenv("COURIER_UPSERT_USER_USER_ID")
	email := os.Getenv("COURIER_UPSERT_USER_EMAIL")
	name := os.Getenv("COURIER_UPSERT_USER_NAME")
	phoneNumber := os.Getenv("COURIER_UPSERT_USER_PHONE_NUMBER")

	// Build profile object dynamically, only including fields that are set
	// Note: All profile fields are optional. If you skip them, an empty profile will be created.
	profile := make(map[string]interface{})
	if email != "" {
		profile["email"] = email
	}
	if name != "" {
		profile["name"] = name
	}
	if phoneNumber != "" {
		profile["phone_number"] = phoneNumber
	}

	// Build request body
	requestBody := map[string]interface{}{
		"profile": profile,
	}

	// Initialize Courier client
	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	// Make API request using the SDK
	var response map[string]interface{}
	err := client.Post(
		context.Background(),
		fmt.Sprintf("/profiles/%s", userID),
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

