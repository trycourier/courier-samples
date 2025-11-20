using System;
using System.IO;
using Courier;
using Courier.Models.Auth;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_GENERATE_JWT_USER_ID");
var expiresInDays = Environment.GetEnvironmentVariable("COURIER_EXPIRES_IN_DAYS") ?? "30";

var client = new CourierClient { APIKey = apiKey! };

var parameters = new AuthIssueTokenParams
{
    Scope = $"user_id:{userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
    ExpiresIn = $"{expiresInDays} days"
};

var response = await client.Auth.IssueToken(parameters);

Console.WriteLine(response);

