function help {
    [CmdletBinding()]
    param (
        [Alias("m")]
        [Parameter(Mandatory = $false)]
        [string]$Module
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    } 
    process {

        switch($Module.ToLower())
        {
            {$_ -like "rdp"}
            {
                Write-Host @"
    [--------------------------------------------------------------------------------]
    | [+]: rdp - initiate RDP sessions on specified hosts with specified             |
    |      Active Directory account.                                                 |
    |                                                                                |
    |      Arguments:                                                                |
    |      [-]: {-user | -u} - username                                              |
    |      [-]: {-hostlist | -h} - text file or comma delmited list of hosts         |
    |                                                                                |
    |      Examples:                                                                 |
    |      [-]: rdp -h host1,host2,host3                                             |
    |      [-]: rdp -u useradmin@domain -h C:\users\username\Desktop\hosts.txt   |
    [________________________________________________________________________________]

"@
            }
            {$_ -like "run"}
            {
                Write-Host @"
    [--------------------------------------------------------------------------------]
    | [+]: run <shortName> - run a program or application as a specified             |
    |      user.                                                                     | 
    |                                                                                |
    |      Arguments:                                                                |
    |      [-]: {-user | -u} - username                                              |
    |      [-]: {-domain | -t} - domain                                              | 
    |      [-]: {-computername | -c} - host or computer name to get password         |
    |           from                                                                 |
    |      [-]: {-appname | -a} - short name of applicaton to start; check           |
    |           your config file in appdata local                                    |
    |                                                                                |
    |      Examples:                                                                 |
    |      [-]: run cmd -computername hostname                                       |
    |      [-]: run -a <shortName>                                                   |
    [________________________________________________________________________________]

"@
            }
            {$_ -like "showrids"}
            {
                Write-Host @"
    [------------------------------------------------------------------]
    | [+]: showrids - display request IDs/numbers associated with      |
    |      current API user                                            |
    |                                                                  |
    |      Examples:                                                   |
    |      [-]: showrids                                               |
    [__________________________________________________________________]

"@
            }
            {$_ -like "exit"}
            {
                Write-Host @"
    [------------------------------------------------------------------]
    | [+]: exit - sign out of the PIM applicance and exit PowerPIM     |
    |             with the option to checkin all requests.             |
    |                                                                  |
    |      Examples:                                                   |
    |      [-]: exit - don't checkin any requests                      |
    |      [-]: exit -all - checkin all requests                       |
    [__________________________________________________________________]

"@
            }
            {$_ -like "checkin"}
            {
                Write-Host @"
    [-------------------------------------------------------------------------]
    | [+]: checkin - recursively or systematically check-in requests that     |
    |      are active.                                                        |   
    |                                                                         |
    |      Arguments:                                                         |
    |      [-]: {all} - all active requests                                   |
    |      [-]: {-RequestID | -rid | -r} - text file or comma delmited list   |
    |           of hosts                                                      |
    |                                                                         |
    |      Examples:                                                          |
    |      [-]: checkin -all                                                  |
    |      [-]: checkin -r 1234                                               |
    |      [-]: checkin 1234                                                  |
    [_________________________________________________________________________]

"@
            }
            {$_ -like "getpass"}
            {
                Write-Host @"
    [-------------------------------------------------------------------------]   
    | [+]: getpass - copy password clipboard and/or print password to screen. |   
    |      [!] WARNING: This will print the plaintext password for the        |  
    |           specified account to the console!!!                           |  
    |                                                                         |
    |      Arguments:                                                         |
    |      [-]: {-user | -u} - username                                       |
    |      [-]: {-computername | -c} - host or computer name to get password  |
    |           from                                                          |
    |      [-]: {-print | -p} - print password to screen & copy to clipboard  |
    |                                                                         |
    |      Examples:                                                          |
    |      [-]: getpass                                                       |
    |      [-]: getpass -u administrator -c hostname                          |
    |      [-]: getpass useradmin -c hostname                                 |
    [_________________________________________________________________________]

"@
            }
            {$_ -like "resetpass"}
            {
                Write-Host @"
    [---------------------------------------------------------------------------]
    | [+]: resetpass - reset the credentials for the specified Active           |
    |      Directory account.                                                   |
    |                                                                           |
    |      Arguments:                                                           |
    |      [-]: {-user | -u} - username                                         |
    |      [-]: {-computername | -c} - host or computer name to get password    |
    |           from                                                            | 
    |                                                                           |
    |      Examples:                                                            |
    |      [-]: resetpass                                                       |
    |      [-]: resetpass -u administrator -c hostname                          |
    |      [-]: resetpass useradmin -c hostname                                 |
    [___________________________________________________________________________]

"@
            }
            { $_ -like "getconfig" }
            {
                Write-Host @"
    [---------------------------------------------------------------------------]
    | [+]: getconfig - show contents of JSON configuration file                 |
    |                                                                           |
    |      Examples:                                                            |
    |      [-]: getconfig                                                       |
    [___________________________________________________________________________]

"@
            }
            { $_ -like "setconfig" }
            {
                Write-Host @"
    [--------------------------------------------------------------------------------------------]
    | [+]: setconfig - set a new value or data in the JSON config file.                          |
    |                                                                                            |
    |      Arguments:                                                                            |
    |      [-]: {-key | -k} - the short name to map the value to                                 | 
    |      [-]: {-value | -v} - the value to map to the key                                      |
    |      [-]: {-overwrite | -o} - overwrite an existing key-value pair when using this flag    |
    |      [-]: {-skipmessage} - don't print message when setting a key-value pair               |
    |                                                                                            |
    |      Examples:                                                                             |
    |      [-]: setconfig (follow prompts)                                                       |
    |      [-]: setconfig -k custmmc -v C:\path\to\programorapplication                          |
    |      [-]: setconfig -k custmmc -v C:\path\to\new\programorapplication -o                   |                                                           
    [____________________________________________________________________________________________]

"@
            }
            { $_ -like "setrdcman" }
            {
                Write-Host @"
    [---------------------------------------------------------------------------------------------------]
    | [+]: setrdcman - create and rdg configuration file based of a CSV file.                           |
    |                  All RDP connections will be proxied through the PIM appliance.                   |
    |                                                                                                   |
    |      Arguments:                                                                                   |
    |      [-]: {-user | -u} - the user name to use (not in UPN format)                                 |
    |      [-]: {-importlist | -i} - the value to map to the key                                        |
    |      [-]: {-Domain | -d} - domain name to user (make sure it is fully qualified)                  |
    |      [-]: {-outputfilepath | -o } - absolute path and file name to store configuration in         |
    |                                                                                                   |
    |      Examples:                                                                                    |
    |      [-]: setrdcman -i C:\users\username\Desktop\my.csv  (follow prompt on screen)                |
    |      [-]: setrdcman -u username -i C:\users\username\Desktop\my.csv  (follow prompt on screen)    |
    |      [-]: setrdcman -i C:\path\to\import.csv -o C:\path\to\save\my.rdg (follow prompt on screen)  |
    |                                                                                                   |
    |      CSV File Format Example:                                                                     |
    |      +------------------+                                                                         | 
    |      |Group  |Host      |                                                                         |
    |      +-------+----------+                                                                         |
    |      |smtp   |smtpsrv1  |                                                                         |
    |      +-------+----------+                                                                         |
    |      |smtp   |smtpsrv2  |                                                                         |
    |      +-------+----------+                                                                         |
    |      |smtp   |smtpsrv3  |                                                                         |
    |      +-------+----------+                                                                         |
    |      |maint  |wsus3     |                                                                         |
    |      +-------+----------+                                                                         |
    |      |maint  |jmpbx1    |                                                                         |
    |      +-------+----------+                                                                         |
    [___________________________________________________________________________________________________]

"@
            }
            default
            {
                Write-Host @" 
    [-------------------------------------------------------------------------]
    |IMPORTANT INFORMATION PLEASE READ:                                       |
    | [!I!]: Anything that involves an Active Directory account REQUIRES      |
    |        the full UPN (ADaccount@domain). This obviously DOES NOT     |  
    |        pertain to local accounts.                                       |  
    [-------------------------------------------------------------------------]   
    |                               COMMANDS                                  |
    [-------------------------------------------------------------------------]
    | [+]: exit - check in all active sessions, logout and exit PowerPIM.     |
    | [+]: clear - clear the terminal/prompt.                                 |
    | [+]: setconfig - add or remove a short name in the config.txt file.     |
    [-------------------------------------------------------------------------]   
    |                               MODULES                                   |
    [-------------------------------------------------------------------------]
    | [+]: rdp - initiate RDP sessions on specified hosts with specified      |
    |      Active Directory account.                                          |
    |                                                                         |
    | [+]: run - run a program or application as a specified                  |
    |      user.                                                              |
    |                                                                         |
    | [+]: showrids - display request IDs/numbers associated current API      |
    |      user.                                                              |
    |                                                                         |
    | [+]: checkin - recursively or systematically check-in requests that     |
    |      are active.                                                        |
    |                                                                         |
    | [+]: getpass - copy password clipboard and/or print password            |
    |      to screen.                                                         |                      
    |                                                                         |
    | [+]: resetpass - reset the credentials for the specified Active         |
    |      Directory account.                                                 |
    |                                                                         |
    | [+]: setconfig - set a new value or data in the JSON config file.       |
    |                                                                         |
    | [+]: getconfig - show contents of JSON configuration file.              |
    |                                                                         |
    | [+]: setrdcman - creates an rdg configuration file.                     |
    |                                                                         |
    | [I]: For help and examples pertaining to certain modules use help       |
    |      <name of module>                                                   |
    |                                                                         |
    |       Example:                                                          |
    |       [-]: help rdp                                                     |
    [_________________________________________________________________________]

"@
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}