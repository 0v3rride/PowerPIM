function Show-PIMRequestID {
    <#
    .SYNOPSIS
    
        This module displays all requests associated with the currently logged in PIM API user.

    .PARAMETER sessionToken
    
        The value returned from the Invoke-SignIn module.
        
    .PARAMETER sessionToken
    
        The session token or 'session state' value returned from the Invoke-PIMSignIn module.

    .DESCRIPTION

        Use the Get-Help cmdlet to see examples.

    .EXAMPLE
            
        Show-PIMRequestID

        This will return a collection or request ID objects which contain the following properties below.

        Properties of a request object:
        -----------------------------
        RequestID: int, 
        SystemID: int, 
        SystemName: string, 
        AccountID: int, 
        AccountName: string, 
        DomainName: string, 
        AliasID: int, 
        ApplicationID: int, 
        RequestReleaseDate: date-formatted string, 
        ApprovedDate: date-formatted string, 
        ExpiresDate: date-formatted string, 
        Status: string, 
        AccessType: string 
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$sessionToken
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    }

    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2
    
        try {
            return Invoke-RestMethod -Uri ("{0}/Requests?all" -f $script:RestApiUrl) -Method GET -WebSession $sessionToken;
        }
        catch {
            Write-Host $_;
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}