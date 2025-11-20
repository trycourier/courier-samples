<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$user_id = getenv('COURIER_UPSERT_USER_USER_ID') ?: '';
$email = getenv('COURIER_UPSERT_USER_EMAIL') ?: '';
$name = getenv('COURIER_UPSERT_USER_NAME') ?: '';
$phone_number = getenv('COURIER_UPSERT_USER_PHONE_NUMBER') ?: '';

$client = new Client(apiKey: $api_key);

$profile = [];
if (!empty($email)) $profile['email'] = $email;
if (!empty($name)) $profile['name'] = $name;
if (!empty($phone_number)) $profile['phone_number'] = $phone_number;

$response = $client->profiles->replace($user_id, ['profile' => $profile]);

echo $response . "\n";
