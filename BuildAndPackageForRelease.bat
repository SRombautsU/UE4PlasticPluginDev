@echo off
setlocal

set ROOT_PATH=%~dp0

pushd %ROOT_PATH%


REM TODO: read the plugin version from uplugin file and prompt the user to check, and name zip files from the version
set VERSION=1.4.11

REM TODO: let's also automate creating a tag on the current branch, so better to check we are on main too!
echo on
git branch
@echo off
set /p OK="Presse ENTER to package version %VERSION% of the plugin from the current branch (should be 'master'). Press CTRL-C to cancel."

REM Let's ensure that the plugin is correctly built
call Build.bat

set ARCHIVE_NAME_REL=UE4PlasticPlugin-%VERSION%.zip
set ARCHIVE_NAME_DBG=UE4PlasticPlugin-%VERSION%-with-debug-symbols.zip

echo on
del %ARCHIVE_NAME_REL%
del %ARCHIVE_NAME_DBG%

Tools\7-Zip\x64\7za.exe a -tzip %ARCHIVE_NAME_REL% Plugins -xr!".git*" -xr!Intermediate -xr!_config.yml -xr!Screenshots -xr!"*.pdb"
Tools\7-Zip\x64\7za.exe a -tzip %ARCHIVE_NAME_DBG% Plugins -xr!".git*" -xr!Intermediate -xr!_config.yml -xr!Screenshots
@echo off
