@echo off
setlocal

set ROOT_PATH=%~dp0

pushd %ROOT_PATH%

type Plugins\UE4PlasticPlugin\PlasticSourceControl.uplugin
echo .

REM TODO: read the plugin version from uplugin file and prompt the user to check, and name zip files from the version
if [%1] == [] (
  set /p VERSION="Enter the version name exactly as in the UE4PlasticPlugin.uplugin above (eg. 1.4.11): "
) else (
  set VERSION=%1
)
REM TODO: double check with the uplugin and also search in the README

REM TODO: let's also check we are on main
echo on
git branch
@echo off

REM TODO: ask the user if he agree we are going to do a git clean & a git reset!
set /p GIT_CLEAN_RESET="Git clean & reset before building (ENTER/N)? "
if [%GIT_CLEAN_RESET%] == [] (
  echo on
  git clean -fdx
  git reset --hard
  pushd Plugins\UE4PlasticPlugin
  git clean -fdx
  git reset --hard
  popd
  @echo off
)

REM create a tag on the current branch
set /p GIT_TAG="Git tag version %VERSION% of the plugin on the current branch (ENTER/N)? "
if [%GIT_TAG%] == [] (
  echo on
  pushd Plugins\UE4PlasticPlugin
  git tag %VERSION%
  popd
  @echo off
)

REM Let's ensure that the plugin is correctly built
set /p BUILD="Build %VERSION% of the plugin (ENTER/N)? "
if [%BUILD%] == [] (
  call Build.bat
  REM TODO ensure the build has succeeded
)
REM check for the binaries
if NOT exist Plugins\UE4PlasticPlugin\Binaries\Win64\UE4Editor-PlasticSourceControl.dll (
  echo Something is wrong, some binaries are missing.
  exit /b 1
)

set ARCHIVE_NAME_REL=UE4PlasticPlugin-%VERSION%.zip
set ARCHIVE_NAME_DBG=UE4PlasticPlugin-%VERSION%-with-debug-symbols.zip

echo on
del %ARCHIVE_NAME_REL%
del %ARCHIVE_NAME_DBG%

Tools\7-Zip\x64\7za.exe a -tzip %ARCHIVE_NAME_REL% Plugins -xr!".git*" -xr!Intermediate -xr!_config.yml -xr!Screenshots -xr!"*.pdb"
Tools\7-Zip\x64\7za.exe a -tzip %ARCHIVE_NAME_DBG% Plugins -xr!".git*" -xr!Intermediate -xr!_config.yml -xr!Screenshots
@echo off

echo .
echo NOTE: After validation, push the new tag using:
echo   git push https://github.com/PlasticSCM/UE4PlasticPlugin.git %VERSION%