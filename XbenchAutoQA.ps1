# XbenchAutoQA - Automatic Xbench QA Runner for MemoQ Files
# Version 1.2.0 - Stable Release

$ErrorActionPreference = "Stop"
$configPath = Join-Path $PSScriptRoot "config.json"

# Check if config exists
if (-not (Test-Path $configPath)) {
    Write-Host "ERROR: Configuration file not found!" -ForegroundColor Red
    Write-Host "Please run Setup-XbenchAutoQA.ps1 first" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Load configuration
try {
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
}
catch {
    Write-Host "ERROR: Could not read configuration!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Verify config
if (-not (Test-Path $config.xbenchPath)) {
    Write-Host "ERROR: Xbench not found: $($config.xbenchPath)" -ForegroundColor Red
    Write-Host "Please run Setup-XbenchAutoQA.ps1 again" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

if (-not (Test-Path $config.watchFolder)) {
    Write-Host "ERROR: Watch folder not found: $($config.watchFolder)" -ForegroundColor Red
    exit 1
}

# Track processed files
$script:processedFiles = @{}

# Logging function
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    if ($config.logEnabled) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "[$timestamp] [$Level] $Message"
        
        $logsFolder = Join-Path $PSScriptRoot "logs"
        if (-not (Test-Path $logsFolder)) {
            New-Item -Path $logsFolder -ItemType Directory -Force | Out-Null
        }
        
        $logFile = Join-Path $logsFolder "XbenchAutoQA_$(Get-Date -Format 'yyyyMMdd').log"
        Add-Content -Path $logFile -Value $logMessage
    }
}

# Helper function to escape XML special characters
function Escape-XmlString {
    param([string]$Text)

    return $Text -replace '&', '&amp;' `
                -replace '<', '&lt;' `
                -replace '>', '&gt;' `
                -replace '"', '&quot;' `
                -replace "'", '&apos;'
}

# Function to create Xbench project file with multiple MQXLIFF files
function New-XbenchBatchProject {
    param(
        [string[]]$XliffPaths,
        [string]$ProjectPath
    )

    try {
        # Use the working goddamnfuckingshit.xbp as template
        $workingTemplate = "C:\Mac\Home\Downloads\goddamnfuckingshit.xbp"

        if (-not (Test-Path $workingTemplate)) {
            throw "Template file not found: $workingTemplate. Please ensure goddamnfuckingshit.xbp exists."
        }

        # Read the working template file with exact encoding
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        $content = [System.IO.File]::ReadAllText($workingTemplate, $utf8NoBom)

        # Build glossary entries
        $glossaryEntries = @()
        $ident = 0
        foreach ($xliffPath in $XliffPaths) {
            # Convert C:\ path to \\Mac\ path for Parallels compatibility
            $xliffPathForXbench = $xliffPath -replace '^C:\\Mac\\', '\\Mac\'
            # Escape XML special characters in the path
            $xliffPathEscaped = Escape-XmlString $xliffPathForXbench

            $entry = @"
      <glossary type="26">
        <ident>$ident</ident>
        <filename xml:space="preserve">$xliffPathEscaped</filename>
        <level>1</level>
        <process>0</process>
        <static>0</static>
        <srclang>0</srclang>
        <trglang>0</trglang>
        <flag>0</flag>
        <comments></comments>
        <removedupes>0</removedupes>
        <newtranslations>1</newtranslations>
        <swapsourcetarget>0</swapsourcetarget>
        <keyterms>0</keyterms>
        <autorefresh>0</autorefresh>
      </glossary>
"@
            $glossaryEntries += $entry
            $ident++
        }

        # Join with proper line endings (no extra blank line between entries)
        $glossaryXml = $glossaryEntries -join "`r`n"

        # Convert C:\ path to \\Mac\ path for Parallels compatibility
        $xbpPathForXbench = $ProjectPath -replace '^C:\\Mac\\', '\\Mac\'
        # Escape XML special characters in the project path
        $xbpPathEscaped = Escape-XmlString $xbpPathForXbench

        # Replace the project filename path
        $content = $content -replace '<filename xml:space="preserve">.*?</filename>', "<filename xml:space=`"preserve`">$xbpPathEscaped</filename>"

        # Replace the glossarylist section
        $content = $content -replace '(?s)<glossarylist>.*?</glossarylist>', "<glossarylist>`r`n$glossaryXml    </glossarylist>"

        # Write file with UTF-8 WITHOUT BOM (required by Xbench)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($ProjectPath, $content, $utf8NoBom)

        Write-Log "Xbench batch project created with $($XliffPaths.Count) files: $ProjectPath"
        return $true
    }
    catch {
        Write-Log "Error creating batch Xbench project: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Function to create Xbench project file
function New-XbenchProject {
    param(
        [string]$XliffPath,
        [string]$ProjectPath
    )

    try {
        # Convert C:\ path to \\Mac\ path for Parallels compatibility
        $xbpPathForXbench = $ProjectPath -replace '^C:\\Mac\\', '\\Mac\'
        $xliffPathForXbench = $XliffPath -replace '^C:\\Mac\\', '\\Mac\'
        # Escape XML special characters
        $xbpPathEscaped = Escape-XmlString $xbpPathForXbench
        $xliffPathEscaped = Escape-XmlString $xliffPathForXbench

        # Write using StreamWriter with UTF-8 WITHOUT BOM (required by Xbench)
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        $writer = New-Object System.IO.StreamWriter($ProjectPath, $false, $utf8NoBom)
        $writer.NewLine = "`r`n"

        $writer.WriteLine('<?xml version="1.0" ?>')
        $writer.WriteLine('<xbench version="2.9.438" savedwith="3.0.1603">')
        $writer.WriteLine('  <project>')
        $writer.WriteLine("    <filename xml:space=""preserve"">$xbpPathEscaped</filename>")
        $writer.WriteLine('    <maxcols>0</maxcols>')
        $writer.WriteLine('    <showfilename>1</showfilename>')
        $writer.WriteLine('    <showkeytermsattop>1</showkeytermsattop>')
        $writer.WriteLine('    <removedupes>0</removedupes>')
        $writer.WriteLine('    <autorefreshinterval>0</autorefreshinterval>')
        $writer.WriteLine('    <instructions xml:space="preserve"></instructions>')
        $writer.WriteLine('    <memoryfile></memoryfile>')
        $writer.WriteLine('    <checklistgroup>')
        $writer.WriteLine('      <checklist name="$project"></checklist>')
        $writer.WriteLine('    </checklistgroup>')
        $writer.WriteLine('    <glossarylist>')
        $writer.WriteLine('      <glossary type="26">')
        $writer.WriteLine('        <ident>0</ident>')
        $writer.WriteLine("        <filename xml:space=""preserve"">$xliffPathEscaped</filename>")
        $writer.WriteLine('        <level>1</level>')
        $writer.WriteLine('        <process>0</process>')
        $writer.WriteLine('        <static>0</static>')
        $writer.WriteLine('        <srclang>0</srclang>')
        $writer.WriteLine('        <trglang>0</trglang>')
        $writer.WriteLine('        <flag>0</flag>')
        $writer.WriteLine('        <comments></comments>')
        $writer.WriteLine('        <removedupes>0</removedupes>')
        $writer.WriteLine('        <newtranslations>1</newtranslations>')
        $writer.WriteLine('        <swapsourcetarget>0</swapsourcetarget>')
        $writer.WriteLine('        <keyterms>0</keyterms>')
        $writer.WriteLine('        <autorefresh>0</autorefresh>')
        $writer.WriteLine('      </glossary>')
        $writer.WriteLine('    </glossarylist>')
        $writer.WriteLine('  </project>')
        $writer.WriteLine('</xbench>')

        $writer.Close()

        Write-Log "Xbench project created: $ProjectPath"
        return $true
    }
    catch {
        if ($writer) { $writer.Close() }
        Write-Log "Error creating Xbench project: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Function to handle file
function Process-XliffFile {
    param([string]$FilePath)
    
    $fileName = Split-Path $FilePath -Leaf
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  New file detected: $fileName" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Log "New file detected: $FilePath"
    
    # Show options
    Write-Host "Choose action:" -ForegroundColor Yellow
    Write-Host "  [1] Quick QA (MQXLIFF only, default settings)" -ForegroundColor White
    Write-Host "  [2] Advanced setup (add termlists/checklists)" -ForegroundColor White
    Write-Host "  [Enter] Ignore this file" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Your choice (1/2): " -NoNewline -ForegroundColor White
    
    # Read input
    $choice = Read-Host
    
    if ([string]::IsNullOrWhiteSpace($choice)) {
        Write-Host ""
        Write-Host "File ignored" -ForegroundColor Gray
        Write-Log "File ignored by user: $FilePath"
        return
    }
    
    if ($choice -ne "1" -and $choice -ne "2") {
        Write-Host ""
        Write-Host "Invalid choice. File ignored." -ForegroundColor Red
        Write-Log "Invalid choice for file: $FilePath" -Level "WARN"
        return
    }
    
    # Create Xbench project
    $projectName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $projectPath = Join-Path $config.watchFolder "$projectName.xbp"
    
    Write-Host ""
    Write-Host "Creating Xbench project..." -ForegroundColor Yellow
    
    if (-not (New-XbenchProject -XliffPath $FilePath -ProjectPath $projectPath)) {
        Write-Host "ERROR: Could not create project!" -ForegroundColor Red
        return
    }
    
    Write-Host "Project created: $projectPath" -ForegroundColor Green
    
    # Launch Xbench
    try {
        if ($choice -eq "1") {
            Write-Host "Starting Xbench with quick QA..." -ForegroundColor Yellow
            Write-Log "Starting Xbench (quick QA): $projectPath"
            
            if ($config.autoStartQA) {
                Start-Process -FilePath $config.xbenchPath -ArgumentList "`"$projectPath`"" -NoNewWindow
                Write-Host "Xbench started - QA runs automatically" -ForegroundColor Green
            }
            else {
                Start-Process -FilePath $config.xbenchPath -ArgumentList "`"$projectPath`""
                Write-Host "Xbench started - run QA manually (F5)" -ForegroundColor Green
            }
        }
        else {
            Write-Host "Starting Xbench in advanced mode..." -ForegroundColor Yellow
            Write-Log "Starting Xbench (advanced): $projectPath"
            
            Start-Process -FilePath $config.xbenchPath -ArgumentList "`"$projectPath`""
            Write-Host "Xbench started - add files and run QA manually" -ForegroundColor Green
            Write-Host "  Tip: Add termlists, checklists, etc. before running QA" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "ERROR: Could not start Xbench!" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Log "Error starting Xbench: $($_.Exception.Message)" -Level "ERROR"
        return
    }
    
    Write-Host ""
    Write-Host "Ready for next file..." -ForegroundColor Gray
    Write-Host ""
}

# Main
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "          Xbench Auto-QA Runner v1.2.0                 " -ForegroundColor Cyan
Write-Host "          Batch Processing + Live Monitoring           " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Watching: $($config.watchFolder)" -ForegroundColor White
Write-Host "  Xbench: $($config.xbenchPath)" -ForegroundColor White
Write-Host "  Auto-start QA: $(if($config.autoStartQA){'Yes'}else{'No'})" -ForegroundColor White
Write-Host "  Logging: $(if($config.logEnabled){'Enabled'}else{'Disabled'})" -ForegroundColor White
Write-Host ""

Write-Host "Monitoring folder for new MQXLIFF/XLIFF files..." -ForegroundColor Green
Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
Write-Host ""

Write-Log "XbenchAutoQA v1.2.0 started (polling mode) - watching: $($config.watchFolder)"

# Check for existing files at startup
$existingFiles = Get-ChildItem -Path $config.watchFolder -File | Where-Object {
    $_.Extension -eq ".xlf" -or $_.Extension -eq ".xliff" -or $_.Extension -eq ".mqxliff" -or $_.Extension -eq ".mxliff"
}

if ($existingFiles.Count -ge 2) {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Yellow
    Write-Host "  BATCH MODE: Found $($existingFiles.Count) existing MQXLIFF files" -ForegroundColor Yellow
    Write-Host "========================================================" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($file in $existingFiles) {
        Write-Host "  - $($file.Name)" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "Process files:" -ForegroundColor Yellow
    Write-Host "  [1] Create single project with all files" -ForegroundColor White
    Write-Host "  [Enter] Skip and start monitoring for new files" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Your choice (1/Enter): " -NoNewline -ForegroundColor White
    
    $batchChoice = Read-Host
    
    if ($batchChoice -eq "1") {
        Write-Host ""
        Write-Host "Creating batch project..." -ForegroundColor Yellow
        
        # Create batch project with timestamp
        $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
        $batchProjectName = "Batch_$timestamp"
        $batchProjectPath = Join-Path $config.watchFolder "$batchProjectName.xbp"
        
        $xliffPaths = $existingFiles | ForEach-Object { $_.FullName }
        
        if (New-XbenchBatchProject -XliffPaths $xliffPaths -ProjectPath $batchProjectPath) {
            Write-Host "Batch project created: $batchProjectName.xbp" -ForegroundColor Green
            Write-Host "  Files included: $($existingFiles.Count)" -ForegroundColor Gray
            Write-Host ""
            Write-Host "Starting Xbench..." -ForegroundColor Yellow
            
            try {
                Start-Process -FilePath $config.xbenchPath -ArgumentList "`"$batchProjectPath`""
                Write-Host "Xbench started with batch project" -ForegroundColor Green
                Write-Host "  Tip: Run QA (F5) to check all files at once!" -ForegroundColor Gray
                Write-Log "Batch project opened in Xbench: $batchProjectPath"
            }
            catch {
                Write-Host "ERROR: Could not start Xbench!" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
                Write-Log "Error starting Xbench with batch project: $($_.Exception.Message)" -Level "ERROR"
            }
            
            # Mark all files as processed
            foreach ($file in $existingFiles) {
                $script:processedFiles[$file.FullName] = $true
            }
            
            Write-Host ""
            Write-Host "Batch processing complete. Starting monitoring mode..." -ForegroundColor Green
            Write-Host ""
        }
        else {
            Write-Host "ERROR: Could not create batch project!" -ForegroundColor Red
            Write-Host "Skipping batch mode, starting monitoring..." -ForegroundColor Yellow
            Write-Host ""
        }
    }
    else {
        Write-Host ""
        Write-Host "Skipping existing files. Starting monitoring mode..." -ForegroundColor Gray
        Write-Host ""
        
        # Mark all existing files as processed so they won't be picked up
        foreach ($file in $existingFiles) {
            $script:processedFiles[$file.FullName] = $true
        }
        Write-Log "Skipped $($existingFiles.Count) existing files at startup"
    }
}
elseif ($existingFiles.Count -eq 1) {
    Write-Host ""
    Write-Host "Found 1 existing file: $($existingFiles[0].Name)" -ForegroundColor Gray
    Write-Host "Marking as processed. Waiting for new files..." -ForegroundColor Gray
    Write-Host ""
    
    # Mark the single file as processed
    $script:processedFiles[$existingFiles[0].FullName] = $true
    Write-Log "Skipped 1 existing file at startup: $($existingFiles[0].Name)"
}

Write-Host "Monitoring for new files..." -ForegroundColor Green
Write-Host ""

try {
    while ($true) {
        # Get all XLIFF files in watch folder
        $files = Get-ChildItem -Path $config.watchFolder -File | Where-Object {
            $_.Extension -eq ".xlf" -or $_.Extension -eq ".xliff" -or $_.Extension -eq ".mqxliff" -or $_.Extension -eq ".mxliff"
        }
        
        foreach ($file in $files) {
            $filePath = $file.FullName
            
            # Check if we've already processed this file (by name only)
            if (-not $script:processedFiles.ContainsKey($filePath)) {
                # Mark as processed before handling (to avoid double-processing)
                $script:processedFiles[$filePath] = $true
                
                # Small delay to ensure file is fully written
                Start-Sleep -Milliseconds 500
                
                # Process the file
                Process-XliffFile -FilePath $filePath
            }
        }
        
        # Clean up old entries (keep only last 100 files)
        if ($script:processedFiles.Count -gt 100) {
            $keysToRemove = $script:processedFiles.Keys | Select-Object -First 50
            foreach ($key in $keysToRemove) {
                $script:processedFiles.Remove($key)
            }
        }
        
        # Wait before next check
        Write-Host "." -NoNewline -ForegroundColor Gray
        Start-Sleep -Seconds 2
    }
}
finally {
    Write-Log "XbenchAutoQA stopped"
    Write-Host ""
    Write-Host "Stopped" -ForegroundColor Yellow
}
