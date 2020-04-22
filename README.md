# ClamWinScripts

Automates the creation and update of ClamWin removable drives using PowerShell; all that's needed is a Windows machine with a standard ClamWin Install.

# How to use it

Both scripts are currently configured to run from the  working directory, as opposed to importing as a full module. The main reason for this is that the config file bundled with the repo is required for disk creation. First, get the files:

```
PS C:\ > git clone https://github.com/Blackfell/ClamWinScripts
PS C:\ > cd ClamWinScripts
```

## Creation

Plug your target drive into your machine, ensuring that Clamwin is installed in the standard locations (Program Files etc.), then run:

```
PS C:\ClamWinScripts\ > Create-ClamDisk.ps1
```

The script will prompt you to confirm or enter the target drive letter; once a drive is selected, the script will create the required fild structure on the drive and copy the required files to the destination. This will delete all data on the drive.

Alternatively you can specify arguments as desired:

```
PS C:\ClamWinScripts\ > Create-ClamDisk -DriveLetter E -DatabaseDir C:\CustomDBPath\.clamwin\db\ -ConfigFilePath .\
```

You will still be prompted before drives are written to.

## Update

Plug your drive into your machine, ensuring that ClamWin is up to date for best results; run:

```
PS C:\ClamWinScripts\ > Update-ClamDisk.ps1
```

This will attempt to auto-detect the drive, before prompting for confirmation; once the drive has been identified, it will  move the relevant database files to your drive.

You're done!

# How it works

These sripts are very simple PowerShell implementations of the user guide for ClamWin Portable media creation provided in the [ClamWin User Guides](http://www.clamwin.com/content/view/118/89/). The update script is an implementation not provided in this guide, but that provides the ability to programmatically update virus databases in a manner that functions.

These scripts are a work in progress and any feedback, requests etc. are always welcome at info@blackfell.net.
