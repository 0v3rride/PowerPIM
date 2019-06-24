
function showrids {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        $requestData = Show-PIMRequestID -sessionToken $Session;
        
        if($requestData)
        {
            $requestData | Format-List;
        }
        else
        {
            Write-Host "[I]: There are no active requests at this time!" -f Yellow;
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}