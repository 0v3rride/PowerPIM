function Invoke-PowerPIM {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Parameter(Mandatory = $false)]
        [switch]$LoginHelp,

        [Parameter(Mandatory = $false)]
        [string]$Pchall
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"
        
        $Host.UI.RawUI.WindowTitle = "PowerPIM Framework";
    }

    process {
        #This will be used as the session token to pass into the other psms when called
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2

        try {
            if ($Detailed) {
                Write-Host (@"
                    
                ____                          ____  ______  ___
               / __ \____ _      _____  _____/ __ \/  _/  |/  /
              / /_/ / __ \ | /| / / _ \/ ___/ /_/ // // /|_/ / 
             / ____/ /_/ / |/ |/ /  __/ /  / ____// // /  / /  
            /_/    \____/|__/|__/\___/_/  /_/   /___/_/  /_/                              

"@);

                connoisseur
            }

            if ($LoginHelp) {
                Write-Host @"
        [===============================Login Help=================================]
        |  (1): If you want to login using your domain account,                    |
        |       then it needs to be in User Principal Name format.                 |
        |       You are a valid API user if you have an domain admin account,      |
        |       which is being managed by the BeyondTrust appliance based on how   |
        |       mapped accounts work.                                              |
        |                                                                          |
        |     [e.g]: username@domain                                               |    
        |                                                                          |
        |  (2): If you want to login using a service or shared account, then you   |
        |       need to specify the local API user on the BeyondTrust applicance   | 
        |       that manages this account.                                         |   
        |                                                                          |
        |     [e.g.]: The local API user wsusadminapi manages the shared account   |   
        |             wsusadmin, so specify wsusadminapi as the API user to login  | 
        |             as. This will not be in UPN format.                          |  
        |                                                                          |  
        | (3): Simply press the enter key, which will attempt to log you in as the |
        |      current user logged who is running this script. You can easily find |
        |      out who this is by issuing the 'whoami' command in a CMD prompt or  |
        |      PowerShell prompt. If you do not want to login as the currently     |  
        |      authenticated Windows user, then chose either                       |
        |      options 1 or 2 specified above.                                     |  
        |                                                                          |      
        |     [e.g.]:                                                              |      
        |     >_ whoami                                                            |      
        |     domain\username                                                      | 
        |                                                                          | 
        |  [i]: If you login with your standard domain user you                    | 
        |       WILL be prompted to complete multifactor authentication via        | 
        |       a DUO push, DUO code, yubikey or DUO token authenticator, etc.     | 
        |       This may not happen when logging in with a service or shared       | 
        |       account depending on how your environment is setup.                | 
        [__________________________________________________________________________]
        
        
"@;
            }

            $APIUser = Read-Host "The API user to login as (CTRL+C and re-run Invoke-PowerPIM with -LoginHelp flag if you need help) {Press ENTER to default to the user currently logged into Windows}";
            $Password = Read-Host "Password" -AsSecureString

            #User input validation
            if ([string]::IsNullOrEmpty($APIUser) -or $APIUser -eq " " -or $APIUser -eq "`n" -or $APIUser -eq "`r") {
                $APIUser = (Get-ADUser -Identity $env:username).UserPrincipalName; 
            }

            #if (-not $global:session_token) { # uncomment line for testing
            #Sign-in
            $global:session_token = Invoke-PIMSignIn -Key $script:APIKey -RunAs $APIUser -Password $Password -ChallengeAnswer $Pchall -Detailed:$Detailed;
            #}

            #Launch PowerPIM (front-end) console interface
            Invoke-PPIMPrompt;
        }
        catch {
            Write-Host $_;
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}