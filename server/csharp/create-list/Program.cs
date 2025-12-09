using System;
using System.Collections.Generic;
using System.IO;
using Courier;
using Courier.Models;
using Courier.Models.Lists;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var listId = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_ID");
var listName = Environment.GetEnvironmentVariable("COURIER_CREATE_LIST_LIST_NAME") ?? "My List Name";

var client = new CourierClient { APIKey = apiKey! };

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

