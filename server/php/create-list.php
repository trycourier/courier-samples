<?php
require_once __DIR__ . '/vendor/autoload.php';
use Courier\Client;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->safeLoad();

$api_key = $_ENV['COURIER_API_KEY'] ?? '';
$list_id = $_ENV['COURIER_CREATE_LIST_LIST_ID'] ?? '';
$list_name = $_ENV['COURIER_CREATE_LIST_LIST_NAME'] ?? 'My List Name';

$client = new Client(apiKey: $api_key);

$client->lists->update($list_id, name: $list_name);
