using System;
using System.Collections.Generic;
using System.IO;
using Courier;
using Courier.Models;
using Courier.Models.Lists.Subscriptions;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID");
var userId = Environment.GetEnvironmentVariable("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID");

var client = new CourierClient { APIKey = apiKey! };

var parameters = new SubscriptionSubscribeUserParams
{
    ListID = listId,
    UserID = userId,
    Preferences = new RecipientPreferences
    {
        Categories = new Dictionary<string, NotificationPreferenceDetails>(),
        Notifications = new Dictionary<string, NotificationPreferenceDetails>()
    }
};

await client.Lists.Subscriptions.SubscribeUser(parameters);

