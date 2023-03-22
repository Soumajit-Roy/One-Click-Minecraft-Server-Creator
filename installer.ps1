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
    Write-Host "JDK is already up to date"
} else {
    # Download and install latest version of JDK
    $url = "https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.exe"
    $installerPath = "$($env:TEMP)\jdk.exe"
    Invoke-WebRequest -Uri $url -OutFile $installerPath
    Start-Process $installerPath -ArgumentList "/s ADDLOCAL=\"ToolsFeature,SourceFeature,PublicjreFeature\" INSTALLDIR=`"C:\Program Files\Java\jdk-$latestVersion`"" -Wait
    Write-Host "JDK has been updated to version $latestVersion"
}
