function Get-PIMConfig {
    [CmdletBinding()]
    param (
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        return (Get-Content -Path $script:ConfigPath) | ConvertFrom-Json
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}