# XbenchAutoQA Setup Wizard
# Version 1.0.1
# Sets up configuration for automatic Xbench QA workflow

$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "          Xbench Auto-QA Setup Wizard                  " -ForegroundColor Cyan
Write-Host "          Setup for automatic QA workflow              " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "This script helps you set up automatic QA execution" -ForegroundColor Gray
Write-Host "with Xbench for MemoQ XLIFF files." -ForegroundColor Gray
Write-Host ""

# Function to test if path exists
function Test-PathValid {
    param([string]$Path)
    return Test-Path -Path $Path -PathType Leaf
}

# Function to find Xbench installation
function Find-Xbench {
    $possiblePaths = @(
        "C:\Program Files (x86)\ApSIC\Xbench\xbench.exe",
        "C:\Program Files\ApSIC\Xbench\xbench.exe",
        "C:\Program Files (x86)\Xbench\xbench.exe",
        "C:\Program Files\Xbench\xbench.exe"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            return $path
        }
    }
    return $null
}

# Step 1: Find Xbench
Write-Host "[1/3] Finding Xbench..." -ForegroundColor Yellow
$xbenchPath = Find-Xbench

if ($xbenchPath) {
    Write-Host "Found Xbench: $xbenchPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "Is this correct? [Y/n]: " -NoNewline -ForegroundColor White
    $confirm = Read-Host
    
    if ($confirm -eq "n" -or $confirm -eq "N") {
        Write-Host ""
        Write-Host "Enter full path to xbench.exe: " -NoNewline -ForegroundColor White
        $xbenchPath = Read-Host
        
        if (-not (Test-PathValid $xbenchPath)) {
            Write-Host "ERROR: Cannot find xbench.exe at specified path!" -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
    }
}
else {
    Write-Host "Could not find Xbench automatically." -ForegroundColor Red
    Write-Host ""
    Write-Host "Enter full path to xbench.exe: " -NoNewline -ForegroundColor White
    $xbenchPath = Read-Host
    
    if (-not (Test-PathValid $xbenchPath)) {
        Write-Host "ERROR: Cannot find xbench.exe at specified path!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Xbench path confirmed" -ForegroundColor Green
}

# Step 2: Watch folder
Write-Host ""
Write-Host "[2/3] Select watch folder for XLIFF files" -ForegroundColor Yellow
$defaultWatchFolder = "C:\Translation\XbenchQA"

Write-Host "Default: $defaultWatchFolder" -ForegroundColor Gray
Write-Host "Press Enter for default, or enter desired path: " -NoNewline -ForegroundColor White
$watchFolder = Read-Host

if ([string]::IsNullOrWhiteSpace($watchFolder)) {
    $watchFolder = $defaultWatchFolder
}

# Create watch folder if it doesn't exist
if (-not (Test-Path $watchFolder)) {
    Write-Host "Folder does not exist. Creating folder..." -ForegroundColor Yellow
    try {
        New-Item -Path $watchFolder -ItemType Directory -Force | Out-Null
        Write-Host "Folder created: $watchFolder" -ForegroundColor Green
    }
    catch {
        Write-Host "ERROR: Could not create folder!" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}
else {
    Write-Host "Folder confirmed: $watchFolder" -ForegroundColor Green
}

# Step 3: Additional settings
Write-Host ""
Write-Host "[3/3] Additional settings" -ForegroundColor Yellow

Write-Host ""
Write-Host "Should QA start automatically after project creation? [y/N]: " -NoNewline -ForegroundColor White
$autoStartInput = Read-Host
$autoStartQA = ($autoStartInput -eq "y" -or $autoStartInput -eq "Y")

Write-Host "Enable logging? [Y/n]: " -NoNewline -ForegroundColor White
$logInput = Read-Host
$logEnabled = -not ($logInput -eq "n" -or $logInput -eq "N")

# Create config object
$config = @{
    watchFolder = $watchFolder
    xbenchPath = $xbenchPath
    autoStartQA = $autoStartQA
    logEnabled = $logEnabled
    version = "1.0.1"
    createdDate = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}

# Save config
$configPath = Join-Path $PSScriptRoot "config.json"
try {
    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
    Write-Host ""
    Write-Host "Configuration saved: $configPath" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "ERROR: Could not save configuration!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Create logs folder if logging is enabled
if ($logEnabled) {
    $logsFolder = Join-Path $PSScriptRoot "logs"
    if (-not (Test-Path $logsFolder)) {
        New-Item -Path $logsFolder -ItemType Directory -Force | Out-Null
    }
}

# Summary
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "                    Setup Complete!                     " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Watch folder: $watchFolder" -ForegroundColor White
Write-Host "  Xbench: $xbenchPath" -ForegroundColor White
Write-Host "  Auto-start QA: $(if($autoStartQA){'Yes'}else{'No'})" -ForegroundColor White
Write-Host "  Logging: $(if($logEnabled){'Enabled'}else{'Disabled'})" -ForegroundColor White
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Export MQXLIFF file from MemoQ to: $watchFolder" -ForegroundColor White
Write-Host "  2. Run: .\XbenchAutoQA.ps1" -ForegroundColor White
Write-Host "  3. The script will detect the file automatically!" -ForegroundColor White
Write-Host ""

Read-Host "Press Enter to exit"
