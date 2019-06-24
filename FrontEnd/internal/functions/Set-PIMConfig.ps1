function Set-PIMConfig {
    [CmdletBinding()]
    param (
        [Alias("k")]
        [Parameter(Mandatory = $true)]
        [string]$Key, 
        [Alias("v")]
        [Parameter(Mandatory = $true)]
        [string]$Value,
        [Alias("o")]
        [Parameter(Mandatory = $false)]
        [switch]$Overwrite,
        [Parameter(Mandatory = $false)]
        [switch]$SkipMessage
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        $StartingConfig = $script:Config.psobject.copy()

        if (-not $script:Config.$Key) {
            $script:Config | Add-Member -NotePropertyName $Key -NotePropertyValue $Value
        } 
        elseif (-not $Overwrite) {
            if (-not $SkipMessage) {
                Write-Host "[I]: The config file already contains [$Key] set to [$Value]. To overwrite this include the -o parameter." -ForegroundColor Yellow
            }
        }
        else {            
            $script:Config.$Key = $Value
        }
        
        if (Compare-Object -ReferenceObject ($StartingConfig | ConvertTo-Json -Depth 15) -DifferenceObject ($script:Config | ConvertTo-Json -Depth 15)) {
            #A difference was found.  Updating config.
            $script:Config | ConvertTo-Json -Depth 15 | Out-File $script:ConfigPath
            $script:Config = Get-PIMConfig
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}