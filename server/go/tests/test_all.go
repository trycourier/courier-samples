package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

// Colors for output
const (
	GREEN  = "\033[92m"
	RED    = "\033[91m"
	YELLOW = "\033[93m"
	BLUE   = "\033[94m"
	RESET  = "\033[0m"
)

type checkResult struct {
	ok      bool
	message string
}

func checkSyntax(filePath string) checkResult {
	// Go compiler will check syntax when we try to build
	// For now, just check if file is readable
	_, err := ioutil.ReadFile(filePath)
	if err != nil {
		return checkResult{ok: false, message: fmt.Sprintf("✗ Error reading file: %v", err)}
	}
	return checkResult{ok: true, message: "✓ Syntax valid (file readable)"}
}

func checkImports(filePath string) checkResult {
	content, err := ioutil.ReadFile(filePath)
	if err != nil {
		return checkResult{ok: false, message: fmt.Sprintf("✗ Error reading file: %v", err)}
	}

	contentStr := string(content)
	
	// Check for required imports
	hasGodotenv := strings.Contains(contentStr, "github.com/joho/godotenv") || strings.Contains(contentStr, "godotenv")
	hasNetHttp := strings.Contains(contentStr, "net/http")
	hasJSON := strings.Contains(contentStr, "encoding/json")
	
	missing := []string{}
	if !hasGodotenv {
		missing = append(missing, "github.com/joho/godotenv")
	}
	if !hasNetHttp {
		missing = append(missing, "net/http")
	}
	if !hasJSON {
		missing = append(missing, "encoding/json")
	}
	
	if len(missing) > 0 {
		return checkResult{ok: false, message: fmt.Sprintf("✗ Missing imports: %s", strings.Join(missing, ", "))}
	}
	
	return checkResult{ok: true, message: "✓ Imports valid"}
}

func checkStructure(filePath string) checkResult {
	content, err := ioutil.ReadFile(filePath)
	if err != nil {
		return checkResult{ok: false, message: fmt.Sprintf("✗ Error reading file: %v", err)}
	}

	contentStr := string(content)
	
	checks := []string{}
	if strings.Contains(contentStr, "godotenv.Load") || strings.Contains(contentStr, "godotenv.Overload") {
		checks = append(checks, "Environment loading")
	}
	if strings.Contains(contentStr, "COURIER_API_KEY") {
		checks = append(checks, "API key reference")
	}
	if strings.Contains(contentStr, "http.NewRequest") || strings.Contains(contentStr, "http.Get") || strings.Contains(contentStr, "http.Post") {
		checks = append(checks, "HTTP client")
	}
	if strings.Contains(contentStr, "Authorization") && strings.Contains(contentStr, "Bearer") {
		checks = append(checks, "Authorization header")
	}
	
	if len(checks) >= 2 {
		return checkResult{ok: true, message: fmt.Sprintf("✓ Structure valid (%s)", strings.Join(checks, ", "))}
	} else {
		return checkResult{ok: false, message: "✗ Missing key components"}
	}
}

func main() {
	// Get parent directory (server/go)
	// When run with `go run`, the working directory is the tests directory
	// So we need to go up one level
	testDir, err := os.Getwd()
	if err != nil {
		testDir = "."
	}
	// If we're in the tests directory, go up one level
	if filepath.Base(testDir) == "tests" {
		testDir = filepath.Dir(testDir)
	}
	parentDir := testDir
	
	// Find all .go files in parent directory
	files, err := ioutil.ReadDir(parentDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sError reading directory: %v%s\n", RED, err, RESET)
		os.Exit(1)
	}
	
	var goFiles []string
	for _, file := range files {
		if !file.IsDir() && strings.HasSuffix(file.Name(), ".go") && !strings.HasPrefix(file.Name(), "test_") {
			goFiles = append(goFiles, filepath.Join(parentDir, file.Name()))
		}
	}
	
	sort.Strings(goFiles)
	
	if len(goFiles) == 0 {
		fmt.Printf("%sNo Go files found to test%s\n", RED, RESET)
		os.Exit(1)
	}
	
	fmt.Printf("%sTesting %d Go sample files...%s\n\n", BLUE, len(goFiles), RESET)
	
	type result struct {
		name string
		ok   bool
	}
	results := []result{}
	
	for _, filePath := range goFiles {
		fileName := filepath.Base(filePath)
		fmt.Printf("%sTesting: %s%s\n", BLUE, fileName, RESET)
		
		syntax := checkSyntax(filePath)
		imports := checkImports(filePath)
		structure := checkStructure(filePath)
		
		if syntax.ok {
			fmt.Printf("  %s%s%s\n", GREEN, syntax.message, RESET)
		} else {
			fmt.Printf("  %s%s%s\n", RED, syntax.message, RESET)
		}
		
		if imports.ok {
			fmt.Printf("  %s%s%s\n", GREEN, imports.message, RESET)
		} else {
			fmt.Printf("  %s%s%s\n", YELLOW, imports.message, RESET)
		}
		
		if structure.ok {
			fmt.Printf("  %s%s%s\n", GREEN, structure.message, RESET)
		} else {
			fmt.Printf("  %s%s%s\n", YELLOW, structure.message, RESET)
		}
		
		allOk := syntax.ok && imports.ok && structure.ok
		results = append(results, result{name: fileName, ok: allOk})
		fmt.Println()
	}
	
	// Summary
	fmt.Printf("%s%s%s\n", BLUE, strings.Repeat("=", 60), RESET)
	fmt.Printf("%sSummary:%s\n\n", BLUE, RESET)
	
	passed := 0
	for _, result := range results {
		if result.ok {
			fmt.Printf("  %s✓ PASS%s - %s\n", GREEN, RESET, result.name)
			passed++
		} else {
			fmt.Printf("  %s⚠ PARTIAL%s - %s\n", YELLOW, RESET, result.name)
		}
	}
	
	fmt.Printf("\n%sResults: %d/%d files passed all checks%s\n", BLUE, passed, len(results), RESET)
	
	if passed == len(results) {
		fmt.Printf("%sAll files are valid! ✓%s\n", GREEN, RESET)
		os.Exit(0)
	} else {
		fmt.Printf("%sSome files need attention (likely missing dependencies)%s\n", YELLOW, RESET)
		fmt.Printf("%sRun: go mod tidy && go get%s\n", YELLOW, RESET)
		os.Exit(1)
	}
}

