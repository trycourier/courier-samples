<?php
/**
 * Generate JWT token for user authentication using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$userId = $_ENV['COURIER_GENERATE_JWT_USER_ID'] ?? '';
$expiresInDays = $_ENV['COURIER_EXPIRES_IN_DAYS'] ?? '30';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($userId)) {
    echo json_encode(['error' => 'COURIER_GENERATE_JWT_USER_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Build scope string
$scope = "user_id:{$userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands";
$expiresIn = "{$expiresInDays} days";

// Generate JWT token using the SDK
try {
    $response = $client->auth->issueToken([
        'scope' => $scope,
        'expires_in' => $expiresIn
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

