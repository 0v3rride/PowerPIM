function checkin {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Alias("rid", "r")]
        [Parameter(Mandatory = $false)]
        [string]$RequestId = $null,

        [Alias("a")]
        [Parameter(Mandatory = $false)]
        [switch]$All
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        if ($All -and !$RequestId) {
            CheckIn-PIMRequest -sessionToken $Session -All:$true -Detailed:$Detailed;
        }
        elseif ($RequestId -and !$All) {
            CheckIn-PIMRequest -sessionToken $Session -Rid $RequestId -Detailed:$Detailed;
        }
        else {
            Write-Host "[E]: The option you provided is not a valid one. Please type 'all' or a request # (e.g. 1234)" -f red;
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}