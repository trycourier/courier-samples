<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->safeLoad();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$user_id = $_ENV['COURIER_GET_USER_PROFILE_USER_ID'] ?? '';

$client = new Client(apiKey: $api_key);

$response = $client->profiles->retrieve($user_id);

echo $response . "\n";
