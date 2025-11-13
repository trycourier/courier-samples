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
var userId = Environment.GetEnvironmentVariable("COURIER_GET_USER_PROFILE_USER_ID");

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(userId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY and COURIER_GET_USER_PROFILE_USER_ID must be set");
    Environment.Exit(1);
}

// Make API request
using var client = new HttpClient();
client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
client.DefaultRequestHeaders.Add("Accept", "application/json");

var response = await client.GetAsync($"https://api.courier.com/profiles/{userId}");
var responseBody = await response.Content.ReadAsStringAsync();

// Handle response
if (response.IsSuccessStatusCode)
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

