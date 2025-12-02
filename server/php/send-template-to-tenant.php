<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$tenant_id = $_ENV['COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID'] ?? '';
$template_id = $_ENV['COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID'] ?? '';

$client = new Client(apiKey: $api_key);

$response = $client->send->message([
    'message' => [
        'to' => [
            'tenant_id' => $tenant_id
        ],
        'template' => $template_id
    ]
]);

echo $response . "\n";
