<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$list_id = getenv('COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID') ?: '';
$user_id = getenv('COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID') ?: '';

$client = new Client(apiKey: $api_key);

$client->lists->subscriptions->subscribeUser($user_id, [
    'list_id' => $list_id,
    'preferences' => [
        'categories' => (object)[],
        'notifications' => (object)[]
    ]
]);
