using System;
using System.Collections.Generic;
using System.IO;
using TryCourier;
using TryCourier.Models;
using TryCourier.Models.Lists.Subscriptions;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID");
var userId = Environment.GetEnvironmentVariable("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID");

var client = new CourierClient { ApiKey = apiKey! };

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

