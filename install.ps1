# 1. High-Visibility Supply Chain Security Warning & Dependency Checker
Clear-Host
Write-Host "=====================================================================" -ForegroundColor Red
Write-Host " !! SECURITY WARNING: NPM SUPPLY CHAIN VULNERABILITY ALERT !!" -ForegroundColor Red
Write-Host "=====================================================================" -ForegroundColor Red
Write-Host " The JavaScript ecosystem has suffered critical supply chain hacks:" -ForegroundColor Yellow
Write-Host "  * Sept 8, 2025: Malicious maintainer account takeovers (Chalk, Debug)" -ForegroundColor LightGray
Write-Host "  * March 31, 2026: Axios package hijacking (100M+ downloads compromised)" -ForegroundColor LightGray
Write-Host "  * April-May 2026: Multi-registry injections targeting TanStack & AI tools" -ForegroundColor LightGray
Write-Host "`n Execution of 'npm install' can silently fire post-install scripts that" -ForegroundColor Yellow
Write-Host " exfiltrate local environment keys, .env secrets, and cloud tokens." -ForegroundColor Yellow
Write-Host " Verify repository origins before continuing with local software builds." -ForegroundColor Yellow
Write-Host "=====================================================================" -ForegroundColor Red
Write-Host ""

# Risk Acknowledgment Prompt
$ConfirmRun = Read-Host "'I know the risks' (Y/N)"
if ($ConfirmRun -ne "Y" -and $ConfirmRun -ne "y") {
    Write-Host "Installation aborted by user for security evaluation." -ForegroundColor Red
    exit
}

# Environmental Dependency Checks
Write-Host "`n[*] Checking local environmental dependencies..." -ForegroundColor Cyan
$NodeCheck = Get-Command node -ErrorAction SilentlyContinue
$NpmCheck = Get-Command npm -ErrorAction SilentlyContinue

if (-not $NodeCheck -or -not $NpmCheck) {
    Write-Error "CRITICAL: Node.js or NPM is not found in your system PATH environment variables."
    Write-Host "Please download and install Node.js (v18+) before initializing this script." -ForegroundColor Yellow
    exit
}

$NodeVersion = (node -v).Trim()
Write-Host "  -> Verified Node.js version: $NodeVersion" -ForegroundColor Green


# 2. Automated Local AI Setup Engine (Ollama Integration)
Write-Host "`n[*] Auditing Local LLM Layer (Ollama)..." -ForegroundColor Cyan
$OllamaCheck = Get-Command ollama -ErrorAction SilentlyContinue

if (-not $OllamaCheck) {
    Write-Host "[!] Ollama engine not detected. Launching native installer..." -ForegroundColor Yellow
    $OllamaInstallerPath = "$env:TEMP\OllamaSetup.exe"
    
    Write-Host "  -> Downloading Ollama for Windows..." -ForegroundColor Gray
    Invoke-WebRequest -Uri "https://ollama.com" -OutFile $OllamaInstallerPath
    
    Write-Host "  -> Executing installer (Please follow the on-screen prompts)..." -ForegroundColor Green
    Start-Process -FilePath $OllamaInstallerPath -Wait
    
    # Refresh environment path variables inside current session
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Ensure Ollama server backend is actively responding
Write-Host "[*] Confirming Ollama service communication..." -ForegroundColor Cyan
try {
    $Response = Invoke-RestMethod -Uri "http://127.0.0" -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue
    Write-Host "  -> Connected to Ollama background engine successfully." -ForegroundColor Green
} catch {
    Write-Host "[!] Ollama service isn't running. Initializing background daemon..." -ForegroundColor Yellow
    Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 4
}


# Interactive Low-Parameter Model Selection Menu
Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host " SELECT ULTRA-EFFICIENT LOCAL LLM FOR SEARCH INFRASTRUCTURE " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "1) Qwen 2.5 Coder (1.5B) - Elite tool execution/JSON generation [Best For Search Agents]" -ForegroundColor White
Write-Host "2) Gemma 2 (2.7B)       - Superior reasoning performance per parameter footprint" -ForegroundColor White
Write-Host "3) Llama 3.2 (1B)       - Lightest option for low-spec/non-GPU architectures" -ForegroundColor White
Write-Host "4) Skip Model Pull      - Use an already existing model footprint" -ForegroundColor Gray
Write-Host "========================================================" -ForegroundColor Cyan

$ModelSelection = Read-Host "Select target model payload (1-4)"
$TargetModel = ""

switch ($ModelSelection) {
    "1" { $TargetModel = "qwen2.5-coder:1.5b" }
    "2" { $TargetModel = "gemma2:2b" }
    "3" { $TargetModel = "llama3.2:1b" }
    "4" { Write-Host "Skipping background weight fetching step." -ForegroundColor Yellow }
    default { 
        Write-Host "Invalid entry. Defaulting to Qwen 2.5 Coder (1.5B)." -ForegroundColor Yellow
        $TargetModel = "qwen2.5-coder:1.5b"
    }
}

if ($TargetModel -ne "") {
    Write-Host "`n[*] Syncing local AI weights ($TargetModel)..." -ForegroundColor Cyan
    Write-Host "  -> Streaming layer assets down to system core..." -ForegroundColor Gray
    ollama pull $TargetModel
} else {
    $TargetModel = "qwen2.5-coder:1.5b" # Default hook string fallback for config initialization
}


# 3. Define directory paths
$InstallDir = "C:\Local-Perplexity"
$PerplexicaDir = "$InstallDir\perplexica"

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host " Configures and Installs Perplexica locally  " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

if (-not (Test-Path -Path $PerplexicaDir)) {
    Write-Error "Perplexica directory not found! Ensure the first git-cloning script finished successfully."
    exit
}


# 4. Create Backend Configuration (config.toml targeting local Ollama)
Write-Host "`n[1/6] Creating backend config.toml..." -ForegroundColor Yellow
$ConfigContent = @"
[GENERAL]
PORT = 3001
SIMILARITY_MEASURE = "cosine"

[API_KEYS]
OPENAI = ""
OLLAMA = "http://127.0.0.1:11434"

[SEARXNG]
URL = "http://127.0.0.1:8888"
"@
$ConfigContent | Out-File -FilePath "$PerplexicaDir\config.toml" -Encoding utf8


# 5. Create Frontend Environment Variables (.env)
Write-Host "`n[2/6] Creating frontend .env..." -ForegroundColor Yellow
$EnvContent = @"
NEXT_PUBLIC_API_URL=http://127.0.0.1:3001
"@
$EnvContent | Out-File -FilePath "$PerplexicaDir\ui\.env" -Encoding utf8


# Helper function to safely inject security overrides into package.json
function Inject-SecurityOverrides($JsonPath) {
    if (Test-Path $JsonPath) {
        $PackageJson = Get-Content $JsonPath -Raw | ConvertFrom-Json
        
        $OverridesBlock = [pscustomobject]@{
            "axios"  = "^1.7.9"
            "cookie" = "0.7.0"
            "undici" = "^6.21.1"
        }
        
        $PackageJson | Add-Member -Type NoteProperty -Name "overrides" -Value $OverridesBlock -Force
        $PackageJson | ConvertTo-Json -Depth 10 | Out-File $JsonPath -Encoding utf8
        Write-Host "  -> Security overrides successfully injected into $JsonPath" -ForegroundColor Green
    }
}


# 6. Security Scan & Execution: Backend
Write-Host "`n[3/6] Injecting security overrides and auditing Backend dependencies..." -ForegroundColor Yellow
Set-Location -Path $PerplexicaDir
Inject-SecurityOverrides -JsonPath "$PerplexicaDir\package.json"

npm install --package-lock-only

Write-Host "[*] Auditing Backend tree for high/critical vulnerabilities..." -ForegroundColor Cyan
npm audit --audit-level=high
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] Warning: npm audit flagged issues in the backend dependencies." -ForegroundColor Yellow
    $ProceedAudit1 = Read-Host "Do you want to ignore these warnings and proceed with Backend installation? (Y/N)"
    if ($ProceedAudit1 -ne "Y" -and $ProceedAudit1 -ne "y") { exit }
}

Write-Host "Executing full installation for Backend..." -ForegroundColor Green
npm install


# 7. Security Scan & Execution: Frontend
Write-Host "`n[4/6] Shifting directory to Frontend Client..." -ForegroundColor Yellow
Set-Location -Path "$PerplexicaDir\ui"
Inject-SecurityOverrides -JsonPath "$PerplexicaDir\ui\package.json"

Write-Host "[5/6] Fetching Frontend dependency metadata safely..." -ForegroundColor Yellow
npm install --package-lock-only

Write-Host "[*] Auditing Frontend tree for high/critical vulnerabilities..." -ForegroundColor Cyan
npm audit --audit-level=high
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] Warning: npm audit flagged issues in the frontend dependencies." -ForegroundColor Yellow
    $ProceedAudit2 = Read-Host "Do you want to ignore these warnings and proceed with Frontend installation? (Y/N)"
    if ($ProceedAudit2 -ne "Y" -and $ProceedAudit2 -ne "y") { exit }
}

Write-Host "[6/6] Executing full installation for Frontend..." -ForegroundColor Green
npm install


# 8. Execution Instructions
Write-Host "`n=============================================" -ForegroundColor Green
Write-Host " Perplexica Local Installation Complete!   " -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "To start the application layer, run these commands in separate windows:" -ForegroundColor Gray
Write-Host "`nTerminal 1 (Backend Services):" -ForegroundColor White
Write-Host "  cd $PerplexicaDir" -ForegroundColor White
Write-Host "  npm run dev" -ForegroundColor White
Write-Host "`nTerminal 2 (Frontend Client UI):" -ForegroundColor White
Write-Host "  cd $PerplexicaDir\ui" -ForegroundColor White
Write-Host "  npm run dev" -ForegroundColor White
Write-Host "`nPerplexica web application accessible locally at http://localhost:3000" -ForegroundColor Gray
