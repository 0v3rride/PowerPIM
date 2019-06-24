function Invoke-PIMRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken,
        [Parameter(Mandatory = $false)]
        [switch]$Detailed,
        [Parameter(Mandatory = $true)]
        [string]$User,
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,
        [Parameter(Mandatory = $true)]
        [string]$Type
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting";
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2
    
        if ($Detailed) { Write-Host "[I]: Creating a request for user [$User], machine [$ComputerName]..." -f Yellow }

        $manAcct = Invoke-RestMethod -Uri "$script:RestApiUrl/ManagedAccounts?systemName=$ComputerName&accountName=$User" -Method GET -WebSession $sessionToken;

        $RequestsBody = @{
            SystemId        = $manAcct.SystemId
            AccountId       = $manAcct.AccountId
            DurationMinutes = 60 * 12 # hours
            ConflictOption  = "renew"
            AccessType = $Type 
        }
        $rID = Invoke-RestMethod -Uri "$script:RestApiUrl/Requests" -Method POST -WebSession $sessionToken -Body (ConvertTo-Json $RequestsBody) -ContentType "application/json";
        return $rID
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}