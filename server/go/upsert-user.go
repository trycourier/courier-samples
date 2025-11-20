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
	userID := os.Getenv("COURIER_UPSERT_USER_USER_ID")
	email := os.Getenv("COURIER_UPSERT_USER_EMAIL")
	name := os.Getenv("COURIER_UPSERT_USER_NAME")
	phoneNumber := os.Getenv("COURIER_UPSERT_USER_PHONE_NUMBER")

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	profile := make(map[string]interface{})
	if email != "" { profile["email"] = email }
	if name != "" { profile["name"] = name }
	if phoneNumber != "" { profile["phone_number"] = phoneNumber }

	requestBody := map[string]interface{}{
		"profile": profile,
	}

	var response map[string]interface{}
	err := client.Post(
		context.Background(),
		fmt.Sprintf("/profiles/%s", userID),
		requestBody,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
