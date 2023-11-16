function Get-PlatformInfo {
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    
    switch ($arch) {
        "AMD64" { return "X64" }
        "IA64" { return "X64" }
        "ARM64" { return "X64" }
        "EM64T" { return "X64" }
        "x86" { return "X86" }
        default { throw "Unknown architecture: $arch. Submit a bug report to KrystilizeNevaDies/Lethalize." }
    }
}

function Request-String($url) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Lethal Mod Installer PowerShell Script")
    return $webClient.DownloadString($url)
}

function Request-Stream($url) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Lethal Mod Installer PowerShell Script")
    return [System.IO.MemoryStream]::new($webClient.DownloadData($url))
}

function Expand-Stream($zipStream, $destination) {
    # Create a temporary file to save the stream content
    $tempFilePath = [System.IO.Path]::GetTempFileName()

    # replace the temporary file extension with .zip
    $tempFilePath = [System.IO.Path]::ChangeExtension($tempFilePath, "zip")

    # Save the stream content to the temporary file
    $zipStream.Seek(0, [System.IO.SeekOrigin]::Begin)
    $fileStream = [System.IO.File]::OpenWrite($tempFilePath)
    $zipStream.CopyTo($fileStream)
    $fileStream.Close()

    # extract the temporary file to the destination folder
    Expand-Archive -Path $tempFilePath -DestinationPath $destination -Force

    # Delete the temporary file
    Remove-Item -Path $tempFilePath -Force
}

function Get-Arg($arguments, $argName) {
    $argIndex = [Array]::IndexOf($arguments, $argName)
    if ($argIndex -eq -1) {
        # report error
        throw "Argument $argName not found"
    }
    return $arguments[$argIndex + 1]
}

function Install ($arguments) {
    $platform2Asset = @{}

    $platform2Asset["X64"] = "https://github.com/LavaGang/MelonLoader/releases/download/v0.5.7/MelonLoader.x64.zip"
    $platform2Asset["X86"] = "https://github.com/LavaGang/MelonLoader/releases/download/v0.5.7/MelonLoader.x86.zip"

    $platform = Get-PlatformInfo
    Write-Host "Detected platform: $platform"

    $assetUrl = $platform2Asset[$platform]

    if ($null -eq $assetUrl) {
        throw "Failed to find asset for platform $platform"
    }

    Write-Host "Downloading $assetUrl"

    $stream = Request-Stream $assetUrl
    
    Write-Host "Downloaded $assetUrl"
    Write-Host ""

    $lethalCompanyPath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 1966720").InstallLocation
    if ($null -eq $lethalCompanyPath) {
        throw "Steam Lethal Company install not found"
    }

    Write-Host "Lethal Company path: $lethalCompanyPath"
    Write-Host ""

    $pathsToDelete = @(
        "MelonLoader",
        "Mods",
        "Plugins"
    )

    # Delete old files
    foreach ($pathToDelete in $pathsToDelete) {
        $path = Join-Path $lethalCompanyPath $pathToDelete
        if (Test-Path $path) {
            Write-Host "Deleting $path"
            Remove-Item $path -Recurse -Force
        }
    }
    $pathsCount = $pathsToDelete.Length
    if ($pathsCount -gt 0) {
        Write-Host "Deleted $pathsCount paths"
        Write-Host ""
    }

    Write-Host "Installing MelonLoader"
    Expand-Stream $stream $lethalCompanyPath
    Write-Host "Installed MelonLoader"
    Write-Host ""

    # Download and install lcapi
    Write-Host "Downloading and installing MoreCompany"
    $moreCompanyVersion = "1.0.1"
    $moreCompanyUrl = "https://thunderstore.io/package/download/notnotnotswipez/MoreCompany/$moreCompanyVersion/"
    $moreCompanyStream = Request-Stream $moreCompanyUrl
    Expand-Stream $moreCompanyStream $lethalCompanyPath
    Write-Host "Installed MoreCompany"
    Write-Host ""
}

try {
    Install $args
    Write-Host "Install successful"
} catch {
    Write-Host "Install failed: $_"
}

Read-Host “Press ENTER to exit...”
