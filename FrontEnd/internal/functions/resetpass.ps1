function resetpass {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,

        [Alias("u")]
        [Parameter(Mandatory = $false)]
        [string]$User = (Get-ADUser -Identity "$($env:username)admin").UserPrincipalName,

        [Alias("c")]
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,

        [Alias("d")]
        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"
    } 
    process {
        Reset-PIMPassword -sessionToken $Session -User $User -ComputerName $ComputerName -Detailed:$Detailed;
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}