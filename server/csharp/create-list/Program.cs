using System;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using DotNetEnv;

// Load environment variables from .env file in server directory (shared across all language examples)
var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_ID");
var listName = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_NAME") ?? "My List Name";

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(listId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY and COURIER_CREATE_LIST_LIST_ID must be set");
    Environment.Exit(1);
}

// Build request body
var requestBody = new
{
    name = listName,
    preferences = new
    {
        categories = new { },
        notifications = new { }
    }
};

// Make API request
using var client = new HttpClient();
client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
client.DefaultRequestHeaders.Add("Accept", "application/json");

var json = JsonSerializer.Serialize(requestBody);
var content = new StringContent(json, Encoding.UTF8, "application/json");

var response = await client.PutAsync($"https://api.courier.com/lists/{listId}", content);
var responseBody = await response.Content.ReadAsStringAsync();

// Handle response
if (response.IsSuccessStatusCode)
{
    // lists.update returns void/empty on success, so print success message
    var successResponse = new
    {
        status = "success",
        message = "List created successfully",
        list_id = listId,
        name = listName
    };
    Console.WriteLine(JsonSerializer.Serialize(successResponse, new JsonSerializerOptions { WriteIndented = true }));
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

