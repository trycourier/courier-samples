<?php
/**
 * Send a template to an email address
 */

require __DIR__ . '/vendor/autoload.php';

use Dotenv\Dotenv;

// Load environment variables from .env file in server directory (shared across all language examples)
$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

$apiKey = $_ENV['COURIER_API_KEY'] ?? '';
$email = $_ENV['COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL'] ?? '';
$templateId = $_ENV['COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID'] ?? '';

// Build request body
$requestBody = [
    'message' => [
        'to' => [
            'email' => $email
        ],
        'template' => $templateId,
        'data' => [
            'name' => 'Your Name'
        ]
    ]
];

// Make API request
$url = 'https://api.courier.com/send';
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

