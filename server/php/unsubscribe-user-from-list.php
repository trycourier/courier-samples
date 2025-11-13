<?php
/**
 * Unsubscribe a user from a list
 */

require __DIR__ . '/vendor/autoload.php';

use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$listId = $_ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID'] ?? '';
$userId = $_ENV['COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID'] ?? '';

// Make API request
$url = "https://api.courier.com/lists/{$listId}/subscriptions/{$userId}";
$ch = curl_init($url);

curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CUSTOMREQUEST => 'DELETE',
    CURLOPT_HTTPHEADER => [
        'Authorization: Bearer ' . $apiKey,
        'Accept: application/json'
    ]
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$error = curl_error($ch);
curl_close($ch);

// Handle response
if ($error) {
    echo json_encode(['error' => $error], JSON_PRETTY_PRINT) . "\n";
    exit(1);
}

if ($httpCode >= 200 && $httpCode < 300) {
    if (!empty($response)) {
        $responseData = json_decode($response, true);
        echo json_encode($responseData, JSON_PRETTY_PRINT) . "\n";
    } else {
        echo json_encode([
            'status' => 'success',
            'message' => 'User unsubscribed successfully'
        ], JSON_PRETTY_PRINT) . "\n";
    }
} else {
    $errorResponse = json_decode($response, true);
    if ($errorResponse) {
        echo json_encode($errorResponse, JSON_PRETTY_PRINT) . "\n";
    } else {
        echo "Error: HTTP {$httpCode} - {$response}\n";
    }
    exit(1);
}

