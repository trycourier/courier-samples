using System;
using System.IO;
using Courier;
using Courier.Exceptions;
using Courier.Models;
using Courier.Models.Send;
using DotNetEnv;

// NOTE: This sample uses the official Courier C# SDK (https://github.com/trycourier/courier-csharp)
// To use this sample, you need to reference the SDK. See send-template-to-list.csproj for setup instructions.

// Load environment variables from .env file in server directory (shared across all language examples)
var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID");

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(listId) || string.IsNullOrEmpty(templateId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY, COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID, and COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID must be set");
    Environment.Exit(1);
}

try
{
    // Initialize Courier client using the SDK
    var client = new CourierClient { APIKey = apiKey };

    // Build request parameters
    var parameters = new SendMessageParams
    {
        Message = new Message
        {
            To = new UserRecipient { ListID = listId },
            Template = templateId
        }
    };

    // Send message using the SDK
    var response = await client.Send.Message(parameters);

    // Print response as JSON
    var options = new System.Text.Json.JsonSerializerOptions { WriteIndented = true };
    Console.WriteLine(System.Text.Json.JsonSerializer.Serialize(response, options));
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

