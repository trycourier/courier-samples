using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using Courier;
using Courier.Models;
using Courier.Models.Send;
using DotNetEnv;

var envPath = Path.Combine(Directory.GetParent(Directory.GetParent(Directory.GetCurrentDirectory())!.FullName)!.FullName, ".env");
Env.Load(envPath);

var apiKey = Environment.GetEnvironmentVariable("COURIER_API_KEY");
var audienceId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID");

var client = new CourierClient { APIKey = apiKey! };

var recipient = UserRecipient.FromRawUnchecked(new Dictionary<string, JsonElement>
{
    { "audience_id", JsonSerializer.SerializeToElement(audienceId) }
});

var parameters = new SendMessageParams
{
    Message = new Message
    {
        To = recipient,
        Template = templateId
    }
};

var response = await client.Send.Message(parameters);

Console.WriteLine(response);

