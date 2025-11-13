using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

// Colors for output
class Colors
{
    public const string GREEN = "\u001b[92m";
    public const string RED = "\u001b[91m";
    public const string YELLOW = "\u001b[93m";
    public const string BLUE = "\u001b[94m";
    public const string RESET = "\u001b[0m";
}

class TestResult
{
    public string Name { get; set; } = "";
    public bool SyntaxOk { get; set; }
    public string SyntaxMessage { get; set; } = "";
    public bool DependenciesOk { get; set; }
    public string DependenciesMessage { get; set; } = "";
    public bool StructureOk { get; set; }
    public string StructureMessage { get; set; } = "";
    public bool AllOk => SyntaxOk && DependenciesOk && StructureOk;
}

class Program
{
    static async Task<TestResult> CheckSyntax(string projectPath)
    {
        var result = new TestResult { Name = Path.GetFileName(Path.GetDirectoryName(projectPath))! };
        
        try
        {
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "dotnet",
                    Arguments = $"build \"{projectPath}\" --no-restore",
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                }
            };
            
            process.Start();
            var output = await process.StandardOutput.ReadToEndAsync();
            var error = await process.StandardError.ReadToEndAsync();
            await process.WaitForExitAsync();
            
            if (process.ExitCode == 0)
            {
                result.SyntaxOk = true;
                result.SyntaxMessage = "✓ Syntax valid (build succeeded)";
            }
            else
            {
                result.SyntaxOk = false;
                var errorLines = error.Split('\n').Where(l => l.Contains("error")).Take(2);
                result.SyntaxMessage = $"✗ Build failed: {string.Join("; ", errorLines)}";
            }
        }
        catch (Exception ex)
        {
            result.SyntaxOk = false;
            result.SyntaxMessage = $"✗ Error checking syntax: {ex.Message}";
        }
        
        return result;
    }
    
    static TestResult CheckDependencies(string projectPath)
    {
        var result = new TestResult { Name = Path.GetFileName(Path.GetDirectoryName(projectPath))! };
        
        try
        {
            var content = File.ReadAllText(projectPath);
            
            if (content.Contains("DotNetEnv"))
            {
                result.DependenciesOk = true;
                result.DependenciesMessage = "✓ Dependencies declared (DotNetEnv)";
            }
            else
            {
                result.DependenciesOk = false;
                result.DependenciesMessage = "✗ Missing DotNetEnv package reference";
            }
        }
        catch (Exception ex)
        {
            result.DependenciesOk = false;
            result.DependenciesMessage = $"✗ Error checking dependencies: {ex.Message}";
        }
        
        return result;
    }
    
    static TestResult CheckStructure(string programPath)
    {
        var result = new TestResult { Name = Path.GetFileName(Path.GetDirectoryName(programPath))! };
        
        try
        {
            var content = File.ReadAllText(programPath);
            
            var checks = new List<string>();
            if (content.Contains("HttpClient") || content.Contains("System.Net.Http"))
            {
                checks.Add("HttpClient");
            }
            if (content.Contains("DotNetEnv") || content.Contains("Env.Load"))
            {
                checks.Add("Environment loading");
            }
            if (content.Contains("COURIER_API_KEY"))
            {
                checks.Add("API key reference");
            }
            if (content.Contains("System.Text.Json") || content.Contains("JsonSerializer"))
            {
                checks.Add("JSON serialization");
            }
            
            if (checks.Count >= 3)
            {
                result.StructureOk = true;
                result.StructureMessage = $"✓ Structure valid ({string.Join(", ", checks)})";
            }
            else
            {
                result.StructureOk = false;
                result.StructureMessage = $"✗ Missing key components (found: {string.Join(", ", checks)})";
            }
        }
        catch (Exception ex)
        {
            result.StructureOk = false;
            result.StructureMessage = $"✗ Error checking structure: {ex.Message}";
        }
        
        return result;
    }
    
    static async Task<int> Main(string[] args)
    {
        // Get the parent directory (server/csharp) from the tests directory
        // Use the assembly location to find the correct base path
        var assemblyLocation = System.Reflection.Assembly.GetExecutingAssembly().Location;
        var assemblyDir = Path.GetDirectoryName(assemblyLocation) ?? Directory.GetCurrentDirectory();
        
        // Navigate from bin/Debug/net10.0/... to server/csharp
        var parentDir = assemblyDir;
        while (parentDir != null && !Path.GetFileName(parentDir).Equals("csharp", StringComparison.OrdinalIgnoreCase))
        {
            var parent = Directory.GetParent(parentDir);
            if (parent == null) break;
            parentDir = parent.FullName;
        }
        
        // If we couldn't find csharp directory, try going up from current directory
        if (parentDir == null || !Directory.Exists(parentDir))
        {
            var currentDir = Directory.GetCurrentDirectory();
            if (currentDir.Contains("tests"))
            {
                parentDir = Path.GetFullPath(Path.Combine(currentDir, ".."));
            }
            else
            {
                parentDir = currentDir;
            }
        }
        
        // Find all project directories (exclude tests directory)
        var projectDirs = Directory.GetDirectories(parentDir)
            .Where(d => 
            {
                var dirName = Path.GetFileName(d);
                return dirName != "tests" && 
                       dirName != "bin" && 
                       dirName != "obj" &&
                       File.Exists(Path.Combine(d, dirName + ".csproj"));
            })
            .OrderBy(d => d)
            .ToList();
        
        if (projectDirs.Count == 0)
        {
            Console.WriteLine($"{Colors.RED}No C# project directories found to test{Colors.RESET}");
            return 1;
        }
        
        Console.WriteLine($"{Colors.BLUE}Testing {projectDirs.Count} C# sample projects...{Colors.RESET}\n");
        
        var results = new List<TestResult>();
        
        foreach (var projectDir in projectDirs)
        {
            var projectName = Path.GetFileName(projectDir);
            var projectPath = Path.Combine(projectDir, projectName + ".csproj");
            var programPath = Path.Combine(projectDir, "Program.cs");
            
            if (!File.Exists(projectPath) || !File.Exists(programPath))
            {
                continue;
            }
            
            Console.WriteLine($"{Colors.BLUE}Testing: {projectName}{Colors.RESET}");
            
            // First restore dependencies
            try
            {
                var restoreProcess = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "dotnet",
                        Arguments = $"restore \"{projectPath}\"",
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                        CreateNoWindow = true
                    }
                };
                restoreProcess.Start();
                await restoreProcess.WaitForExitAsync();
            }
            catch { }
            
            var syntaxResult = await CheckSyntax(projectPath);
            var depsResult = CheckDependencies(projectPath);
            var structureResult = CheckStructure(programPath);
            
            var combinedResult = new TestResult
            {
                Name = projectName,
                SyntaxOk = syntaxResult.SyntaxOk,
                SyntaxMessage = syntaxResult.SyntaxMessage,
                DependenciesOk = depsResult.DependenciesOk,
                DependenciesMessage = depsResult.DependenciesMessage,
                StructureOk = structureResult.StructureOk,
                StructureMessage = structureResult.StructureMessage
            };
            
            if (combinedResult.SyntaxOk)
            {
                Console.WriteLine($"  {Colors.GREEN}{combinedResult.SyntaxMessage}{Colors.RESET}");
            }
            else
            {
                Console.WriteLine($"  {Colors.RED}{combinedResult.SyntaxMessage}{Colors.RESET}");
            }
            
            if (combinedResult.DependenciesOk)
            {
                Console.WriteLine($"  {Colors.GREEN}{combinedResult.DependenciesMessage}{Colors.RESET}");
            }
            else
            {
                Console.WriteLine($"  {Colors.YELLOW}{combinedResult.DependenciesMessage}{Colors.RESET}");
            }
            
            if (combinedResult.StructureOk)
            {
                Console.WriteLine($"  {Colors.GREEN}{combinedResult.StructureMessage}{Colors.RESET}");
            }
            else
            {
                Console.WriteLine($"  {Colors.YELLOW}{combinedResult.StructureMessage}{Colors.RESET}");
            }
            
            results.Add(combinedResult);
            Console.WriteLine();
        }
        
        // Summary
        Console.WriteLine($"{Colors.BLUE}{new string('=', 60)}{Colors.RESET}");
        Console.WriteLine($"{Colors.BLUE}Summary:{Colors.RESET}\n");
        
        var passed = results.Count(r => r.AllOk);
        var total = results.Count;
        
        foreach (var result in results)
        {
            var status = result.AllOk ? $"{Colors.GREEN}✓ PASS{Colors.RESET}" : $"{Colors.YELLOW}⚠ PARTIAL{Colors.RESET}";
            Console.WriteLine($"  {status} - {result.Name}");
        }
        
        Console.WriteLine($"\n{Colors.BLUE}Results: {passed}/{total} projects passed all checks{Colors.RESET}");
        
        if (passed == total)
        {
            Console.WriteLine($"{Colors.GREEN}All projects are valid! ✓{Colors.RESET}");
            return 0;
        }
        else
        {
            Console.WriteLine($"{Colors.YELLOW}Some projects need attention{Colors.RESET}");
            return 1;
        }
    }
}

