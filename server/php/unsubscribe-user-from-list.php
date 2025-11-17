<?php
/**
 * Unsubscribe a user from a list using the Courier PHP SDK
 */

require __DIR__ . '/vendor/autoload.php';

use Courier\Client;
use Courier\Core\Exceptions\APIException;
use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$listId = $_ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID'] ?? '';
$userId = $_ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID'] ?? '';

if (empty($apiKey)) {
    echo json_encode(['error' => 'COURIER_API_KEY environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($listId)) {
    echo json_encode(['error' => 'COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if (empty($userId)) {
    echo json_encode(['error' => 'COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID environment variable is required'], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

// Initialize Courier client using the SDK
$client = new Client(apiKey: $apiKey);

// Unsubscribe user from list using the SDK
try {
    $client->lists->subscriptions->unsubscribeUser($userId, [
        'list_id' => $listId
    ]);

    // Print success message since unsubscribeUser returns void
    echo json_encode([
        'status' => 'success',
        'message' => 'User unsubscribed successfully'
    ], JSON_PRETTY_PRINT) . "\n";
} catch (APIException $e) {
    echo json_encode(['error' => $e->getMessage()], JSON_PRETTY_PRINT) . "\n";
    exit(1);
} catch (\Exception $e) {
    echo json_encode(['error' => $e->getMessage()], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

