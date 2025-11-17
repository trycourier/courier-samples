using System;
using System.IO;
using System.Text.Json;
using Courier;
using Courier.Exceptions;
using Courier.Models.Auth;
using DotNetEnv;

// NOTE: This sample uses the official Courier C# SDK (https://github.com/trycourier/courier-csharp)
// To use this sample, you need to reference the SDK. See generate-jwt.csproj for setup instructions.

// Load environment variables from .env file in server directory (shared across all language examples)
var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_GENERATE_JWT_USER_ID");
var expiresInDays = Environment.GetEnvironmentVariable("COURIER_EXPIRES_IN_DAYS") ?? "30";

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(userId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY and COURIER_GENERATE_JWT_USER_ID must be set");
    Environment.Exit(1);
}

try
{
    // Initialize Courier client using the SDK
    var client = new CourierClient { APIKey = apiKey };

    // Build request parameters
    var scope = $"user_id:{userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands";
    var expiresIn = $"{expiresInDays} days";

    var parameters = new AuthIssueTokenParams
    {
        Scope = scope,
        ExpiresIn = expiresIn
    };

    // Issue token using the SDK
    var response = await client.Auth.IssueToken(parameters);

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

