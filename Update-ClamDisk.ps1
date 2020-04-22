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
    [string]$DriveLetter = $(
                              IF(gwmi win32_volume -f 'label=''CLAMWIN''')
                              {
                                gwmi win32_volume -f 'label=''CLAMWIN''' | select -expandproperty Caption
                              }
                              ELSE
                              {
                                  Read-Host "Drive not detected. Enter drive letter"
                              }
                            ),
    [string]$ConfigPath = "C:\Program Files\clamwin",
    [string]$DatabaseDir = "C:\Documents and Settings\All Users\.clamwin\db",
    [swtich]$Force

)

IF(Force)
{
  #No user input to get drive selection
}
ELSE
{
    #Offer user input to agree or override drive selection

    $msg = "Your media is at: " + $DriveLetter + " Is this correct? [y/n]"
    do {
        $response = Read-Host -Prompt $msg
        if ($response -like 'n') {
            $DriveLetter = Read-Host "Input target drive"
        }

    } until ($response -like 'y')
}

#Move databases
cp -Force -Path ($DatabaseDir + "\*") -Destination ($DriveLetter + "clamwin\db")

#Tell the user we're done!
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
