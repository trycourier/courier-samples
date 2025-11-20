using System;
using System.IO;
using Courier;
using Courier.Models.Profiles;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_GET_USER_PROFILE_USER_ID");

var client = new CourierClient { APIKey = apiKey! };

var parameters = new ProfileRetrieveParams
{
    UserID = userId
};

var response = await client.Profiles.Retrieve(parameters);

Console.WriteLine(response);

