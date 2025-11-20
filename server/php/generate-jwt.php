<?php
require_once __DIR__ . '/../vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$user_id = getenv('COURIER_GENERATE_JWT_USER_ID') ?: '';
$expires_in_days = getenv('COURIER_EXPIRES_IN_DAYS') ?: '30';

$client = new Client(apiKey: $api_key);

$response = $client->auth->issueToken([
    'scope' => "user_id:{$user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
    'expires_in' => "{$expires_in_days} days"
]);

echo $response . "\n";
