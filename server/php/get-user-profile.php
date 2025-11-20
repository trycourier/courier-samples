<?php
require_once __DIR__ . '/../vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$user_id = getenv('COURIER_GET_USER_PROFILE_USER_ID') ?: '';

$client = new Client(apiKey: $api_key);

$response = $client->profiles->retrieve($user_id);

echo $response . "\n";
