function Set-PIMRDCManConfig {
    <#
        .SYNOPSIS
        
            This PowerShell module will create a Remote Desktop Connection Manager (.rdg) configuration file that will autopopulate the file with
            group names, host names and a password you provide. All RDP sessions initiated with through the .rdg file created with this module 
            will be proxied through the PIM appliance to utilize BeyondTrust's monitoring capabilities in the appliance if you choose to use it.
            This means you will also be queried by your MFA mechanism for every RDP session you initiate.

        .PARAMETER User
    
            The standard active directory username to use. Does not need to be in UPN format.

        .PARAMETER ImportList

            The CSV file the import and read group names and host names from. The two headings in the CSV file should be Group and Host. Make sure 
            that each host name is put in order based on respective group name. Otherwise, the hosts won't be organized into the correct group
            when the .rdg file is created.

        .PARAMETER Domain

            The domain to use. By default, this script will automatically grab the domain name associated with the computer that is running this script.

        .PARAMETER OutputFilePath

            The absolute filepath including the name and extension (.rdg) of the file to save the configuration data to. 
            The default is the RDG file named username-rdcman.rdg, which is stored on the desktop.

        .PARAMETER Detailed

            A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.
        
        .EXAMPLE

            Set-PIMRDCManConfig -ImportList C:/path/to/file.csv
    #>

    [cmdletbinding()]
    param (
        [Alias("u")]
        [Parameter(Mandatory = $false)]
        [string]$User = $env:USERNAME,
        
        [Alias("i")]
        [Parameter(Mandatory = $true)]
        [string]$ImportList,
        
        [Alias("t")]
        [Parameter(Mandatory = $false)]
        [string]$Domain = $env:USERDNSDOMAIN,
        
        [Alias("o")]
        [Parameter(Mandatory = $false)]
        [string]$OutputFilePath = "C:\Users\$env:USERNAME\Desktop\$env:USERNAME-rdcman.rdg",
        
        [Alias("d")]
        [Parameter(Mandatory = $false)]
        [switch]$Detailed
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"

        Add-Type -AssemblyName System.Security; #For protecteddata class and crypto objects
        Add-Type -AssemblyName System.Core; #For core crypto objects
        $RDCEncryptedPassword

        #User input validation
        if ([string]::IsNullOrEmpty($User) -or $User -eq " ") {
            $User = $env:USERNAME;
        }

        #User input validation
        if ([string]::IsNullOrEmpty($RDCEncryptedPassword) -or $RDCEncryptedPassword -eq " ") {
            $password = Read-Host "Enter Password"; #cannot do as securestring since this will not put the password in the correct format for the rdg file
            $RDCEncryptedPassword = ([System.Convert]::ToBase64String([System.Security.Cryptography.ProtectedData]::Protect([System.Text.Encoding]::GetEncoding("UTF-16LE").GetBytes($password), $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)));
        }

        #User input validation
        if ([string]::IsNullOrEmpty($Domain) -or $Domain -eq " ") {
            $Domain = $env:USERDNSDOMAIN
        }

        #User input validation
        if ([string]::IsNullOrEmpty($OutputFilePath) -or $OutputFilePath -eq " ") {
            $OutputFilePath = "C:\Users\$env:USERNAME\Desktop\($env:USERNAME)-rdcman.rdg";
        }
    }

    process {
        #RDG file preamble
        $Config = "<?xml version=`"1.0`" encoding=`"utf-8`"?>
        <RDCMan programVersion=`"2.7`" schemaVersion=`"3`">
            <file>
                <credentialsProfiles />
                <properties>
                    <expanded>True</expanded>
                    <name>$($env:USERNAME)-rdcman</name>
                </properties>
                <logonCredentials inherit=`"None`">
                    <profileName scope=`"Local`">Custom</profileName>
                    <userName></userName>
                    <password>$($RDCEncryptedPassword)</password>
                    <domain>$($Domain)</domain>
                </logonCredentials>
                <remoteDesktop inherit=`"None`">
                    <sameSizeAsClientArea>False</sameSizeAsClientArea>
                    <fullScreen>True</fullScreen>
                    <colorDepth>24</colorDepth>
                </remoteDesktop>
                <displaySettings inherit=`"None`">
                    <liveThumbnailUpdates>True</liveThumbnailUpdates>
                    <allowThumbnailSessionInteraction>False</allowThumbnailSessionInteraction>
                    <showDisconnectedThumbnails>False</showDisconnectedThumbnails>
                    <thumbnailScale>1</thumbnailScale>
                    <smartSizeDockedWindows>True</smartSizeDockedWindows>
                    <smartSizeUndockedWindows>True</smartSizeUndockedWindows>
                </displaySettings>";
            
        if ([System.IO.File]::Exists($ImportList)) {
            foreach ($entry in Import-Csv -Path $ImportList) {

                #group preamble
                if ($Config -notlike "*<name>$($entry.Group)</name>*") {
                    $Config += "
                    <group>
                        <properties>
                            <expanded>True</expanded>
                            <name>$($entry.Group)</name>
                        </properties>";
                }
                        
                #host body
                $Config += ("
                <server>
                    <properties>
                        <displayName>$($entry.Host)</displayName>
                        <name>$($script:Appliance):4489</name>
                    </properties>
                    <logonCredentials inherit=`"None`">
                        <profileName scope=`"Local`">Custom</profileName>
                        <userName>{0}\{1}+{0}\{1}admin+{2}</userName>
                        <password>$($RDCEncryptedPassword)</password>
                        <domain>$($Domain)</domain>
                    </logonCredentials>
                    <connectionSettings inherit=`"None`">
                        <connectToConsole>False</connectToConsole>
                        <startProgram />
                        <workingDir />
                        <port>4489</port>
                        <loadBalanceInfo />
                    </connectionSettings>
                </server>" -f $Domain, $User, $entry.Host);
            }

                #group epilogue
                $Config += '
                </group>';

                $Config += "
                </file>
                <connected />
                <favorites />
                <recentlyUsed />
            </RDCMan>";
        }
        else {
            if ($Detailed) { Write-Host "[E]: The CSV file you want to import does not exist!" -f Red; }
            return $null;
        }
            
        #Write contents to file
        $Config | Out-File -FilePath $OutputFilePath -Encoding utf8;

        if ($Detailed) { Write-Host "[$]: Done!" -f Green; }
        if ($Detailed) { Write-Host "[I]: File written to $OutputFilePath..." -f Yellow; }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}