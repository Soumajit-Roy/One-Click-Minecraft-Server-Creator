Write-Host "
+---------------------------------------------------+
| Welcome to One-Click-Minecraft-Server Creator V.0 |
+---------------------------------------------------+
" -ForegroundColor Cyan

# Check current version of JDK
$jdkVersion = (Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "Java Development Kit*"} | Select-Object DisplayVersion).DisplayVersion

# Get latest version of JDK
$latestVersion = Invoke-WebRequest -Uri "https://www.oracle.com/java/technologies/javase-downloads.html" | Select-String -Pattern "Windows x64\s+([0-9]+\.[0-9]+\.[0-9]+)" | ForEach-Object { $_.Matches.Groups[1].Value }

# Check if latest version is already installed
if ($jdkVersion -eq $latestVersion) {
    Write-Host "JDK is already up to date" -ForegroundColor Green
} else {
    # Download and install latest version of JDK
    $url = "https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe"
    $installerPath = "$($env:TEMP)\jdk.exe"
    Invoke-WebRequest -Uri $url -OutFile $installerPath
    Start-Process $installerPath -ArgumentList "/s ADDLOCAL=\"ToolsFeature,SourceFeature,PublicjreFeature\" INSTALLDIR=`"C:\Program Files\Java\jdk-$latestVersion`"" -Wait
    Write-Host "JDK has been updated to version $latestVersion" -ForegroundColor DarkGreen
}

$folderName = "RequiredItems"
$currentDir = Get-Location
$requiredItemsPath = Join-Path $currentDir $folderName

if (Test-Path $requiredItemsPath) {
    Remove-Item -Path $requiredItemsPath -Recurse -Force
    New-Item -ItemType Directory -Path $requiredItemsPath
    Write-Host "The '$folderName' folder has been deleted and recreated." -ForegroundColor DarkGreen
} else {
    New-Item -ItemType Directory -Path $requiredItemsPath
    Write-Host "The '$folderName' folder has been created." -ForegroundColor Green
}

# Define PaperMC server version
$version = ""

# Define PaperMC server URL
$url = "https://api.papermc.io/v2/projects/paper/versions/1.19.4/builds/466/downloads/paper-1.19.4-466.jar"


# Download PaperMC server file
#$fileName = "paper-$version.jar"
$filePath = Join-Path $requiredItemsPath #$fileName
Invoke-WebRequest -Uri $url -OutFile $filePath

# Display message indicating successful download
Write-Host "PaperMC $version has been downloaded to the '$folderName' folder." -ForegroundColor Green


# Define path to StartServer.bat file
$fileName = "StartServer.bat"
$currentDir = Get-Location
$startServerPath = Join-Path $currentDir $fileName

# Prompt user for RAM allocation
Write-Host "[Remember the server plus the minecraft it will run in background so make sure to allocate ram properly.
 I recommend 1G-2G for Most Systems, but you can change it accordingly to your machine.]" -ForegroundColor Yellow

$maxRam = Read-Host "Enter the maximum RAM allocation for the server in GB (e.g. 4):" 
$minRam = Read-Host "Enter the minimum RAM allocation for the server in GB (e.g. 1):"

# Create StartServer.bat file with updated RAM allocation
$batchCommands = "@echo off`n"
$batchCommands += "java -Xmx${maxRam}G -Xms${minRam}G -jar $serverFileName nogui`n"
$batchCommands += "pause"
Set-Content -Path $startServerPath -Value $batchCommands

# Display message indicating successful creation of StartServer.bat
Write-Host "StartServer.bat has been created with the maximum RAM allocation of ${maxRam} GB and minimum RAM allocation of ${minRam} GB." -ForegroundColor Green

# Define path to RequiredItems folder
$requiredItemsPath = Join-Path $PSScriptRoot "RequiredItems"

# Check if RequiredItems folder exists
if (Test-Path $requiredItemsPath -PathType Container) {
    # Get all files in RequiredItems folder
    $requiredItemsFiles = Get-ChildItem -Path $requiredItemsPath -File
    
    # Display message with file names
    Write-Host "The following files are present in the RequiredItems folder:"
    $requiredItemsFiles | ForEach-Object { Write-Host "  $_" }
} else {
    # RequiredItems folder does not exist, display message
    Write-Host "The RequiredItems folder does not exist in the current directory."
}
# Define path to StartServer.bat file
$startServerPath = Join-Path $PSScriptRoot "StartServer.bat"

# Check if StartServer.bat file exists
if (Test-Path $startServerPath -PathType Leaf) {
    # Execute StartServer.bat file
    Start-Process $startServerPath
    Write-Host "The StartServer.bat file executed once."
} else {
    # StartServer.bat file does not exist, display error message
    Write-Host "The StartServer.bat file does not exist in the current directory."
}

