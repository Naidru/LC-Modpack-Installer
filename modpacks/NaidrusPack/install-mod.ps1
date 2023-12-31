function Get-PlatformInfo {
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    
    switch ($arch) {
        "AMD64" { return "X64" }
        "IA64" { return "X64" }
        "ARM64" { return "X64" }
        "EM64T" { return "X64" }
        "x86" { return "X86" }
        default { throw "Unknown architecture: $arch. Submit a bug report." }
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

function Get-Arg($argName, $defaultValue) {
    $argIndex = [Array]::IndexOf($args, $argName)
    if ($argIndex -eq -1) {
        return $defaultValue
    }
    return $args[$argIndex + 1]
}

function Install {
    $response = Request-String "https://api.github.com/repos/BepInEx/BepInEx/releases/latest"
    $jsonObject = ConvertFrom-Json $response

    $platform2Asset = @{}

    foreach ($assetNode in $jsonObject.assets) {
        if ($null -eq $assetNode) { continue }
        
        $asset = $assetNode

        $name = $asset.name

        switch -Wildcard ($name) {
            "BepInEx_unix*" { $platform2Asset["Unix"] = $asset.browser_download_url; break }
            "BepInEx_x64*" { $platform2Asset["X64"] = $asset.browser_download_url; break }
            "BepInEx_x86*" { $platform2Asset["X86"] = $asset.browser_download_url; break }
        }
    }

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
    
    $bepInExPath = Join-Path $lethalCompanyPath "BepInEx"

    Write-Host "Lethal Company path: $lethalCompanyPath"
    Write-Host ""

    # Delete old files
    if (Test-Path $bepInExPath) {
        Write-Host "Deleting old files"
        Remove-Item $bepInExPath -Recurse -Force
        Write-Host "Deleted old files"
        Write-Host ""
    }

    Write-Host "Installing BepInEx"
    Expand-Stream $stream $lethalCompanyPath
    Write-Host "Installed BepInEx"
    Write-Host ""

    # Download and install lcapi
    Write-Host "Downloading and installing LC_API"
    $lcapiVersion = Get-Arg "-lcapi" "1.2.1"
    $lcapiUrl = "https://thunderstore.io/package/download/2018/LC_API/$lcapiVersion/"
    $lcapiStream = Request-Stream $lcapiUrl
    Expand-Stream $lcapiStream $lethalCompanyPath
    Write-Host "Installed LC_API $lcapiVersion"
    Write-Host ""

    # Download and install biggerlobby
    Write-Host "Downloading and installing BiggerLobby"
    $biggerLobbyVersion = Get-Arg "-biggerlobby" "2.2.1"
    $biggerLobbyUrl = "https://thunderstore.io/package/download/bizzlemip/BiggerLobby/$biggerLobbyVersion/"
    $biggerLobbyStream = Request-Stream $biggerLobbyUrl
    Expand-Stream $biggerLobbyStream $lethalCompanyPath
    Write-Host "Installed BiggerLobby $biggerLobbyVersion"
    Write-Host ""

    # Download and install moon of the day
    Write-Host "Downloading and installing Moon Of The Day"
    $motdVersion = Get-Arg "-motd" "1.0.3"
    $motdUrl = "https://thunderstore.io/package/download/MaxWasUnavailable/MoonOfTheDay/$motdVersion/"
    $motdStream = Request-Stream $motdUrl
    Expand-Stream $motdStream $lethalCompanyPath
    Write-Host "Installed Moon Of The Day $motdVersion"
    Write-Host ""

    # Download and install FlaslightToggle
    Write-Host "Downloading and installing FlashlightToggle"
    $flashlightToggleVersion = Get-Arg "-flashlightToggle" "1.1.0"
    $flashlightToggleUrl = "https://thunderstore.io/package/download/Renegades/FlashlightToggle/$flashlightToggleVersion/"
    $flashlightToggleStream = Request-Stream $flashlightToggleUrl
    Expand-Stream $flashlightToggleStream $lethalCompanyPath
    Write-Host "Installed FlashlightToggle $flashlightToggleVersion"
    Write-Host ""

    # Download and install WalkieUse
    Write-Host "Downloading and installing WalkieUse"
    $walkieUseVersion = Get-Arg "-walkieUse" "1.1.0"
    $walkieUseToggleUrl = "https://thunderstore.io/package/download/Renegades/WalkieUse/$walkieUseVersion/"
    $walkieUseStream = Request-Stream $walkieUseUrl
    Expand-Stream $walkieUseStream $lethalCompanyPath
    Write-Host "Installed WalkieUse $walkieUseVersion"
    Write-Host ""

    # Download and install LethalCreature
    Write-Host "Downloading and installing LethalCreature"
    $lethalCreatureVersion = Get-Arg "-lethalCreature" "1.0.0"
    $lethalCreatureUrl = "https://thunderstore.io/package/download/DarnHyena/LethalCreature/$lethalCreatureVersion/"
    $lethalCreatureStream = Request-Stream $lethalCreatureUrl
    Expand-Stream $lethalCreatureStream $lethalCompanyPath
    Write-Host "Installed LethalCreature $lethalCreatureVersion"
    Write-Host ""
}

try {
    Install
} catch {
    Write-Host "Install failed: $_"
}

Read-Host "Press ENTER to exit..."
