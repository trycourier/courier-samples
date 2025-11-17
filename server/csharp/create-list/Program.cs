using System;
using System.IO;
using System.Text.Json;
using Courier;
using Courier.Exceptions;
using Courier.Models;
using Courier.Models.Lists;
using DotNetEnv;

// NOTE: This sample uses the official Courier C# SDK (https://github.com/trycourier/courier-csharp)
// To use this sample, you need to reference the SDK. See create-list.csproj for setup instructions.

// Load environment variables from .env file in server directory (shared across all language examples)
var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_ID");
var listName = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_NAME") ?? "My List Name";

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(listId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY and COURIER_CREATE_LIST_LIST_ID must be set");
    Environment.Exit(1);
}

try
{
    // Initialize Courier client using the SDK
    var client = new CourierClient { APIKey = apiKey };

    // Build request parameters
    var parameters = new ListUpdateParams
    {
        ListID = listId,
        Name = listName,
        Preferences = new RecipientPreferences
        {
            Categories = new Dictionary<string, NotificationPreferenceDetails>(),
            Notifications = new Dictionary<string, NotificationPreferenceDetails>()
        }
    };

    // Create or update list using the SDK
    await client.Lists.Update(parameters);

    // lists.update returns void/empty on success, so print success message
    var successResponse = new
    {
        status = "success",
        message = "List created successfully",
        list_id = listId,
        name = listName
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

