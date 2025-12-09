//go:build ignore

// +build ignore

package main

import (
	"context"
	"fmt"
	"os"
	"path/filepath"

	"github.com/joho/godotenv"
	"github.com/trycourier/courier-go/v4"
	"github.com/trycourier/courier-go/v4/option"
)

func LoadEnv() {
	envPath := filepath.Join("..", ".env")
	godotenv.Load(envPath)
}

func main() {
	LoadEnv()

	apiKey := os.Getenv("COURIER_API_KEY")
	userID := os.Getenv("COURIER_GENERATE_JWT_USER_ID")
	expiresInDays := os.Getenv("COURIER_EXPIRES_IN_DAYS")
	if expiresInDays == "" {
		expiresInDays = "30"
	}

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	requestBody := map[string]interface{}{
		"scope":      fmt.Sprintf("user_id:%s write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands", userID),
		"expires_in": fmt.Sprintf("%s days", expiresInDays),
	}

	var response map[string]interface{}
	err := client.Post(
		context.Background(),
		"/auth/issue-token",
		requestBody,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
