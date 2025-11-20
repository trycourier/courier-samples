<?php
require_once __DIR__ . '/../vendor/autoload.php';
use Courier\Client;

$api_key = getenv('COURIER_API_KEY') ?: '';
$list_id = getenv('COURIER_CREATE_LIST_LIST_ID') ?: '';
$list_name = getenv('COURIER_CREATE_LIST_LIST_NAME') ?: 'My List Name';

$client = new Client(apiKey: $api_key);

$client->lists->update($list_id, [
    'name' => $list_name,
    'preferences' => [
        'categories' => (object)[],
        'notifications' => (object)[]
    ]
]);
