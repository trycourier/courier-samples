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
	userID := os.Getenv("COURIER_GET_USER_PROFILE_USER_ID")

	client := courier.NewClient(
		option.WithAPIKey(apiKey),
	)

	var response map[string]interface{}
	err := client.Get(
		context.Background(),
		fmt.Sprintf("/profiles/%s", userID),
		nil,
		&response,
	)

	if err != nil {
		panic(err.Error())
	}

	fmt.Printf("%+v\n", response)
}
