<?php
/**
 * Generate JWT token for user authentication
 */

require __DIR__ . '/vendor/autoload.php';

use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$userId = $_ENV['COURIER_GENERATE_JWT_USER_ID'] ?? '';
$expiresInDays = $_ENV['COURIER_EXPIRES_IN_DAYS'] ?? '30';

// Build request body
$requestBody = [
    'scope' => "user_id:{$userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
    'expires_in' => "{$expiresInDays} days"
];

// Make API request
$url = 'https://api.courier.com/auth/issue-token';
$ch = curl_init($url);

curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_POST => true,
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
    $responseData = json_decode($response, true);
    echo json_encode($responseData, JSON_PRETTY_PRINT) . "\n";
} else {
    $errorResponse = json_decode($response, true);
    if ($errorResponse) {
        echo json_encode($errorResponse, JSON_PRETTY_PRINT) . "\n";
    } else {
        echo "Error: HTTP {$httpCode} - {$response}\n";
    }
    exit(1);
}

