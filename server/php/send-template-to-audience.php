<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->safeLoad();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$audience_id = $_ENV['COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID'] ?? '';
$template_id = $_ENV['COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID'] ?? '';

$client = new Client(apiKey: $api_key);

$response = $client->send->message(message: [
    'to' => [
        'audience_id' => $audience_id
    ],
    'template' => $template_id
]);

echo $response . "\n";
