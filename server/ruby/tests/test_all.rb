#!/usr/bin/env ruby
# Test script to validate all Ruby code samples.
# This script checks:
# 1. Ruby syntax validity
# 2. Import dependencies
# 3. Basic structure validation

require 'fileutils'

# Colors for output
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
RESET = "\033[0m"

def check_syntax(file_path)
  begin
    # Use Ruby's syntax checker
    result = `ruby -c "#{file_path}" 2>&1`
    if $?.success?
      { ok: true, message: "✓ Syntax valid" }
    else
      { ok: false, message: "✗ Syntax error: #{result.chomp}" }
    end
  rescue => e
    { ok: false, message: "✗ Error checking syntax: #{e.message}" }
  end
end

def check_imports(file_path)
  begin
    content = File.read(file_path)
    
    # Check for required imports
    has_dotenv = content.include?('dotenv') || content.include?("require 'dotenv'")
    has_json = content.include?('json') || content.include?("require 'json'")
    has_net_http = content.include?('net/http') || content.include?("require 'net/http'")
    
    missing = []
    missing << 'dotenv' unless has_dotenv
    missing << 'json' unless has_json
    missing << 'net/http' unless has_net_http
    
    if missing.any?
      { ok: false, message: "✗ Missing requires: #{missing.join(', ')}" }
    else
      # Try to check if gems are available
      begin
        require 'dotenv'
        require 'json'
        require 'net/http'
        { ok: true, message: "✓ Imports valid" }
      rescue LoadError => e
        { ok: false, message: "✗ Dependencies not installed (run: bundle install)" }
      end
    end
  rescue => e
    { ok: false, message: "✗ Error checking imports: #{e.message}" }
  end
end

def check_structure(file_path)
  begin
    content = File.read(file_path)
    
    checks = []
    checks << "Environment loading" if content.include?('Dotenv.load') || content.include?('dotenv')
    checks << "API key reference" if content.include?('COURIER_API_KEY')
    checks << "HTTP client" if content.include?('Net::HTTP') || content.include?('net/http')
    checks << "JSON handling" if content.include?('JSON') || content.include?('json')
    checks << "Authorization header" if content.include?('Authorization') && content.include?('Bearer')
    
    if checks.length >= 2
      { ok: true, message: "✓ Structure valid (#{checks.join(', ')})" }
    else
      { ok: false, message: "✗ Missing key components" }
    end
  rescue => e
    { ok: false, message: "✗ Error checking structure: #{e.message}" }
  end
end

def main
  # Get parent directory (server/ruby)
  test_dir = File.dirname(__FILE__)
  parent_dir = File.dirname(test_dir)
  
  # Find all .rb files in parent directory
  ruby_files = Dir.glob(File.join(parent_dir, "*.rb"))
    .reject { |f| File.basename(f).start_with?('test_') }
    .sort
  
  if ruby_files.empty?
    puts "#{RED}No Ruby files found to test#{RESET}"
    exit 1
  end
  
  puts "#{BLUE}Testing #{ruby_files.length} Ruby sample files...#{RESET}\n"
  
  results = []
  ruby_files.each do |file_path|
    file_name = File.basename(file_path)
    puts "#{BLUE}Testing: #{file_name}#{RESET}"
    
    syntax = check_syntax(file_path)
    imports = check_imports(file_path)
    structure = check_structure(file_path)
    
    if syntax[:ok]
      puts "  #{GREEN}#{syntax[:message]}#{RESET}"
    else
      puts "  #{RED}#{syntax[:message]}#{RESET}"
    end
    
    if imports[:ok]
      puts "  #{GREEN}#{imports[:message]}#{RESET}"
    else
      puts "  #{YELLOW}#{imports[:message]}#{RESET}"
    end
    
    if structure[:ok]
      puts "  #{GREEN}#{structure[:message]}#{RESET}"
    else
      puts "  #{YELLOW}#{structure[:message]}#{RESET}"
    end
    
    all_ok = syntax[:ok] && imports[:ok] && structure[:ok]
    results << { name: file_name, ok: all_ok }
    puts ""
  end
  
  # Summary
  puts "#{BLUE}#{'=' * 60}#{RESET}"
  puts "#{BLUE}Summary:#{RESET}\n"
  
  passed = results.count { |r| r[:ok] }
  total = results.length
  
  results.each do |result|
    status = result[:ok] ? "#{GREEN}✓ PASS#{RESET}" : "#{YELLOW}⚠ PARTIAL#{RESET}"
    puts "  #{status} - #{result[:name]}"
  end
  
  puts "\n#{BLUE}Results: #{passed}/#{total} files passed all checks#{RESET}"
  
  if passed == total
    puts "#{GREEN}All files are valid! ✓#{RESET}"
    exit 0
  else
    puts "#{YELLOW}Some files need attention (likely missing dependencies)#{RESET}"
    puts "#{YELLOW}Run: bundle install#{RESET}"
    exit 1
  end
end

main

