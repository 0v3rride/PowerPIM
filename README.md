# PowerPIM
PowerPIM is framework or toolkit purely written in PowerShell (up to this point) that allows for simple interaction with the BeyondTrust PowerBroker Password Safe product via simple API calls. To make it easy to use, PowerPIM was designed with the idea to emulate the feel of red team tools like Metasploit, PowerShell Empire, SilentTrinity, etc. 

## Important Information & Disclaimers
You are solely responsible for what you do with this software. This version is consider to be a stable baseline in which others can build off of and tailor to their environments and workflows. This release contains the minimum and neccessary functionality to get you up and running. PowerPIM has been designed in a way that would allow anyone or any organizational team to adopt PowerPIM and add additional customized features or functionality using this baseline release. **Please keep in mind that you may need to tweak or adjust some lines in the various scripts that come with PowerPIM as your setup is most likely different from others.** You may choose to place your copy of PowerPIM in an Azure Dev Ops instance to make and keep track of changes, add additional features, versioning, etc. You may choose to deploy PowerPIM to endpoints in a different way than what others choose to do. You may have even setup account mapping differently in the BeyondTrust Insight console as your organization's username schema is different.

## Things You May Want To Change Before Use
1. Change hardcoded values in `frontend_setup.psm1` (see comments with FIXME label)
2. Change hardcoded values in `backup_setup.psm1` (see comments with FIXME label)
3. Change hardcoded value for `DurationMinutes` HTTP POST variable in the request body in `Invoke-PIMRequest.ps1`
4. Several functions and modules in the front and back end scripts grab the default username of the user currently logged in user on the Windows machine running PowerPIM. The string 'admin' is appended on to the username and then the user principal name value is obtainted to form a string which would result in the following `usernameadmin@domain`. There are exceptions for some modules in PowerPIM that do not require the username to be in UPN format. Your organization may use a different naming schema compared to others.

## Some of the things you can do with PowerPIM
* Retrieve the password for a specified domain or local account.
* Reset the password for a specified domain or local account.
* Launch RDP sessions on multiple remote hosts with a single command.
* Build an .rdg configuration file so [Remote Desktop Connection Manager](https://www.microsoft.com/en-us/download/details.aspx?id=44989)
* Launch programs or applications like dsa.msc, mmc.exe or powershell.exe (option to add your favorite programs or applications to the configuration file) as a specified user with one simple command.

## Additional Documentation & READMEs
* [Front End Documentation](FrontEnd/readme/README.md)
* [Back End Documentation](BackEnd/readme/README.md)

