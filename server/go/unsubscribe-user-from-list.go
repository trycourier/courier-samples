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
	listID := os.Getenv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID")
	userID := os.Getenv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID")

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	var response map[string]interface{}
	err := client.Delete(
		context.Background(),
		fmt.Sprintf("/lists/%s/subscriptions/%s", listID, userID),
		nil,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
