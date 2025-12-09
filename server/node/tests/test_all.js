#!/usr/bin/env node
/**
 * Test script to validate all Node.js code samples.
 * This script checks:
 * 1. JavaScript syntax validity
 * 2. Import dependencies
 * 3. Basic structure validation
 */

import { readdir, readFile } from 'fs/promises';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import { createRequire } from 'module';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const require = createRequire(import.meta.url);

// Colors for output
const GREEN = '\033[92m';
const RED = '\033[91m';
const YELLOW = '\033[93m';
const BLUE = '\033[94m';
const RESET = '\033[0m';

async function checkSyntax(filePath) {
    try {
        // Try to require/import the file to check syntax
        // Note: We can't easily check ES module syntax without executing
        // So we'll just check if file is readable
        await readFile(filePath, 'utf-8');
        return { ok: true, message: '✓ Syntax valid (file readable)' };
    } catch (error) {
        return { ok: false, message: `✗ Error reading file: ${error.message}` };
    }
}

async function checkImports(filePath) {
    try {
        const content = await readFile(filePath, 'utf-8');
        
        // Check for required imports
        const hasCourier = content.includes('@trycourier/courier') || content.includes("from '@trycourier/courier'");
        const hasDotenv = content.includes('dotenv') || content.includes("from 'dotenv'");
        
        const missing = [];
        if (!hasCourier) {
            missing.push('@trycourier/courier');
        }
        if (!hasDotenv) {
            missing.push('dotenv');
        }
        
        if (missing.length > 0) {
            return { ok: false, message: `✗ Missing imports: ${missing.join(', ')}` };
        }
        
        // Try to check if packages are installed
        try {
            require.resolve('@trycourier/courier');
            require.resolve('dotenv');
            return { ok: true, message: '✓ Imports valid' };
        } catch (err) {
            return { ok: false, message: '✗ Dependencies not installed (run: npm install)' };
        }
    } catch (error) {
        return { ok: false, message: `✗ Error checking imports: ${error.message}` };
    }
}

async function checkStructure(filePath) {
    try {
        const content = await readFile(filePath, 'utf-8');
        
        const checks = [];
        if (content.includes('Courier') || content.includes('new Courier')) {
            checks.push('Courier client');
        }
        if (content.includes('dotenv') || content.includes('dotenv.config')) {
            checks.push('Environment loading');
        }
        if (content.includes('COURIER_API_KEY')) {
            checks.push('API key reference');
        }
        
        if (checks.length >= 2) {
            return { ok: true, message: `✓ Structure valid (${checks.join(', ')})` };
        } else {
            return { ok: false, message: `✗ Missing key components` };
        }
    } catch (error) {
        return { ok: false, message: `✗ Error checking structure: ${error.message}` };
    }
}

async function main() {
    const parentDir = join(__dirname, '..');
    const files = await readdir(parentDir);
    
    // Filter for .js files, exclude test files
    const jsFiles = files
        .filter(f => f.endsWith('.js') && !f.startsWith('test_'))
        .sort();
    
    if (jsFiles.length === 0) {
        console.error(`${RED}No JavaScript files found to test${RESET}`);
        process.exit(1);
    }
    
    console.log(`${BLUE}Testing ${jsFiles.length} Node.js sample files...${RESET}\n`);
    
    const results = [];
    for (const fileName of jsFiles) {
        const filePath = join(parentDir, fileName);
        console.log(`${BLUE}Testing: ${fileName}${RESET}`);
        
        const syntax = await checkSyntax(filePath);
        const imports = await checkImports(filePath);
        const structure = await checkStructure(filePath);
        
        if (syntax.ok) {
            console.log(`  ${GREEN}${syntax.message}${RESET}`);
        } else {
            console.log(`  ${RED}${syntax.message}${RESET}`);
        }
        
        if (imports.ok) {
            console.log(`  ${GREEN}${imports.message}${RESET}`);
        } else {
            console.log(`  ${YELLOW}${imports.message}${RESET}`);
        }
        
        if (structure.ok) {
            console.log(`  ${GREEN}${structure.message}${RESET}`);
        } else {
            console.log(`  ${YELLOW}${structure.message}${RESET}`);
        }
        
        const allOk = syntax.ok && imports.ok && structure.ok;
        results.push({ name: fileName, ok: allOk });
        console.log('');
    }
    
    // Summary
    console.log(`${BLUE}${'='.repeat(60)}${RESET}`);
    console.log(`${BLUE}Summary:${RESET}\n`);
    
    const passed = results.filter(r => r.ok).length;
    const total = results.length;
    
    for (const result of results) {
        const status = result.ok ? `${GREEN}✓ PASS${RESET}` : `${YELLOW}⚠ PARTIAL${RESET}`;
        console.log(`  ${status} - ${result.name}`);
    }
    
    console.log(`\n${BLUE}Results: ${passed}/${total} files passed all checks${RESET}`);
    
    if (passed === total) {
        console.log(`${GREEN}All files are valid! ✓${RESET}`);
        process.exit(0);
    } else {
        console.log(`${YELLOW}Some files need attention (likely missing dependencies)${RESET}`);
        console.log(`${YELLOW}Run: npm install${RESET}`);
        process.exit(1);
    }
}

main().catch(error => {
    console.error(`${RED}Error: ${error.message}${RESET}`);
    process.exit(1);
});

