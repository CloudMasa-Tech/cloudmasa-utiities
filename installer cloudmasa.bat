@echo off
setlocal

REM Set the CLOUDMASA TECHNOLOGIES directory path
set "cloudmasa_dir=%USERPROFILE%\CLOUDMASA TECHNOLOGIES"
if not exist "%cloudmasa_dir%" (
    echo Creating CLOUDMASA TECHNOLOGIES directory...
    mkdir "%cloudmasa_dir%"
)

REM Function to download files using PowerShell
set download_cmd=powershell -Command "param($url, $destination); (New-Object System.Net.WebClient).DownloadFile($url, $destination)"

REM 1. Check and Install Python from the Web
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Downloading and installing Python...
    %download_cmd% -url 'https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe' -destination "%cloudmasa_dir%\python-installer.exe"
    start /wait "" "%cloudmasa_dir%\python-installer.exe" /quiet InstallAllUsers=1 PrependPath=1
    python -m pip install --upgrade pip
    python -m pip install requests
) else (
    echo Python is already installed. Skipping installation.
)

REM 2. Check and Install Visual Studio Code from the Web
if not exist "%ProgramFiles%\Microsoft VS Code\Code.exe" (
    echo Visual Studio Code not found. Downloading and installing Visual Studio Code...
    %download_cmd% -url 'https://aka.ms/win32-x64-user-stable' -destination "%cloudmasa_dir%\VSCodeSetup.exe"
    start /wait "" "%cloudmasa_dir%\VSCodeSetup.exe" /silent /mergetasks=!runcode
) else (
    echo Visual Studio Code is already installed. Skipping installation.
)

REM 3. Check and Install AWS CLI from the Web
if not exist "%ProgramFiles%\Amazon\AWSCLIV2\aws.exe" (
    echo AWS CLI not found. Downloading and installing AWS CLI...
    %download_cmd% -url 'https://awscli.amazonaws.com/AWSCLIV2.msi' -destination "%cloudmasa_dir%\AWSCLIV2.msi"
    msiexec /i "%cloudmasa_dir%\AWSCLIV2.msi" /quiet /norestart
) else (
    echo AWS CLI is already installed. Skipping installation.
)

REM 4. Check and Install Terraform from the Web
if not exist "%cloudmasa_dir%\terraform.exe" (
    echo Terraform not found. Downloading and extracting Terraform...
    %download_cmd% -url 'https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_windows_amd64.zip' -destination "%cloudmasa_dir%\terraform.zip"
    powershell -Command "Expand-Archive -Path '%cloudmasa_dir%\terraform.zip' -DestinationPath '%cloudmasa_dir%' -Force"
) else (
    echo Terraform is already installed. Skipping installation.
)

echo.
echo All tools have been downloaded, installed, or were already present.
pause
