<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$audience_id = getenv('COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID') ?: '';
$template_id = getenv('COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID') ?: '';

$client = new Client(apiKey: $api_key);

$response = $client->send->message([
    'message' => [
        'to' => [
            'audience_id' => $audience_id
        ],
        'template' => $template_id
    ]
]);

echo $response . "\n";
