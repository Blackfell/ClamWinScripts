#####################################################################
#                                                                   #
#  Make a ClamWin Disk - Create Clamwin Drive from Windows Install  #
#                                                                   #
#       Author : Blackfell                                          #
#      Twitter : @Blackf3ll                                         #
#        email : info@blackfell.net                                 #
#          Web : https://blackfell.net                              #
#         Repo : https://github.com/Blackfell/ClamWinScripts        #
#                                                                   #
#####################################################################

#Setup parameters for target dive and Clamwin Files
#[string]$ConfigPath = "${Env:ProgramFiles(x86)}\clamwin", TODO - put this in clamwin prog dir

param (
    [string]$DriveLetter = $(
                              IF(get-volume | where drivetype -eq "removable")
                              {
                                (get-volume | where drivetype -eq "removable" | select -expandproperty DriveLetter)[0]
                              }
                              ELSE
                              {
                                Read-Host "No drive detected, enter drive letter"
                              }
                            ),
    [string]$ConfigPath = ".\",
    [string]$DatabaseDir = "C:\Documents and Settings\All Users\.clamwin\db",
    [switch]$Force
)

#Format drive letter
IF ($DriveLetter.contains(":\")){}
Else{
    $DriveLetter = $DriveLetter + ":\"
    }

IF($Force){
    #User cannot interact with script - no confirmation of drive letter - Dangerous
    echo "Forcing drive selection - Careful!"
}
ELSE{
    #Sanity check and offer user input to override

    $msg = "Your media is at: " + $DriveLetter + " Is this correct? [y/n]"
    do {
        $response = Read-Host -Prompt $msg
        if ($response -like 'n') {
            $DriveLetter = Read-Host "Input target drive letter"
        }
    } until ($response -like 'y')

    #Now make sure user understands the consequences of proceeding
    $msg = "This will now wipe all data on disk " + $DriveLetter + " Continue? [y/n]"
    do {
        $response = Read-Host -Prompt $msg
        if ($response -like 'n') {
            exit
        }
    } until ($response -like 'y')
}

#Format the Drive
Format-Volume -DriveLetter $DriveLetter[0] -Filesystem exFAT -NewFileSystemLabel "CLAMWIN" | Out-Null


#Make directories
$ClamDirs = @("clamwin", "clamwin\log", "clamwin\db", "clamwin\quarantine")
$ClamDirs | Foreach {mkdir -Force ($DriveLetter + $_) | Out-Null}

#Copy the main bulk of files to the USB
cp -Recurse -Force -Path "${Env:ProgramFiles(x86)}\clamwin\*" -Destination $($DriveLetter + "clamwin\")

#Copy all binary files to the bin directory
$BinFiles = @("Microsoft.VC80.CRT.manifest", "msvcm80.dll", "msvcm80.dll", "msvcr80.dll")
$BinSource = "${Env:ProgramFiles(x86)}\clamwin\bin\Microsoft.VC80.CRT\\"
$BinDest = $DriveLetter + "clamwin\bin"
$BinFiles | foreach {cp -Path ($BinSource + $_) -Destination $bin_dest}

#Copy the config file
cp -Path ($ConfigPath + "ClamWin.conf") -Destination $BinDest


#Move databases
cp -Path ($DatabaseDir + "\*") -Destination ($DriveLetter + "clamwin\db")

#Clean up and shortcuts
@($($DriveLetter+ "clamwin\unins000.exe"), $($DriveLetter + "clamwin\unins000.dat")) | ForEach {rm $_}
$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut($DriveLetter + "clamwin\ClamWin.lnk")
$ShortCut.TargetPath="$BinDest\ClamWin.exe"
#$ShortCut.IconLocation = "yourexecutable.exe, 0";
#$ShortCut.Description = "Your Custom Shortcut Description";
$ShortCut.Save()

#Tell user we're done
Write-Output "Drive complete - Why not try it?"
Write-Output ""
Write-Output "EnJoY yOuR cLaM"
Write-Output "
        .-'; ! ;'-.
      .'!  : | :  !'.
     /\  ! : ! : !  /\
    /\ |  ! :|: !  | /\
   (  \ \ ; :!: ; / /  )
  ( '. \ | !:|:! | / .' )
  ('. \ \ \!:|:!/ / / .')
   \ '.'.\ |!|! |/,'.' /
    '._'.\\\!!!// .'_.'
       '.'.\\|//.'.'
        |'._\n'_.'|
        '----^----'
"
