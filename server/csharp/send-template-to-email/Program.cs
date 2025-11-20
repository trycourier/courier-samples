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
var email = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL");
var templateId = Environment.GetEnvironmentVariable("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID");

var client = new CourierClient { APIKey = apiKey! };

var parameters = new SendMessageParams
{
    Message = new Message
    {
        To = new UserRecipient { Email = email },
        Template = templateId,
        Data = new Dictionary<string, JsonElement>
        {
            { "name", JsonSerializer.SerializeToElement("Your Name") }
        }
    }
};

var response = await client.Send.Message(parameters);

Console.WriteLine(response);

