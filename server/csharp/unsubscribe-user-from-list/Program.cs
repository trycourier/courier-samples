using System;
using System.IO;
using System.Text.Json;
using Courier;
using Courier.Exceptions;
using Courier.Models.Lists.Subscriptions;
using DotNetEnv;

// NOTE: This sample uses the official Courier C# SDK (https://github.com/trycourier/courier-csharp)
// To use this sample, you need to reference the SDK. See unsubscribe-user-from-list.csproj for setup instructions.

// Load environment variables from .env file in server directory (shared across all language examples)
var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID");
var userId = Environment.GetEnvironmentVariable("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID");

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(listId) || string.IsNullOrEmpty(userId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY, COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID, and COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID must be set");
    Environment.Exit(1);
}

try
{
    // Initialize Courier client using the SDK
    var client = new CourierClient { APIKey = apiKey };

    // Build request parameters
    var parameters = new SubscriptionUnsubscribeUserParams
    {
        ListID = listId,
        UserID = userId
    };

    // Unsubscribe user from list using the SDK
    await client.Lists.Subscriptions.UnsubscribeUser(parameters);

    // UnsubscribeUser returns void/empty on success, so print success message
    var successResponse = new
    {
        status = "success",
        message = "User unsubscribed successfully"
    };
    var options = new JsonSerializerOptions { WriteIndented = true };
    Console.WriteLine(JsonSerializer.Serialize(successResponse, options));
}
catch (CourierException ex)
{
    // Handle SDK errors
    Console.Error.WriteLine($"Error: {ex.Message}");
    if (ex is CourierApiException apiEx)
    {
        Console.Error.WriteLine($"HTTP Status: {apiEx.StatusCode}");
    }
    Environment.Exit(1);
}
catch (Exception ex)
{
    Console.Error.WriteLine($"Unexpected error: {ex.Message}");
    Environment.Exit(1);
}

