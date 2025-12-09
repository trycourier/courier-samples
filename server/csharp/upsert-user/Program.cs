using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using Courier;
using Courier.Models.Profiles;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_USER_ID");
var email = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_EMAIL");
var name = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_NAME");
var phoneNumber = Environment.GetEnvironmentVariable("COURIER_UPSERT_USER_PHONE_NUMBER");

var client = new CourierClient { APIKey = apiKey! };

var profileDict = new Dictionary<string, JsonElement>();
if (!string.IsNullOrEmpty(email)) profileDict["email"] = JsonSerializer.SerializeToElement(email);
if (!string.IsNullOrEmpty(name)) profileDict["name"] = JsonSerializer.SerializeToElement(name);
if (!string.IsNullOrEmpty(phoneNumber)) profileDict["phone_number"] = JsonSerializer.SerializeToElement(phoneNumber);

var parameters = new ProfileCreateParams
{
    UserID = userId,
    Profile = profileDict
};

var response = await client.Profiles.Create(parameters);

Console.WriteLine(response);

