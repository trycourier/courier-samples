<?php
/**
 * Send a template to an audience using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$audienceId = $_ENV['COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID'] ?? '';
$templateId = $_ENV['COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($audienceId)) {
    echo json_encode(['error' => 'COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($templateId)) {
    echo json_encode(['error' => 'COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Send message to audience using the SDK
try {
    $response = $client->send->message([
        'message' => [
            'to' => [
                'audience_id' => $audienceId
            ],
            'template' => $templateId
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

