using System;
using System.IO;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using DotNetEnv;

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

// Make API request
using var client = new HttpClient();
client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
client.DefaultRequestHeaders.Add("Accept", "application/json");

var response = await client.DeleteAsync($"https://api.courier.com/lists/{listId}/subscriptions/{userId}");
var responseBody = await response.Content.ReadAsStringAsync();

// Handle response
if (response.IsSuccessStatusCode)
{
    // Handle None/null responses - if response is empty, print success message
    if (string.IsNullOrWhiteSpace(responseBody))
    {
        var successResponse = new
        {
            status = "success",
            message = "User unsubscribed successfully"
        };
        Console.WriteLine(JsonSerializer.Serialize(successResponse, new JsonSerializerOptions { WriteIndented = true }));
    }
    else
    {
        try
        {
            var jsonDoc = JsonDocument.Parse(responseBody);
            Console.WriteLine(JsonSerializer.Serialize(jsonDoc, new JsonSerializerOptions { WriteIndented = true }));
        }
        catch
        {
            Console.WriteLine(responseBody);
        }
    }
}
else
{
    try
    {
        var errorJson = JsonDocument.Parse(responseBody);
        Console.WriteLine(JsonSerializer.Serialize(errorJson, new JsonSerializerOptions { WriteIndented = true }));
    }
    catch
    {
        Console.Error.WriteLine($"Error: HTTP {(int)response.StatusCode} - {responseBody}");
    }
    Environment.Exit(1);
}

