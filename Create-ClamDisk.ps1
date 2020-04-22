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
param (
    [Parameter(Mandatory=$true)][string]$TargetDrive = $( Read-Host "Input target drive LETTER only please:" ),
    [string]$ConfigFilePath = "C:\Program Files\clamwin",
    [string]$DatabaseDir = "C:\Documents and Settings\All Users\.clamwin\db"
)

#Try and get drive path correct by ourselves

IF ($TargetDrive.contains(":\"){}
Else{
    $TargetDrive = $TargetDrive + ":\"
    }

#Now sanity check and offer user input to override

$msg = "The drive path (including trailing ':\' is: " + $TargetDrive + " Is this correct? [y/n]"
do {
    $response = Read-Host -Prompt $msg
    if ($response -like 'y') {
        $TargetDrive = Read-Host "Input target drive, including trailig ':\' please:"
    }
} until ($response -like 'n')

#Copy the main bulk of files to the USB
cp -Recurse -Path c:\program files\clamwin\* -Destination $TargetDrive
#TODO except unins000.exe abnd unins000.dat - doesn't seem to create any issues

#Copy all binary files to the bin directory
$BinFiles = @("Microsoft.VC80.CRT.manifest", "msvcm80.dll", "msvcm80.dll", "msvcr80.dll")
$BinSource
$BinDest = $TargetDrive + clamwin\bin
$BinFiles | foreach {cp -Path (b$bin_source + $_) -Destination $bin_dest}
 
#Copy the config file - TODO - get the config file from the site
cp -Path (ConfigFilePath + "ClamWin.conf") -Destination $bin_dest

#Make directories
$ClamDirs = @("clamwin\log", "clamwin\db", "clamwin\quarantine")
$ClamDirs | Foreach {mkdir ($TargetDrive) + $_}

#Move databases
cp -Path ($DatabaseDir + main.cvd) -Destination ($TargetDrive + clamwin\db)
cp -Path ($DatabaseDir + daily.cvd) -Destination ($TargetDrive + clamwin\db)

#Tell user we're done
Write-Output "Drive complete - Why not try it?"
Write-Output ""
Write-Output "EnJoY yOuR cLaM"
Write-Output "
        .-'; ! ;'-.
      .'!  : | :  !`.
     /\  ! : ! : !  /\
    /\ |  ! :|: !  | /\
   (  \ \ ; :!: ; / /  )
  ( `. \ | !:|:! | / .' )
  (`. \ \ \!:|:!/ / / .')
   \ `.`.\ |!|! |/,'.' /
    `._`.\\\!!!// .'_.'
       `.`.\\|//.'.'
        |`._`n'_.'| 
        '----^----'
"
