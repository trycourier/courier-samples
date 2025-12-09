<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$list_id = $_ENV['COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID'] ?? '';
$user_id = $_ENV['COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID'] ?? '';

$client = new Client(apiKey: $api_key);

$client->lists->subscriptions->subscribeUser($user_id, [
    'list_id' => $list_id,
    'preferences' => [
        'categories' => (object)[],
        'notifications' => (object)[]
    ]
]);
