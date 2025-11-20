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
	listID := os.Getenv("COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID")
	templateID := os.Getenv("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID")

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	requestBody := map[string]interface{}{
		"message": map[string]interface{}{
			"to": map[string]interface{}{
				"list_id": listID,
			},
			"template": templateID,
		},
	}

	var response map[string]interface{}
	err := client.Post(
		context.Background(),
		"/send",
		requestBody,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
