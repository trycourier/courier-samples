<?php
/**
 * Send a template to a tenant using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$tenantId = $_ENV['COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID'] ?? '';
$templateId = $_ENV['COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($tenantId)) {
    echo json_encode(['error' => 'COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($templateId)) {
    echo json_encode(['error' => 'COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Send message to tenant using the SDK
try {
    $response = $client->send->message([
        'message' => [
            'to' => [
                'tenant_id' => $tenantId
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

