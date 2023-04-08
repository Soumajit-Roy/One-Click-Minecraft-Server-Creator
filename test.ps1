# Set the batch file path
$batchFilePath = "D:\My Files Sam\Coding\Github\One-Click-Minecraft-Server-Creator\RequiredItems\StartServer.bat"

# Check if the batch file exists
if (Test-Path $batchFilePath) {
    # Start the batch file with administrative rights
    Start-Process -FilePath $batchFilePath -ArgumentList "" -Verb RunAs
} else {
    Write-Host "The batch file '$batchFilePath' does not exist." -ForegroundColor Red
}
