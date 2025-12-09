<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$user_id = $_ENV['COURIER_UPSERT_USER_USER_ID'] ?? '';
$email = $_ENV['COURIER_UPSERT_USER_EMAIL'] ?? '';
$name = $_ENV['COURIER_UPSERT_USER_NAME'] ?? '';
$phone_number = $_ENV['COURIER_UPSERT_USER_PHONE_NUMBER'] ?? '';

$client = new Client(apiKey: $api_key);

$profile = [];
if (!empty($email)) $profile['email'] = $email;
if (!empty($name)) $profile['name'] = $name;
if (!empty($phone_number)) $profile['phone_number'] = $phone_number;

$response = $client->profiles->replace($user_id, ['profile' => $profile]);

echo $response . "\n";
