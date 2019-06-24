# PowerPIM
PowerPIM is framework or toolkit purely written in PowerShell (up to this point) that allows for simple interaction with the BeyondTrust PowerBroker Password Safe product via simple API calls. To make it easy to use, PowerPIM was designed with the idea to emulate the feel of red team tools like Metasploit, PowerShell Empire, SilentTrinity, etc. 

## Important Information & Disclaimers
We are not responsible for what you do with this software. This version is what we consider to be a stable baseline in which others can build off of and tailor to their environments and workflows. This release contains the minimum and neccessary functionality to get you up and running. PowerPIM has been designed in a way that would allow anyone or any orginizational team to adopt PowerPIM and add additional customized features or functionality using this baseline release. **Please keep in mind that you may need to tweak or adjust some lines in the various scripts that come with PowerPIM as our setup is most likely different from yours.** You may choose to place your copy of PowerPIM in an Azure Dev Ops instance to make and keep track of changes, add additional features, versioning, etc. You may choose to deploy PowerPIM to endpoints in a different way than what we have done. You may have even setup account mapping differently in the BeyondTrust Insight console compared to our naming schema mapping

## Things You May Want To Change Before Use
1. Change hardcoded values in frontend_setup.psm1 (see comments)
2. Change hardcoded values in backup_setup.psm1 (see comments)
3. Several functions and modules in the front and back end scripts grab the default username of the user currently logged into the Windows machine running PowerPIM. The string 'admin' is appended on to this (usernameadmin). Your orgnization may use a different naming schema compared to ours.

## Some of the things you can do with PowerPIM
* Retrieve the password for a specified domain or local account.
* Reset the password for a specified domain or local account.
* Launch RDP sessions on multiple remote hosts with a single command.
* Build an .rdg configuration file so [Remote Desktop Connection Manager](https://www.microsoft.com/en-us/download/details.aspx?id=44989)
* Launch programs or applications like dsa.msc, mmc.exe or powershell.exe (option to add your favorite programs or applications to the configuration file) as a specified user with one simple command.

## Additional Documentation & READMEs
* [Front End Documentation](FrontEnd/readme/README.md)
* [Back End Documentation](BackEnd/readme/README.md)

