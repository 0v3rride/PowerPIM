function run {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)] 
        [Microsoft.PowerShell.Commands.WebRequestSession]$Session,

        [Alias("u")]
        [Parameter(Mandatory = $false)]
        [string]$User,

        [Alias("c")]
        [Parameter(Mandatory = $false)]
        [string]$ComputerName = $env:COMPUTERNAME,

        [Alias("a")]
        [Parameter(Mandatory = $false)]
        [string]$AppName,

        [Alias("t")]
        [Parameter(Mandatory = $false)]
        [string]$Domain = $env:USERDOMAIN,

        [Alias("d")]
        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"
    } 
    process {                
        if ($Detailed) { Write-Host "[I]: Working on starting [$AppName] at path [$($Config.$AppName)] as [$Domain\$User]..." -f Yellow; }
        $result = Run-Alternative -sessionToken $Session -User $User -ComputerName $ComputerName -ApplicationPath $Config.$AppName -Domain $Domain -Detailed:$Detailed;

        if($result)
        {
            Write-Host "[E]: $result!" -f Red;
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}