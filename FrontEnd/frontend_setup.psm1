# The api key below is hard coded into the project because authentication to the API component of the appliance requires a user password for authentication as well as answerinng MFA prompt
$script:APIKey = '' #FIXME:
$script:PowerPIMDataDirectoryPath = "$env:APPDATA\PowerPIM" #FIXME:
$script:ConfigPath = "$PowerPIMDataDirectoryPath\Config.json" #FIXME:

#Region Beginning of module template

$ProjectRoot = (Get-Item -Path $PSScriptRoot).FullName

# import functions
$functionFolders = @('functions', 'internal\functions')
ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath) {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        ForEach ($function in $functions) {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }    
}

$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\functions" -Filter '*.ps1').BaseName

Export-ModuleMember -Function $publicFunctions

#EndRegion End of module template 

if (-not (Test-Path -Path $script:ConfigPath)) {
    Write-Host "Creating base config file at [$script:ConfigPath]."
    New-Item -Path $script:PowerPIMDataDirectoryPath -ItemType Directory

    @{
        adssp  = "C:\Windows\System32\dssite.msc"
        aduc   = "C:\Windows\System32\dsa.msc"
        ca     = "C:\Windows\System32\certsrv.msc"
        cmd    = "C:\Windows\System32\cmd.exe"
        dfs    = "C:\Windows\System32\dfsmgmt.msc"
        dhcp   = "C:\Windows\System32\dhcpmgmt.msc"
        dns    = "C:\Windows\System32\dnsmgmt.msc"
        gpm    = "C:\Windows\System32\gpmc.msc"
        mmc    = "C:\Windows\System32\mmc.exe"
        ps     = "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe"
        scs    = "C:\Windows\System32\services.msc"
        srvmg  = "C:\Windows\System32\ServerManager.exe"
        vscode = "C:\Program Files\Microsoft VS Code\Code.exe"
        vs     = "C:\Program Files (x86)\Microsoft Visual Studio\2017\*\Common7\IDE\devenv.exe"
    } | ConvertTo-Json -Depth 15 | Out-File $script:ConfigPath
}

#Loading config
$script:Config = Get-PIMConfig

#Sets a new key if it doesn't exist and reloads the config 
Set-PIMConfig -Key 'ssms' -Value "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe" -SkipMessage
Set-PIMConfig -Key 'sc' -Value "C:\Program Files (x86)\Red Gate\*\RedGate.SQLCompare.UI.exe" -SkipMessage
Set-PIMConfig -Key 'dc' -Value "C:\Program Files (x86)\Red Gate\*\RedGate.SQLDataCompare.UI.exe" -SkipMessage
