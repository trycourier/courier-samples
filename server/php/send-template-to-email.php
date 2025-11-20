<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$email = getenv('COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL') ?: '';
$template_id = getenv('COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID') ?: '';

$client = new Client(apiKey: $api_key);

$response = $client->send->message([
    'message' => [
        'to' => [
            'email' => $email
        ],
        'template' => $template_id,
        'data' => [
            'name' => 'Your Name'
        ]
    ]
]);

echo $response . "\n";
