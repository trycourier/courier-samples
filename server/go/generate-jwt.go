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
	userID := os.Getenv("COURIER_GENERATE_JWT_USER_ID")
	expiresInDays := os.Getenv("COURIER_EXPIRES_IN_DAYS")
	if expiresInDays == "" {
		expiresInDays = "30"
	}

	// Initialize Courier client
	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	// Build request body
	requestBody := map[string]interface{}{
		"scope":      fmt.Sprintf("user_id:%s write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands", userID),
		"expires_in": fmt.Sprintf("%s days", expiresInDays),
	}

	// Make API request using the SDK
	var response map[string]interface{}
	err := client.Post(
		context.Background(),
		"/auth/issue-token",
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

