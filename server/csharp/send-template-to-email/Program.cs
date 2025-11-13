using System;
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
var email = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID");

if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(templateId))
{
    Console.Error.WriteLine("Error: COURIER_API_KEY, COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL, and COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID must be set");
    Environment.Exit(1);
}

// Build request body
var requestBody = new
{
    message = new
    {
        to = new
        {
            email = email
        },
        template = templateId,
        data = new
        {
            name = "Your Name"
        }
    }
};

// Make API request
using var client = new HttpClient();
client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
client.DefaultRequestHeaders.Add("Accept", "application/json");

var json = JsonSerializer.Serialize(requestBody);
var content = new StringContent(json, Encoding.UTF8, "application/json");

var response = await client.PostAsync("https://api.courier.com/send", content);
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

