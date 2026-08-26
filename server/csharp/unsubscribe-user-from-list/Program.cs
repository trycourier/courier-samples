using System;
using System.IO;
using TryCourier;
using TryCourier.Models.Lists.Subscriptions;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID");
var userId = Environment.GetEnvironmentVariable("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID");

var client = new CourierClient { ApiKey = apiKey! };

var parameters = new SubscriptionUnsubscribeUserParams
{
    ListID = listId,
    UserID = userId
};

await client.Lists.Subscriptions.UnsubscribeUser(parameters);

