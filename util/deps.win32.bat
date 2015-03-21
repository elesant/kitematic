@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
cinst curl
curl -L -o docker-machine.exe https://github.com/docker/machine/releases/download/v0.1.0/docker-machine_windows-amd64.exe