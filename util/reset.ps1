$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$dockerFilesPath = ((get-childitem env:ProgramFiles).Value + '\docker')

if(test-path $dockerFilesPath) {
    Remove-Item $dockerFilesPath -Force -Recurse
}

$VBoxProcesses = get-process VBox*

foreach ($VBoxProcess in $VBoxProcesses) {
   Stop-Process $VBoxProcess
}

$kitematicPath = '~/Kitematic/'
$dockerPath = '~/.docker'
$virtualBoxPath = '~/.VirtualBox/'

if(test-path $kitematicPath) {
    Remove-Item $kitematicPath -Force -Recurse
}

if(test-path $dockerPath) {
    Remove-Item $dockerPath -Force -Recurse
}

if(test-path $virtualBoxPath) {
    Remove-Item $virtualBoxPath -Force -Recurse
}

$virtualBoxApp = Get-WmiObject -Class Win32_Product | Where {$_.Name -Match 'Oracle VM VirtualBox*'}

if($virtualBoxApp -ne $null) {
    $virtualBoxApp.Uninstall()
}