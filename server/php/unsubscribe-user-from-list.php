<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->safeLoad();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$list_id = $_ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID'] ?? '';
$user_id = $_ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID'] ?? '';

$client = new Client(apiKey: $api_key);

$client->lists->subscriptions->unsubscribeUser($user_id, listID: $list_id);
