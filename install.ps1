#######################################
# Build script Author: Akira 'Aya' Nikki Meir
# gh akira-nikki-meir 
# yinlang.akira@gmail.com
#######################################
#######################################
# The real heroes are the open source contributors that made this unified project possible



# 1. High-Visibility Supply Chain Security Warning & Dependency Checker
Clear-Host
Write-Output "====================================================================="
Write-Warning "!! SECURITY WARNING: NPM SUPPLY CHAIN VULNERABILITY ALERT !!"
Write-Output "====================================================================="
Write-Output " The JavaScript ecosystem has suffered critical supply chain hacks:"
Write-Output "  * Sept 8, 2025: Malicious maintainer account takeovers (Chalk, Debug)"
Write-Output "  * March 31, 2026: Axios package hijacking (100M+ downloads compromised)"
Write-Output "  * April-May 2026: Multi-registry injections targeting TanStack & AI tools"
Write-Output ""
Write-Warning " Execution of 'npm install' can silently fire post-install scripts that"
Write-Warning " exfiltrate local environment keys, .env secrets, and cloud tokens."
Write-Output " Verify repository origins before continuing with local software builds."
Write-Output "====================================================================="
Write-Output ""

# Risk Acknowledgment Prompt
$ConfirmRun = Read-Host "'I know the risks' (Y/N)"
if ($ConfirmRun -ne "Y" -and $ConfirmRun -ne "y") {
    Write-Warning "Installation aborted by user for security evaluation."
    exit
}

# Environmental Dependency Checks
Write-Output ""
Write-Output "[*] Checking local environmental dependencies..."
$NodeCheck = Get-Command node -ErrorAction SilentlyContinue
$NpmCheck = Get-Command npm -ErrorAction SilentlyContinue 
$GitCheck = Get-Command git -ErrorAction SilentlyContinue

if (-not $NodeCheck -or -not $NpmCheck -or -not $GitCheck) {
    Write-Error "CRITICAL: Node.js, NPM, or Git is missing from your system PATH environment variables."
    Write-Output "Please download and install Git and Node.js (v18+) before initializing this script."
    exit
}

$NodeVersion = (node -v).Trim()
Write-Output "  -> Verified Node.js version: $NodeVersion"


# 2. Automated Local AI Setup Engine (Ollama Integration)
Write-Output ""
Write-Output "[*] Auditing Local LLM Layer (Ollama)..."
$OllamaCheck = Get-Command ollama -ErrorAction SilentlyContinue

if (-not $OllamaCheck) {
    Write-Warning "[!] Ollama engine not detected. Launching native installer..."
    OllamaInstallerPath = "env:TEMP\OllamaSetup.exe"
    Write-Output "  -> Downloading Ollama for Windows..."
    Invoke-WebRequest -Uri "https://ollama.com" -OutFile $OllamaInstallerPath
    Write-Output "  -> Executing installer (Please follow the on-screen prompts)..."
    Start-Process -FilePath (OllamaInstallerPath -Wait)env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Ensure Ollama server backend is actively responding
Write-Output "[*] Confirming Ollama service communication..."
try {
    [void](Invoke-RestMethod -Uri "http://127.0.0" -Method Get -TimeoutSec 3 -ErrorAction SilentlyContinue)
    Write-Output "  -> Connected to Ollama background engine successfully."
} catch {
    Write-Warning "[!] Ollama service isn't running. Initializing background daemon..."
    Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 4
}


# Interactive Low-Parameter Model Selection Menu
Write-Output ""
Write-Output "========================================================"
Write-Output " SELECT ULTRA-EFFICIENT LOCAL LLM FOR SEARCH INFRASTRUCTURE "
Write-Output "========================================================"
Write-Output "1) Qwen 2.5 Coder (1.5B) - Elite tool execution/JSON generation [Best For Search Agents]"
Write-Output "2) Gemma 2 (2.7B)       - Superior reasoning performance per parameter footprint"
Write-Output "3) Llama 3.2 (1B)       - Lightest option for low-spec/non-GPU architectures"
Write-Output "4) Skip Model Pull      - Use an already existing model footprint"
Write-Output "========================================================"

$ModelSelection = Read-Host "Select target model payload (1-4)"
$TargetModel = ""

switch ($ModelSelection) {
    "1" { $TargetModel = "qwen2.5-coder:1.5b" }
    "2" { $TargetModel = "gemma2:2b" }
    "3" { $TargetModel = "llama3.2:1b" }
    "4" { Write-Output "Skipping background weight fetching step." }
    default {
        Write-Warning "Invalid entry. Defaulting to Qwen 2.5 Coder (1.5B)."
        $TargetModel = "qwen2.5-coder:1.5b"
    }
}

if ($TargetModel -ne "") {
    Write-Output ""
    Write-Output "[*] Syncing local AI weights ($TargetModel)..."
    Write-Output "  -> Streaming layer assets down to system core..."
    ollama pull $TargetModel
}


# 3. Target Workspace Creation & Absolute Repository Provisioning
$InstallDir = "C:\Local-Perplexica"
$SearxDir = "$InstallDir\searxng-windows"
$PerplexicaDir = "$InstallDir\perplexica"




Write-Output "`n============================================="
Write-Output "  Downloading Repositories (Git Clone)       "
Write-Output "============================================="

# Force create target directory structure explicitly
if (-not (Test-Path -Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

Set-Location -Path $InstallDir

if (-not (Test-Path -Path $SearxDir)) {
    Write-Warning "[*] Cloning SearXNG-Windows..."
    git clone -b main https://github.com/akira-nikki-meir/searxng-windows/
    if (-not (Test-Path -Path $SearxDir)) {
        Write-Error "CRITICAL: Failed to clone SearXNG-Windows repository. Aborting script to prevent path execution errors."
        exit
    }
}

if (-not (Test-Path -Path $PerplexicaDir)) {
    Write-Warning "[*] Cloning Perplexica..."
    git clone https://github.com/ItzCrazyKns/perplexica
    if (-not (Test-Path -Path $PerplexicaDir)) {
        Write-Error "CRITICAL: Failed to clone Perplexica repository. Aborting script to prevent path execution errors."
        exit
    }
}



# [Previous environmental validations and cloning sequences run here...]

Write-Output "[*] Transitioning console thread context into SearXNG environment..."
if (Test-Path -Path "$SearxDir\searxnginstall.ps1") {
    # 1. Physically step the active shell location down into the target workspace
    Set-Location -Path $SearxDir
   # 2. Use the call operator with a string literal to explicitly lock execution down to SearXNG's installer
    & "$SearxDir\searxnginstall.ps1"
   
    # 3. Step back up to the parent layer to continue Perplexica's configuration build
    Set-Location -Path $InstallDir
} else {
    Write-Error "CRITICAL: Target framework file not found at: $SearxDir\install.ps1"
    exit
}



# 4. Run SearXNG Native Windows Setup Wizard
$searxnginstall="$SearxDir\searxnginstall.ps1"
Write-Output "[*] Initializing SearXNG Native Framework..."
if (Test-Path -Path "$searxnginstall") {
    Set-Location -Path $SearxDir
    & "$searxnginstall"
} else {
    Write-Error "CRITICAL: SearXNG setup target path failed validation at: $SearxDir\install.ps1"
    exit
}


# 5. Create Backend Configuration (config.toml targeting local Ollama)
Write-Output ""
Write-Output "[*] Generating system integration maps..."
if (-not (Test-Path -Path $PerplexicaDir)) {
    Write-Error "CRITICAL: Perplexica installation folder path cannot be resolved."
    exit
}

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


# 6. Create Frontend Environment Variables (.env)
#if (-not (Test-Path -Path "$PerplexicaDir\ui")) {
#    New-Item -ItemType Directory -Force -Path "$PerplexicaDir\ui" | Out-Null
#}
$EnvContent = @"
NEXT_PUBLIC_API_URL=http://127.0.0.1:3001
"@
$EnvContent | Out-File -FilePath "$PerplexicaDir\ui\.env" -Encoding utf8


# Helper function to safely inject security overrides into package.json
function Update-SecurityOverride($JsonPath) {
    if (Test-Path $JsonPath) {
        $PackageJson = Get-Content $JsonPath -Raw | ConvertFrom-Json
        
        # Safely align the primary dependencies version to eliminate conflicts
        if ($PackageJson.dependencies) {
            if ($PackageJson.dependencies.axios) { $PackageJson.dependencies.axios = "^1.7.9" }
            if ($PackageJson.dependencies.cookie) { $PackageJson.dependencies.cookie = "0.7.0" }
            if ($PackageJson.dependencies.undici) { $PackageJson.dependencies.undici = "^6.21.1" }
        }
        # Inject corresponding safety resolution blocks
        $OverridesBlock = [pscustomobject]@{
            "axios"  = "^1.7.9"
            "cookie" = "0.7.0"
            "undici" = "^6.21.1"
        }
        $PackageJson | Add-Member -Type NoteProperty -Name "overrides" -Value $OverridesBlock -Force
        $PackageJson | ConvertTo-Json -Depth 10 | Out-File $JsonPath -Encoding utf8
        Write-Output "  -> Security overrides successfully injected into $JsonPath"
    }
}


# 7. Security Scan & Execution: Backend
Write-Output ""
Write-Output "[3/6] Running assembly controls for search backend..."
Set-Location -Path $PerplexicaDir
Update-SecurityOverride -JsonPath "$PerplexicaDir\package.json"

npm install --package-lock-only --force

Write-Output "[*] Auditing Backend tree for high/critical vulnerabilities..."
npm audit --audit-level=high
if ($LASTEXITCODE -ne 0) {
    Write-Warning "[!] Warning: npm audit flagged issues in the backend dependencies."
    $ProceedAudit1 = Read-Host "Do you want to ignore these warnings and proceed with Backend installation? (Y/N)"
    if ($ProceedAudit1 -ne "Y" -and $ProceedAudit1 -ne "y") { exit }
}

Write-Output "Executing full installation for Backend..."
npm install --force


# 8. Security Scan & Execution: Frontend
Write-Output ""
Write-Output "[4/6] Shifting directory to Frontend Client..."
Set-Location -Path "$PerplexicaDir\ui"
Update-SecurityOverride -JsonPath "$PerplexicaDir\ui\package.json"

npm install --package-lock-only --force

Write-Output "[*] Auditing Frontend tree for high/critical vulnerabilities..."
npm audit --audit-level=high
if ($LASTEXITCODE -ne 0) {
    Write-Warning "[!] Warning: npm audit flagged issues in the frontend dependencies."
    $ProceedAudit2 = Read-Host "Do you want to ignore these warnings and proceed with Backend installation? (Y/N)"
    if ($ProceedAudit2 -ne "Y" -and $ProceedAudit2 -ne "y") { exit }
}

Write-Output "[6/6] Executing full installation for Frontend..."
npm install --force


# 9. Execution Instructions
Write-Output ""
Write-Output "============================================="
Write-Output " Perplexica Local Installation Complete!   "
Write-Output "============================================="
Write-Output "To start the search application, run these commands in separate windows:"
Write-Output ""
Write-Output "Terminal 1 (SearXNG Web Engine):"
Write-Output "  cd C:\Local-Perplexica\searxng-windows"
Write-Output "  .\start.bat"
Write-Output ""
Write-Output "Terminal 2 (Backend Services):"
Write-Output "  cd $PerplexicaDir"
Write-Output "  npm run dev"
Write-Output ""
Write-Output "Terminal 3 (Frontend Client UI):"
Write-Output "  cd $PerplexicaDir\ui"
Write-Output "  npm run dev"
Write-Output ""
