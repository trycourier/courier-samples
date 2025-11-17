<?php
/**
 * Create or update a list using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$listId = $_ENV['COURIER_CREATE_LIST_LIST_ID'] ?? '';
$listName = $_ENV['COURIER_CREATE_LIST_LIST_NAME'] ?? 'My List Name';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($listId)) {
    echo json_encode(['error' => 'COURIER_CREATE_LIST_LIST_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Create or update list using the SDK
try {
    $client->lists->update($listId, [
        'name' => $listName,
        'preferences' => [
            'categories' => (object)[],
            'notifications' => (object)[]
        ]
    ]);

    // Print success message since update returns void
    echo json_encode([
        'success' => true,
        'message' => "List '{$listId}' created/updated successfully",
        'list_id' => $listId,
        'list_name' => $listName
    ], JSON_PRETTY_PRINT) . "\n";
} catch (APIException $e) {
    echo json_encode(['error' => $e->getMessage()], JSON_PRETTY_PRINT) . "\n";
    exit(1);
} catch (\Exception $e) {
    echo json_encode(['error' => $e->getMessage()], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

