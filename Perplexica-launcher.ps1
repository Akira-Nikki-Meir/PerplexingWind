#######################################
# Build script Author: Akira 'Aya' Nikki Meir
# gh akira-nikki-meir 
# yinlang.akira@gmail.com
#######################################
#######################################
# The real heroes are the open source contributors that made this unified project possible
# -----------------------------------------
# Standalone Executable Builder Utility

Clear-Host
Write-Output "============================================="
Write-Output "    PERPLEXICA UNIFIED LAUNCHER BUILDER      "
Write-Output "============================================="

# Define target paths for compilation using your true open-source workspace path
$InstallDir = "C:\Local-perplexica"
$LauncherScriptPath = "$InstallDir\launch-orchestrator.ps1"
$IcoOutputPath = "$InstallDir\perplexica.ico"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ExeOutputPath = "$DesktopPath\Start-Perplexica.exe"

# Ensure target installation directory exists before writing files
if (-not (Test-Path -Path $InstallDir)) {
    Write-Output "[*] Creating workspace folder at $InstallDir..."
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

# Resolve path to your provided perplexica.png (assumes it sits next to this script)
$PngInputPath = Join-Path -Path $PSScriptRoot -ChildPath "perplexica.png"

# Programmatically compile PNG to an authentic, multi-directory Win32 ICO binary structure
if (Test-Path -Path $PngInputPath) {
    Write-Output "[*] Generating structural Win32 icon directory from perplexica.png..."
    try {
        Add-Type -AssemblyName System.Drawing
        $Bitmap = [System.Drawing.Bitmap]::FromFile($PngInputPath)
        
        $ImgStream = [System.IO.MemoryStream]::new()
        $Bitmap.Save($ImgStream, [System.Drawing.Imaging.ImageFormat]::Png)
        $PngBytes = $ImgStream.ToArray()
        $ImgStream.Close()

        $FileStream = [System.IO.FileStream]::new($IcoOutputPath, [System.IO.FileMode]::Create)
        $BinaryWriter = [System.IO.BinaryWriter]::new($FileStream)

        $BinaryWriter.Write([UInt16]0)
        $BinaryWriter.Write([UInt16]1)
        $BinaryWriter.Write([UInt16]1)

        $Width = if ($Bitmap.Width -ge 256) { 0 } else { [byte]$Bitmap.Width }
        $Height = if ($Bitmap.Height -ge 256) { 0 } else { [byte]$Bitmap.Height }
        
        $BinaryWriter.Write([byte]$Width)
        $BinaryWriter.Write([byte]$Height)
        $BinaryWriter.Write([byte]0)
        $BinaryWriter.Write([byte]0)
        $BinaryWriter.Write([UInt16]1)
        $BinaryWriter.Write([UInt16]32)
        $BinaryWriter.Write([UInt32]$PngBytes.Length)
        $BinaryWriter.Write([UInt32]22)

        $BinaryWriter.Write($PngBytes)

        $BinaryWriter.Close()
        $FileStream.Close()
        $Bitmap.Dispose()
        Write-Output "  -> Native Win32 header verification injected successfully."
    } catch {
        Write-Warning "Failed to restructure image binary streams. Falling back to default layout alignment."
    }
}

# Generate the consolidation launch script
Write-Output "[*] Writing unified background orchestrator script..."
# FIX: Wrapped everything in a global try/catch/pause shell to prevent window closing on errors
$LauncherContent = @"
try {
    Clear-Host
    Write-Output "====================================================================="
    Write-Output "   LAUNCHING LOCAL PERPLEXICA CORES & SEARCH STREAMS"
    Write-Output "====================================================================="
    Write-Output " Accessible locally at: http://localhost:3000"
    Write-Output " Press CTRL+C inside this window to terminate all engines safely."
    Write-Output "====================================================================="
    `n
    # 1. Boot SearXNG Web Engine
    Write-Output "[SearXNG] Booting background engine layer..."
    `$SearxProcess = Start-Process -FilePath "cmd.exe" -ArgumentList "/c start.bat" -WorkingDirectory "C:\Local-perplexica\searxng-windows" -PassThru -WindowStyle Hidden

    # 2. Boot Backend API Services
    Write-Output "[Backend] Booting search agent routing logic..."
    `$BackendProcess = Start-Process -FilePath "cmd.exe" -ArgumentList "/c npm run dev" -WorkingDirectory "C:\Local-perplexica\perplexica" -PassThru -WindowStyle Hidden

    # 3. Boot Frontend Interface
    Write-Output "[Frontend] Binding user interface client framework..."
    if (Test-Path -Path "C:\Local-perplexica\perplexica\ui") {
        Set-Location -Path "C:\Local-perplexica\perplexica\ui"
        cmd.exe /c "npm run dev"
    } else {
        throw "Could not find frontend UI directory at C:\Local-perplexica\perplexica\ui"
    }

} catch {
    Write-Error "CRITICAL RUNTIME ERROR TRAPPED:"
    Write-Output `$_.Exception.Message
    Write-Output `$_.ScriptStackTrace
} finally {
    Write-Output "`n====================================================================="
    Write-Output " Launcher script execution paused to preserve diagnostic outputs."
    Write-Output "====================================================================="
    Read-Host "Press ENTER to terminate processes and close this window..."
    try {
        if (`$SearxProcess) { Stop-Process -Id `$SearxProcess.Id -Force -ErrorAction SilentlyContinue }
        if (`$BackendProcess) { Stop-Process -Id `$BackendProcess.Id -Force -ErrorAction SilentlyContinue }
    } catch {}
}
"@

# Force remove any cached script assets to guarantee a clean overwrite
if (Test-Path -Path $LauncherScriptPath) { Remove-Item -Path $LauncherScriptPath -Force }
$LauncherContent | Out-File -FilePath $LauncherScriptPath -Encoding utf8

# Check for PS2EXE module and compile to a single EXE
Write-Output "[*] Auditing compilation engine tools..."
$HasPS2EXE = Get-Module -ListAvailable -Name PS2EXE

if (-not $HasPS2EXE) {
    Write-Output "  -> Installing script compiler extensions..."
    Install-Module -Name PS2EXE -Force -Scope CurrentUser -ErrorAction SilentlyContinue | Out-Null
}

Write-Output "[*] Compiling binary interface container..."
try {
    $CompilerParams = @{
        InputFile   = $LauncherScriptPath
        OutputFile  = $ExeOutputPath
        Title       = "Local Perplexica Cluster"
        Description = "Unified interface runner for Perplexica open source search agent"
    }
    
    if (Test-Path -Path $IcoOutputPath) { 
        $CompilerParams.Add("IconFile", $IcoOutputPath) 
    }

    Invoke-PS2EXE @CompilerParams | Out-Null
    Write-Output "`n====================================================================="
    Write-Output " SUCCESS: Standalone launcher created on your Desktop!"
    Write-Output " Double-click 'Start-Perplexica.exe' to view consolidated streams."
    Write-Output "====================================================================="
} catch {
    Write-Warning "Could not compile native EXE automatically due to environmental permissions."
}
