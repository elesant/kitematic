$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$BasePath = $dir + '\..\'
$packageJsonContent = ((get-content ($BasePath + 'package.json')) | Out-String) | ConvertFrom-Json

$DOCKER_MACHINE_CLI_VERSION = $packageJsonContent.psobject.properties['docker-machine-version'].value
$DOCKER_MACHINE_CLI_FILE = 'docker-machine-' + $DOCKER_MACHINE_CLI_VERSION + '.exe'
$DOCKER_CLI_VERSION = $packageJsonContent.psobject.properties['docker-version'].value
$DOCKER_CLI_FILE = 'docker-' + $DOCKER_CLI_VERSION + '.exe'

if (-Not (Get-Command choco -errorAction SilentlyContinue))
{
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

$chocoPath = (get-command choco).Path | out-string
$chocoDir = Split-Path $chocoPath
$curlPath = $chocoDir + '\curl.exe'

if(-Not (test-path $curlPath)) {
    & cinst curl
}

if(-Not (test-path ('..\resources\' + $DOCKER_CLI_FILE))) {
    echo "-----> Downloading Docker CLI..."
    & $curlPath -L -k -o ..\resources\$DOCKER_CLI_FILE https://master.dockerproject.com/windows/amd64/docker.exe
}

if(-Not (test-path ('..\resources\' + $DOCKER_MACHINE_CLI_FILE))) {
    echo "-----> Downloading Docker Machine CLI..."
    & $curlPath -L -k -o ..\resources\$DOCKER_MACHINE_CLI_FILE https://github.com/docker/machine/releases/download/v0.1.0/docker-machine_windows-amd64.exe
}




