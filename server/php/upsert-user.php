<?php
/**
 * Create or update a user profile using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$userId = $_ENV['COURIER_UPSERT_USER_USER_ID'] ?? '';
$email = $_ENV['COURIER_UPSERT_USER_EMAIL'] ?? '';
$name = $_ENV['COURIER_UPSERT_USER_NAME'] ?? '';
$phoneNumber = $_ENV['COURIER_UPSERT_USER_PHONE_NUMBER'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($userId)) {
    echo json_encode(['error' => 'COURIER_UPSERT_USER_USER_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Build profile object dynamically, only including fields that are set
// Note: All profile fields are optional. If you skip them, an empty profile will be created.
$profile = [];
if (!empty($email)) {
    $profile['email'] = $email;
}
if (!empty($name)) {
    $profile['name'] = $name;
}
if (!empty($phoneNumber)) {
    $profile['phone_number'] = $phoneNumber;
}

// Create or update user profile using the SDK
try {
    $response = $client->profiles->replace($userId, [
        'profile' => $profile
    ]);

    // Print response as JSON
    echo json_encode($response, JSON_PRETTY_PRINT) . "\n";
} catch (APIException $e) {
    echo json_encode(['error' => $e->getMessage()], JSON_PRETTY_PRINT) . "\n";
    exit(1);
} catch (\Exception $e) {
    echo json_encode(['error' => $e->getMessage()], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

