<?php
/**
 * Test script to validate all PHP code samples.
 * This script checks:
 * 1. PHP syntax validity
 * 2. Import dependencies
 * 3. Basic structure validation
 */

// Colors for output
define('GREEN', "\033[92m");
define('RED', "\033[91m");
define('YELLOW', "\033[93m");
define('BLUE', "\033[94m");
define('RESET', "\033[0m");

function checkSyntax($filePath) {
    // Use php -l to check syntax
    $output = [];
    $returnVar = 0;
    exec("php -l " . escapeshellarg($filePath) . " 2>&1", $output, $returnVar);
    
    if ($returnVar === 0) {
        return ['ok' => true, 'message' => '✓ Syntax valid'];
    } else {
        $error = implode("\n", $output);
        return ['ok' => false, 'message' => '✗ Syntax error: ' . $error];
    }
}

function checkImports($filePath) {
    $content = file_get_contents($filePath);
    
    // Check for required imports
    $hasDotenv = strpos($content, 'Dotenv') !== false || strpos($content, 'dotenv') !== false;
    $hasCurl = strpos($content, 'curl_') !== false || strpos($content, 'CURLOPT_') !== false;
    
    $missing = [];
    if (!$hasDotenv) {
        $missing[] = 'vlucas/phpdotenv';
    }
    if (!$hasCurl) {
        $missing[] = 'curl extension';
    }
    
    if (!empty($missing)) {
        return ['ok' => false, 'message' => '✗ Missing dependencies: ' . implode(', ', $missing)];
    }
    
    // Try to check if composer dependencies are available
    $vendorPath = dirname($filePath) . '/vendor/autoload.php';
    if (!file_exists($vendorPath)) {
        return ['ok' => false, 'message' => '✗ Dependencies not installed (run: composer install)'];
    }
    
    return ['ok' => true, 'message' => '✓ Imports valid'];
}

function checkStructure($filePath) {
    $content = file_get_contents($filePath);
    
    $checks = [];
    if (strpos($content, 'Dotenv') !== false || strpos($content, 'dotenv') !== false) {
        $checks[] = 'Environment loading';
    }
    if (strpos($content, 'COURIER_API_KEY') !== false) {
        $checks[] = 'API key reference';
    }
    if (strpos($content, 'curl_') !== false || strpos($content, 'CURLOPT_') !== false) {
        $checks[] = 'HTTP client';
    }
    if (strpos($content, 'Authorization') !== false && strpos($content, 'Bearer') !== false) {
        $checks[] = 'Authorization header';
    }
    if (strpos($content, 'json_encode') !== false || strpos($content, 'json_decode') !== false) {
        $checks[] = 'JSON handling';
    }
    
    if (count($checks) >= 2) {
        return ['ok' => true, 'message' => '✓ Structure valid (' . implode(', ', $checks) . ')'];
    } else {
        return ['ok' => false, 'message' => '✗ Missing key components'];
    }
}

function main() {
    // Get parent directory (server/php)
    $testDir = __DIR__;
    $parentDir = dirname($testDir);
    
    // Find all .php files in parent directory
    $phpFiles = glob($parentDir . '/*.php');
    $phpFiles = array_filter($phpFiles, function($file) {
        return !strpos(basename($file), 'test_');
    });
    sort($phpFiles);
    
    if (empty($phpFiles)) {
        echo RED . "No PHP files found to test" . RESET . "\n";
        exit(1);
    }
    
    echo BLUE . "Testing " . count($phpFiles) . " PHP sample files..." . RESET . "\n\n";
    
    $results = [];
    foreach ($phpFiles as $filePath) {
        $fileName = basename($filePath);
        echo BLUE . "Testing: {$fileName}" . RESET . "\n";
        
        $syntax = checkSyntax($filePath);
        $imports = checkImports($filePath);
        $structure = checkStructure($filePath);
        
        if ($syntax['ok']) {
            echo "  " . GREEN . $syntax['message'] . RESET . "\n";
        } else {
            echo "  " . RED . $syntax['message'] . RESET . "\n";
        }
        
        if ($imports['ok']) {
            echo "  " . GREEN . $imports['message'] . RESET . "\n";
        } else {
            echo "  " . YELLOW . $imports['message'] . RESET . "\n";
        }
        
        if ($structure['ok']) {
            echo "  " . GREEN . $structure['message'] . RESET . "\n";
        } else {
            echo "  " . YELLOW . $structure['message'] . RESET . "\n";
        }
        
        $allOk = $syntax['ok'] && $imports['ok'] && $structure['ok'];
        $results[] = ['name' => $fileName, 'ok' => $allOk];
        echo "\n";
    }
    
    // Summary
    echo BLUE . str_repeat('=', 60) . RESET . "\n";
    echo BLUE . "Summary:" . RESET . "\n\n";
    
    $passed = 0;
    foreach ($results as $result) {
        if ($result['ok']) {
            echo "  " . GREEN . "✓ PASS" . RESET . " - {$result['name']}\n";
            $passed++;
        } else {
            echo "  " . YELLOW . "⚠ PARTIAL" . RESET . " - {$result['name']}\n";
        }
    }
    
    $total = count($results);
    echo "\n" . BLUE . "Results: {$passed}/{$total} files passed all checks" . RESET . "\n";
    
    if ($passed === $total) {
        echo GREEN . "All files are valid! ✓" . RESET . "\n";
        exit(0);
    } else {
        echo YELLOW . "Some files need attention (likely missing dependencies)" . RESET . "\n";
        echo YELLOW . "Run: composer install" . RESET . "\n";
        exit(1);
    }
}

main();

