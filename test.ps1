$hd = Invoke-WebRequest -UseBasicParsing -Method Head 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive'

# Extract the file name from the response.
$downloadFileName = $hd.BaseResponse.ResponseUri.Segments[-1]