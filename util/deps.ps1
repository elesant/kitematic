# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
}
else {
    # We are not running "as Administrator" - so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
}


$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$BasePath = $dir + '\..\'
$packageJson = get-content ($BasePath + 'package.json')
[System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$serializer = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$packageJsonContent = $serializer.DeserializeObject($packageJson)

$DOCKER_MACHINE_CLI_VERSION = $packageJsonContent['docker-machine-version']
$DOCKER_MACHINE_CLI_FILE = 'docker-machine-' + $DOCKER_MACHINE_CLI_VERSION + '.exe'
$DOCKER_CLI_VERSION = $packageJsonContent['docker-version']
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

if(-Not (test-path ($BasePath + '\resources\' + $DOCKER_CLI_FILE))) {
    echo "-----> Downloading Docker CLI..."
    & $curlPath -L -k -o $BasePath\resources\$DOCKER_CLI_FILE https://master.dockerproject.com/windows/amd64/docker.exe
}

if(-Not (test-path ($BasePath + '\resources\' + $DOCKER_MACHINE_CLI_FILE))) {
    echo "-----> Downloading Docker Machine CLI..."
    & $curlPath -L -k -o $BasePath\resources\$DOCKER_MACHINE_CLI_FILE https://github.com/docker/machine/releases/download/v0.1.0/docker-machine_windows-amd64.exe
}