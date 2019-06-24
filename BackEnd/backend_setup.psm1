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

############################################################################
#                                                                          #
#                          Configuration data                              #
#                                                                          #
############################################################################

$script:Appliance = "pim.domain.tld" #FIXME: change fqdn of appliance
$script:RestApiUrl = "https://pim.domain.tld/beyondtrust/api/public/v3" #FIXME: Change the fqdn portion of this url that points to the API portion of your appliance
