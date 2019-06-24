function Get-PIMPassword {
    <#
    .SYNOPSIS

        This module will copy the password to your clipboard with additional option to print the plaintext password of the specified domain or local account to the screen.

    .PARAMETER sessionToken
    
        The session token or 'session state' value returned from the Invoke-PIMSignIn module.
        
    .PARAMETER Detailed

        A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.

    .PARAMETER User
        
        The user you want to get the password for. By default it is the current user who is logged in and is mapped to their domain admin account. To get the password for a domain account, use the
        following User Principal Name schema (aduser@domain). Local accounts do not require the UPN schema.

    .PARAMETER ComputerName

        PIM requires that you give a host that the logged in API user has access to (jsmith, wsus_maint-1, etc.). You can view this in the BeyondTrust Password Safe web console under the
        the systems tab (local accounts) and domain linked accounts (domain accounts).

    .DESCRIPTION

        Use the Get-Help cmdlet to see examples.

    .EXAMPLE
            
        Get-PIMPassword -sessionToken <value returned from Invoke-SignIn>
        Get-PIMPassword -comptuername jsmith -user administrator 
        Get-PIMPassword -sessionToken <value returned from Invoke-SignIn> -User adadmin@domain -ComputerName host3
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
        [string]$ComputerName = $env:COMPUTERNAME
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting";
        
        #User input validation
        if ([string]::IsNullOrEmpty($User) -or $User -eq " ") {
            [string]$User = (Get-ADUser -Identity "$($env:username)admin").UserPrincipalName
        }

        #User input validation
        if ([string]::IsNullOrEmpty($ComputerName) -or $ComputerName -eq " ") {
            $ComputerName = $env:COMPUTERNAME
        }	
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2
    
        try {
            if ($Detailed) { Write-Host "[I]: Getting password for [$User] from [$ComputerName]..." -f Yellow }
            
            $rID = (Show-PIMRequestID -sessionToken $sessionToken | Where-Object { $_.AccessType -eq "View" -and $_.AccountName -eq $User.Split('@')[0] }).RequestID;

            if (-not $rID) {
                $rID = Invoke-PIMRequest -sessionToken $sessionToken -Detailed:$Detailed -User $User -ComputerName $ComputerName -Type "View";
            }

            return Invoke-RestMethod -Uri ("{0}/Credentials/{1}" -f $script:RestApiUrl, $rID) -Method GET -WebSession $sessionToken;
        }
        catch {
            Write-Error "
Error message: $_
StackTrace: $($_.ScriptStackTrace)"
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}