using System;
using System.IO;
using TryCourier;
using TryCourier.Models.Profiles;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var userId = Environment.GetEnvironmentVariable("COURIER_GET_USER_PROFILE_USER_ID");

var client = new CourierClient { ApiKey = apiKey! };

var parameters = new ProfileRetrieveParams
{
    UserID = userId
};

var response = await client.Profiles.Retrieve(parameters);

Console.WriteLine(response);

