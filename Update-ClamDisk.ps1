#####################################################################
#                                                                   #
#  Make a ClamWin Disk - Update Clamwin Drive from Windows Install  #
#                                                                   #
#       Author : Blackfell                                          #
#      Twitter : @Blackf3ll                                         #
#        email : info@blackfell.net                                 #
#          Web : https://blackfell.net                              #
#         Repo : https://github.com/Blackfell/ClamWinScripts        #
#                                                                   #
#####################################################################

param (
    [Parameter(Mandatory=$true)][string]$TargetDrive = $( Read-Host "Input target drive LETTER only please:" ),
    [string]$ConfigFilePath = "C:\Program Files\clamwin",
    [string]$DatabaseDir = "C:\Documents and Settings\All Users\.clamwin\db"
)

#Get drive letter

$TargetDrive = gwmi win32_volume -f 'label=''CLAM*'''

#Offer user input to agree or override drive selection
$msg = "The drive path (including trailing ':\') is: " + $TargetDrive + " Is this correct? [y/n]"

do {
    $response = Read-Host -Prompt $msg
    if ($response -like 'y') {
        $TargetDrive = Read-Host "Input target drive, including trailig ':\' please:"
    }

} until ($response -like 'n')

#Move databases - TODO ensure replace happends
cp -Path ($DatabaseDir + main.cvd) -Destination ($TargetDrive + clamwin\db)
cp -Path ($DatabaseDir + daily.cvd) -Destination ($TargetDrive + clamwin\db)

#Tell the user we're done!
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
