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
	listID := os.Getenv("COURIER_CREATE_LIST_LIST_ID")
	listName := os.Getenv("COURIER_CREATE_LIST_LIST_NAME")
	if listName == "" {
		listName = "My List Name"
	}

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	requestBody := map[string]interface{}{
		"name": listName,
		"preferences": map[string]interface{}{
			"categories":    map[string]interface{}{},
			"notifications": map[string]interface{}{},
		},
	}

	var response map[string]interface{}
	err := client.Put(
		context.Background(),
		fmt.Sprintf("/lists/%s", listID),
		requestBody,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
