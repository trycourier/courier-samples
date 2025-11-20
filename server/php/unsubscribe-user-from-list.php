<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$list_id = getenv('COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID') ?: '';
$user_id = getenv('COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID') ?: '';

$client = new Client(apiKey: $api_key);

$client->lists->subscriptions->unsubscribeUser($user_id, ['list_id' => $list_id]);
