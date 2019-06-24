function Invoke-PIMSignIn {
    <#
        .SYNOPSIS
        
            This module signs into PIM as the specified user via the API. If you do not give a user to runas then the current user logged into this machine will be used.

        .PARAMETER Key
    
            The API key value created in BeyondTrust Insight console.
        
        .PARAMETER RunAs

            The API user value created in BeyondTrust Insight console (used for shared or service accounts) or an Active Directory account in User Principal Name format (aduser@domain). 
            Use in conjunction with APIKey. By default, the value will be the UserPrincipalName (UPN) of the user that is currently logged in and running this script 
            (see examples with Get-Help). 
            
            API keys also have the ability of being password protected during creation, so enable that feature. Users will have to give their password 
            that they use to sign into the web console with along with answering the MFA prompt before they can use any modules to interact with the API.

        .PARAMETER Detailed

            A switch argument that shows verbose information regarding calls to the API. Recommended, but not required.

        .PARAMETER ChallengeAnswer

            The challenge response value that will automatically answer the challenge for you. You will still need to wait for 30 seconds, but the Pchall flag will answer
            the MFA prompt for you.
            
            Options:
            - PHONE
            - PUSH
            - Code from DUO app on your device
            - Yubikey **(Pchall should be the last flag if you are using it as the Yubikey is programmed to press the ENTER key when it's done typing out its key)**
            - Cod from DUO authenticator token device
            - Whatever your org uses

        .DESCRIPTION

            Use the Get-Help cmdlet to see examples

        .EXAMPLE

            Returns a session token value THAT YOU WILL NEED for subsequent calls to the API with other modules or your own scripts. View the README to see a laymen explanation
            on how session tokens work.

            Invoke-SignIn -Key <API Key> -RunAs <adadmin@domain | localpimapiuser> -Detailed -ChallengeAnswer <Yubikey value, DUO code from app or authenticator, PHONE, DUO PUSH>
            Invoke-SignIn -Key <API Key>
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $false)]
        [string]$RunAs = ((Get-ADUser $env:username).UserPrincipalName),

        [Parameter(Mandatory = $false)]
        [switch]$Detailed,

        [Parameter(Mandatory = $false)]
        [string]$ChallengeAnswer,

        [Parameter(Mandatory = $false)]
        [SecureString]$Password
    )   

    begin {
        Write-Verbose "$($MyInvocation.MyCommand): Starting"	
    }
    process {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; #use tls 1.2
        $sessionToken = [System.Security.Cryptography.HashAlgorithm]::Create("SHA512").ComputeHash([System.Text.Encoding]::UTF8.GetBytes(([guid]::NewGuid()))); #create random session token

        try {  
            Write-Host "[!]: WELCOME!";
            Write-Host "[I]: Logging in..." -f Yellow;
            Write-Host "[@]: IF YOU ARE USING YOUR DOMAIN ACCOUNT YOU WILL BE PROMPTED BY DUO PUSH, OTHERWISE BE READY TO ANSWER THE PROMPT WITH YOUR SELECTED METHOD..." -f Cyan;

            #---------------------------------------Needed for shared or service accounts-------------------------------------------
            $Headers = @{ 
                Authorization = "PS-Auth key=$Key; runas=$RunAs;" 
            }

            if (-not [string]::IsNullOrEmpty($Password)) {
                $Headers.Authorization += " pwd=[$([System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($Password)))];"
            }

            $SignInResult = Invoke-RestMethod -Uri ("{0}/Auth/SignAppIn" -f $script:RestApiUrl) -Method POST -Headers $Headers -SessionVariable sessionToken; #no $ in front of sessionToken variable on purpose, see official MS documentation, -SessionVariable is need to make subsequent calls with the -WebSession argument in the same session. However, the web session/session variable is not tied to the request ID given by PIM during check out
            Write-Host "[$]: Login as $($SignInResult.UserName) was successful!" -f Green;
            return $sessionToken;
        }
        catch [System.Net.WebException] {
            #---------------------------------------Needed for mapped accounts (domain user-to-domain admin)-------------------------------------------
            #401 with WWW-Authenticate-2FA header expected for two-factor authentication challenge
            if ($_.Exception.Response.StatusCode -eq 401 -and $_.Exception.Response.Headers.Contains("WWW-Authenticate-2FA") -eq $true) {   
                $challengeMessage = $_.Exception.Response.Headers["WWW-Authenticate-2FA"];
                
                if (![string]::IsNullOrEmpty($ChallengeAnswer)) {
                    $challengeResponse = $ChallengeAnswer;
                }
                else {
                    $challengeResponse = Read-Host $challengeMessage;
                }
                
                $Headers = @{ 
                    Authorization = "PS-Auth key=$Key; runas=$RunAs; challenge=$challengeResponse;" 
                }

                if (-not [string]::IsNullOrEmpty($Password)) {
                    $Headers.Authorization += " pwd=[$([System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($Password)))];"
                }
                $SignInResult = Invoke-RestMethod -Uri ("{0}/Auth/SignAppIn" -f $script:RestApiUrl) -Method POST -Headers $Headers -WebSession $sessionToken;
                Write-Host "[$]: Login as $($SignInResult.UserName) was successful!" -f Green;
                return $sessionToken;
            }
            else {
                throw;
            }
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand): Ending"
    }
}