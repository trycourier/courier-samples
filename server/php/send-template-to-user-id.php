<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$user_id = getenv('COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID') ?: '';
$template_id = getenv('COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID') ?: '';

$client = new Client(apiKey: $api_key);

$response = $client->send->message([
    'message' => [
        'to' => [
            'user_id' => $user_id
        ],
        'template' => $template_id,
        'data' => [
            'name' => 'Your Name'
        ]
    ]
]);

echo $response . "\n";
