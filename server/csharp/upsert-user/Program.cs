using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using Courier;
using Courier.Exceptions;
using Courier.Models.Profiles;
using DotNetEnv;

// NOTE: This sample uses the official Courier C# SDK (https://github.com/trycourier/courier-csharp)
// To use this sample, you need to reference the SDK. See upsert-user.csproj for setup instructions.

// Load environment variables from .env file in server directory (shared across all language examples)
var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_USER_ID");
var email = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_EMAIL");
var name = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_NAME");
var phoneNumber = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_PHONE_NUMBER");

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(userId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY and COURIER_UPSERT_USER_USER_ID must be set");
    Environment.Exit(1);
}

try
{
    // Initialize Courier client using the SDK
    var client = new CourierClient { APIKey = apiKey };

    // Build profile object dynamically, only including fields that are set
    // Note: All profile fields are optional. If you skip them, an empty profile will be created.
    var profileDict = new Dictionary<string, JsonElement>();
    if (!string.IsNullOrEmpty(email))
    {
        profileDict["email"] = JsonSerializer.SerializeToElement(email);
    }
    if (!string.IsNullOrEmpty(name))
    {
        profileDict["name"] = JsonSerializer.SerializeToElement(name);
    }
    if (!string.IsNullOrEmpty(phoneNumber))
    {
        profileDict["phone_number"] = JsonSerializer.SerializeToElement(phoneNumber);
    }

    // Build request parameters
    var parameters = new ProfileCreateParams
    {
        UserID = userId,
        Profile = profileDict
    };

    // Create or update user profile using the SDK
    var response = await client.Profiles.Create(parameters);

    // Print response as JSON
    var options = new JsonSerializerOptions { WriteIndented = true };
    Console.WriteLine(JsonSerializer.Serialize(response, options));
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

