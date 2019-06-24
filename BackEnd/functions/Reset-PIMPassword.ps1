function Reset-PIMPassword {
    <#
    .SYNOPSIS

        This module will reset the password for the specified local or domain account.
    
    .PARAMETER sessionToken
        
        The session token or 'session state' value returned from the Invoke-PIMSignIn module.
        
    .PARAMETER Detailed

        A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.

    .PARAMETER User
        
        The user you want to get the password for. By default it is the current user's admin account that is logged into Windows. To get the password for an Active Directory joined account, use the
        following User Principal Name schema (aduser@domain). Local accounts do not require the UPN schema.

    .PARAMETER ComputerName

        PIM requires that you give a host that the logged in API user has access to (jsmith, wsus_maint-1, etc.). You can view this in the BeyondTrust Password Safe web console under the
        the systems tab (local accounts) and domain linked accounts (domain accounts).

    .PARAMETER UpdateSystem

        Set to true if you want to reset the password on the specfied machine itself. This is good for any service accounts, accounts that are like or are treated like
        service accounts, etc.

    .DESCRIPTION

        Use the Get-Help cmdlet to see examples.

    .EXAMPLE
            
        Reset-PIMPassword -sessionToken <value returned from Invoke-SignIn>
        Reset-PIMPassword -sessionToken <value returned from Invoke-SignIn> -ComputerName jsmith -User administrator
        Reset-PIMPassword -sessionToken <value returned from Invoke-SignIn> -User adadmin@domain -ComputerName host3
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Parameter(Mandatory = $false)]
        [string]$User = ((Get-ADUser -Identity "$($env:username)admin").UserPrincipalName),

        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,
        
        [ValidateSet("true", "false")]
        [Parameter(Mandatory = $false)]
        [string]$UpdateSystem = "false"
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"
 
        #User input validation
        if ([string]::IsNullOrEmpty($User) -or $User -eq " ") {
            $User = (Get-ADUser -Identity "$($env:username)admin").UserPrincipalName;
        }

        #User input validation
        if ([string]::IsNullOrEmpty($ComputerName) -or $ComputerName -eq " ") {
            $ComputerName = $env:COMPUTERNAME
        }
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2
    
        try {
            if ($Detailed) { Write-Host ("[I]: Resetting credentials for [{0}] on [{1}]..." -f $User, $ComputerName) -f Yellow; }

            $manAcct = Invoke-RestMethod -Uri ("{0}/ManagedAccounts?systemName=$ComputerName&accountName=$User" -f $script:RestApiUrl) -Method GET -WebSession $sessionToken;

            $Body = @{
                Password     = ""
                UpdateSystem = $UpdateSystem
            } | ConvertTo-Json
            $response = Invoke-RestMethod -Method PUT -Uri ("{0}/ManagedAccounts/$($manAcct.AccountId)/Credentials" -f $script:RestApiUrl) -ContentType "application/json" -WebSession $sessionToken -Body $Body

            if ($Detailed) { Write-Host "[$]: Reset complete!" -f Green; }
        }
        catch {
            Write-Error "[E]: Reset failed! :: $_";
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}