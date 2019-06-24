function Exit-PowerPIM {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,

        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Alias("a")]
        [Parameter(Mandatory = $false)]
        [switch]$All,

        [Alias("n")]
        [Parameter(Mandatory = $false)]
        [switch]$None
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {
        if ($All) {
            checkin -Session $Session -All:$true -Detailed:$Detailed;
        } 

        Invoke-PIMSignOut -sessionToken $Session -Detailed:$Detailed;
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}