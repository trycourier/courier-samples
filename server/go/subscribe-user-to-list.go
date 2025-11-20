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
	listID := os.Getenv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID")
	userID := os.Getenv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID")

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	requestBody := map[string]interface{}{
		"preferences": map[string]interface{}{
			"categories":    map[string]interface{}{},
			"notifications": map[string]interface{}{},
		},
	}

	var response map[string]interface{}
	err := client.Put(
		context.Background(),
		fmt.Sprintf("/lists/%s/subscriptions/%s", listID, userID),
		requestBody,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
