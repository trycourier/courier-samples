using System;
using System.Collections.Generic;
using System.IO;
using TryCourier;
using TryCourier.Models;
using TryCourier.Models.Lists;
using DotNetEnv;

var envPath = System.IO.Path.Combine(System.IO.Directory.GetParent(System.IO.Directory.GetParent(System.IO.Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_ID");
var listName = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_NAME") ?? "My List Name";

var client = new CourierClient { ApiKey = apiKey! };

var parameters = new ListUpdateParams
{
    ListID = listId,
    Name = listName,
    Preferences = new RecipientPreferences
    {
        Categories = new Dictionary<string, NotificationPreferenceDetails>(),
        Notifications = new Dictionary<string, NotificationPreferenceDetails>()
    }
};

await client.Lists.Update(parameters);

