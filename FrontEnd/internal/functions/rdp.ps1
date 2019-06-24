function rdp {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,
        [Parameter(Mandatory = $false)]
        [switch]$Detailed,
        [Alias("u")]
        [Parameter(Mandatory = $false)]
        [string]$User = "$($env:username)admin",
        [Alias("h")]
        [Parameter(Mandatory = $false)]
        [string[]]$HostList = $null
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    
        $User = (Get-ADUser -Identity $User.Split("@")[0]).UserPrincipalName

        if (-not $HostList) {
            $HostList = (Read-Host "Absolute path to file containing hostnames (one per line) or a comma delimited list (host1, host2, host3)").Split(',') | ForEach-Object { $_.Trim() }
        }
    } 
    process {
        Invoke-Rdp -sessionToken $Session -User $User -HostList $HostList -Detailed:$Detailed;
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}