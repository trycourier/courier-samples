using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using DotNetEnv;

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

// Build profile object dynamically, only including fields that are set
// Note: All profile fields are optional. If you skip them, an empty profile will be created.
var profile = new Dictionary<string, object>();
if (!string.IsNullOrEmpty(email))
{
    profile["email"] = email;
}
if (!string.IsNullOrEmpty(name))
{
    profile["name"] = name;
}
if (!string.IsNullOrEmpty(phoneNumber))
{
    profile["phone_number"] = phoneNumber;
}

// Build request body
var requestBody = new
{
    profile = profile
};

// Make API request
using var client = new HttpClient();
client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
client.DefaultRequestHeaders.Add("Accept", "application/json");

var json = JsonSerializer.Serialize(requestBody);
var content = new StringContent(json, Encoding.UTF8, "application/json");

var response = await client.PutAsync($"https://api.courier.com/profiles/{userId}", content);
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

