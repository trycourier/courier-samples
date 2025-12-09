using System;
using System.IO;
using Courier;
using Courier.Models.Lists.Subscriptions;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID");
var userId = Environment.GetEnvironmentVariable("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID");

var client = new CourierClient { APIKey = apiKey! };

var parameters = new SubscriptionUnsubscribeUserParams
{
    ListID = listId,
    UserID = userId
};

await client.Lists.Subscriptions.UnsubscribeUser(parameters);

