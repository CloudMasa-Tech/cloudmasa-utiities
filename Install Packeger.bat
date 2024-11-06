@echo off
setlocal

:: Ask user for OS
echo Please select your operating system:
echo 1. Windows
echo 2. Linux
echo 3. MacOS
set /p os_choice="Enter the number for your OS (1/2/3): "

:: Set Downloads path
set "download_path=C:\Downloads\CloudMasa Package"
if not exist "%download_path%" mkdir "%download_path%"

:: Variables for tracking installations
set "git_installed=Not Installed"
set "terraform_installed=Not Installed"
set "python_installed=Not Installed"
set "precommit_installed=Not Installed"
set "awscli_installed=Not Installed"
set "vscode_installed=Not Installed"
set "all_installed=true"
set "apps_already_installed=true"

:: Windows Installation
if "%os_choice%"=="1" (
    echo Checking for already installed apps on Windows...

    :: Check if Git is installed
    git --version >nul 2>&1
    if %errorlevel%==0 (
        for /f "tokens=3" %%a in ('git --version') do set "git_installed=Git %%a (Already installed)"
    ) else (
        set "apps_already_installed=false"
    )

    :: Check if Terraform is installed
    terraform --version >nul 2>&1
    if %errorlevel%==0 (
        for /f "tokens=2" %%a in ('terraform --version') do set "terraform_installed=Terraform %%a (Already installed)"
    ) else (
        set "apps_already_installed=false"
    )

    :: Check if Python is installed
    python --version >nul 2>&1
    if %errorlevel%==0 (
        for /f "tokens=2" %%a in ('python --version') do set "python_installed=Python %%a (Already installed)"
    ) else (
        set "apps_already_installed=false"
    )

    :: Check if Pre-commit is installed
    pre-commit --version >nul 2>&1
    if %errorlevel%==0 (
        for /f "tokens=2" %%a in ('pre-commit --version') do set "precommit_installed=Pre-commit %%a (Already installed)"
    ) else (
        set "apps_already_installed=false"
    )

    :: Check if AWS CLI is installed
    aws --version >nul 2>&1
    if %errorlevel%==0 (
        for /f "tokens=1-2" %%a in ('aws --version') do set "awscli_installed=AWS CLI %%b (Already installed)"
    ) else (
        set "apps_already_installed=false"
    )

    :: Check if Visual Studio Code is installed
    where code >nul 2>&1
    if %errorlevel%==0 (
        for /f "tokens=1-2" %%a in ('code --version') do set "vscode_installed=VS Code %%a (Already installed)"
    ) else (
        set "apps_already_installed=false"
    )

    :: Display Installed Apps table
    echo.
    echo =====================================================
    echo                    Installed Apps
    echo =====================================================
    echo App Name                  Version
    echo -----------------------------------------------------
    echo Git                       %git_installed%
    echo Terraform                 %terraform_installed%
    echo Python                    %python_installed%
    echo Pre-commit                %precommit_installed%
    echo AWS CLI                   %awscli_installed%
    echo VS Code                   %vscode_installed%
    echo =====================================================

    :: Check if all apps are already installed
    if "%apps_already_installed%"=="true" (
        echo.
        echo All apps are already installed with their respective versions!
    ) else (
        echo.
        echo Some apps are not installed or need to be installed.
    )

    echo =====================================================
    echo              Welcome to CloudMasa Tech Team!
    echo =====================================================
    pause
)

:: Linux and MacOS sections follow the same structure for each app
