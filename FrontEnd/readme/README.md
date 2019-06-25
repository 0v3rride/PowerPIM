# PowerPIM

## Information

PowerPIM was designed to be an easy to use toolkit or framework and has been written purely in PowerShell .NET up to this point. The baseline release will allow you do to anything you can through the web console via the PowerShell prompt. This includes:

* Obtaining the password to a specified user and copying it to the clipboard.
* Starting RDP sessions on hosts specified by a list using a specific user
* Force the change of a password for a specific user.
* Show and check-in the requests that are active and associated with the current user that is logged into the API.
* Run a specified program or application as a specific user.

## Installation

1. Ensure you have Powershell 5.1 installed.
   * Download here: <https://www.microsoft.com/en-us/download/details.aspx?id=54616>
2. Open a Powershell prompt.
3. (Optional) Set the ExecutionPolicy to RemoteSigned

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Force
    ```

4. Place PowerPIM in your Orginization's PowerShell repository in your environment & Register It.

    ```powershell
    . "\\path\to\powershell\script\to\register\repository.ps1"
    ```
    
    #### or

5. Issue the following PowerShell commands

    ```powershell
    Import-Module .\path\to\frontend_setup.psm1
    Import-Module .\path\to\backend_setup.psm1
    Invoke-PowerPIM -Detailed
    ```
    
It's really up to you on how you want to package and deploy PowerPIM in your environment.

## Invoking PowerPIM

To utilize the front-end component of PowerPIM, you need to use the following syntax in a PowerShell prompt ```Invoke-PowerPIM```. This will start PowerPIM in it's most basic form.

| Flag                 | Description                                     |
|----------------------|-------------------------------------------------|
| -LoginHelp            | Displays the help box on how to authenticate.   |
| -Pchall               | This will automatically answer the MFA prompt after 30 seconds have expired. Options are: phone, push, 6 digit code from MFA app on your phone or hardware token and yubikey if you have one setup.
| -Detailed             | Show detailed messaging throughout the session. |

## Detailed Messaging

When running PowerPIM with the -Detailed flag, PowerPIM will display the details of tasks, actions, information, errors, etc. This can be used to help troubleshoot issues to a certain extent. However, it is mostly intended for helpful verbose output.

### Messaging Legend

```powershell
[E]: and/or red - error, something went wrong and the message should tell you what happened

[I]: and/or yellow - general action/task information

[$]: and/or green - action/task success

[@]: and/or cyan - signifies that this prompt requires input or a subsequent prompt will be displayed to the user that requires input
```

## A Quick Lesson About Manipulating Different Account Types With PowerPIM

**Disclaimer:** This README assumes that you have a good or at least basic understanding about how an Active Directory environment works. It is your own responsibility to know the difference between a local account and a domain account in an environment that utilizes Active Directory.

At this point you would have started the PowerPIM front-end and authenticated with the API portion of the appliance. The following is an example on how to grab the password for an active directory or local user account with the getpass module.

### Domain User Accounts

```powershell
getpass -p -u aduser@domain -c hostname
```

### Local User Accounts

```powershell
getpass -u administrator -c hostname
```

## JSON Configuration File

The JSON configuration file is stored in **C:\Users\\<username\>\AppData\Roaming\PowerPIM\\Config.json** and is used to store general configuration data pertaining to the overall functionality of the PowerPIM framework/toolkit. This data includes short name-to-full path mappings for the run module, etc. The framework should automatically check for the existence of this file and will create it if it does not exist. However, there may be the one-off chance that you need to fix this file or manipulate it in some manner, so knowing of its existence is important.
