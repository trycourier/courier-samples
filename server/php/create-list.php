<?php
/**
 * Create or update a list using the Courier API
 */

require __DIR__ . '/vendor/autoload.php';

use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$listId = $_ENV['COURIER_CREATE_LIST_LIST_ID'] ?? '';
$listName = $_ENV['COURIER_CREATE_LIST_LIST_NAME'] ?? 'My List Name';

// Build request body
$requestBody = [
    'name' => $listName,
    'preferences' => [
        'categories' => (object)[],
        'notifications' => (object)[]
    ]
];

// Make API request
$url = "https://api.courier.com/lists/{$listId}";
$ch = curl_init($url);

curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CUSTOMREQUEST => 'PUT',
    CURLOPT_HTTPHEADER => [
        'Authorization: Bearer ' . $apiKey,
        'Content-Type: application/json',
        'Accept: application/json'
    ],
    CURLOPT_POSTFIELDS => json_encode($requestBody)
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
    echo json_encode([
        'success' => true,
        'message' => "List '{$listId}' created/updated successfully",
        'list_id' => $listId,
        'list_name' => $listName
    ], JSON_PRETTY_PRINT) . "\n";
} else {
    $errorResponse = json_decode($response, true);
    if ($errorResponse) {
        echo json_encode($errorResponse, JSON_PRETTY_PRINT) . "\n";
    } else {
        echo "Error: HTTP {$httpCode} - {$response}\n";
    }
    exit(1);
}

