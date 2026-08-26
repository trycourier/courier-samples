using System;
using System.IO;
using TryCourier;
using TryCourier.Models.Auth;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_GENERATE_JWT_USER_ID");
var expiresInDays = Environment.GetEnvironmentVariable("COURIER_EXPIRES_IN_DAYS") ?? "30";

var client = new CourierClient { ApiKey = apiKey! };

var parameters = new AuthIssueTokenParams
{
    Scope = $"user_id:{userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
    ExpiresIn = $"{expiresInDays} days"
};

var response = await client.Auth.IssueToken(parameters);

Console.WriteLine(response);

