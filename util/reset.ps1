get-process VBox* | stop-process

$kitematicPath = '~/Kitematic/'
$dockerPath = '~/.docker'
$virtualBoxPath = '~/.VirtualBox/'
$KitematicBinsPath = '~/.Kitematic-bins/'

if(test-path $kitematicPath) {
    Remove-Item $kitematicPath -Force -Recurse
}

if(test-path $dockerPath) {
    Remove-Item $dockerPath -Force -Recurse
}

if(test-path $virtualBoxPath) {
    Remove-Item $virtualBoxPath -Force -Recurse
}

if(test-path $KitematicBinsPath) {
    Remove-Item $KitematicBinsPath -Force -Recurse
}

$virtualBoxApp = Get-WmiObject -Class Win32_Product | Where {$_.Name -Match 'VirtualBox'}

if($virtualBoxApp -ne $null) {
    $virtualBoxApp.Uninstall()
}