<?php
/**
 * Send a template to a user ID using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$userId = $_ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID'] ?? '';
$templateId = $_ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($userId)) {
    echo json_encode(['error' => 'COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($templateId)) {
    echo json_encode(['error' => 'COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Send message using the SDK
try {
    $response = $client->send->message([
        'message' => [
            'to' => [
                'user_id' => $userId
            ],
            'template' => $templateId,
            'data' => [
                'name' => 'Your Name'
            ]
        ]
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

