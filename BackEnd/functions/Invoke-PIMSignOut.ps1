function Invoke-PIMSignOut {
    <#
        .SYNOPSIS
        
            This module signs out the current API user from PIM via the API.

        .PARAMETER sessionToken
            
            The session token or 'session state' value returned from the Invoke-PIMSignIn module.
        
        .PARAMETER Detailed

            A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.

        .DESCRIPTION

            Use the Get-Help cmdlet to see examples

        .EXAMPLE
            
            Invoke-SignOut -sessionToken <return value from Invoke-PIMSignIn> -Detailed
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2

        try {
            if ($Detailed) { Write-Host "[I]: Signing out..." -f Yellow; }
            $signOutResponse = Invoke-RestMethod -Uri ("{0}/Auth/Signout" -f $script:RestApiUrl) -Method POST -WebSession $sessionToken;
            if ($Detailed) { Write-Host "[$]: GOODBYE!`n" -f Green; }
        }
        catch {
            Write-Host $_;
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}