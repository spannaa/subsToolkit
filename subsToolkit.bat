@echo off
setlocal enabledelayedexpansion
COLOR 1E
if (%1)==(0) goto SkipMe
echo ------------------------------------------------------------------------------------ >> log.txt
echo ^|%date% -- %time%^| >> log.txt
echo ------------------------------------------------------------------------------------ >> log.txt
subsToolkit 0 2>> log.txt

:SkipMe
mode con:cols=100 lines=72
set currentApp=None
set apktool=apktool_2.3.3.jar
set heapy=512
set projectFolder=None
java -version 
if errorlevel 1 goto JavaError
REM Check if there is only one project folder - if there is, set it as 'projectFolder'
set /A projectcount=0
for /D %%D in (*) do if /I not "%%~nxD"=="tools" (
set /A projectcount+=1
set project=%%~nD%%~xD
)
if %projectcount%==1 set projectFolder=%project%
REM Check if there is only one apk in the projectFolder\files_in folder - if there is, set it as 'currentApp'
set /A filecount=0
for %%F in (%projectFolder%/files_in/*.apk) do (
set /A filecount+=1
set file=%%~nF%%~xF
)
if %filecount%==1 set currentApp=%file%

:ReStart
cd "%~dp0"
set menunr=GARBAGE
cls
echo.
echo   SUBS TOOLKIT
echo.   
echo   Spannaa @ XDA
echo.
echo  --------------------------------------------------------------------------------------------------
echo   Current apktool version:   %apktool%
echo.
echo   Current Max Memory Size:   %heapy%mb
echo  --------------------------------------------------------------------------------------------------
echo   Current Project:           %projectFolder% 
echo.
echo   Current App:               %currentApp%
echo  --------------------------------------------------------------------------------------------------
echo.
REM Check if there are any existing project folders and redirect to CreateProjectFolder if not
set /A count=0
for /D %%D in (*) do if /I not "%%~nxD"=="tools" (
set /A count+=1
)
if %count%==0 (
echo   There are no existing project folders...
goto CreateProjectFolder
)
REM Main menu
echo   MENU
echo.
echo    1.  Select a project folder to work in
echo.
echo    2.  Create a new project folder to work in
echo.
echo    3.  Select an apk to work on
echo.
echo    4.  Decompile a user apk
echo.
echo    5.  Decompile a system apk
echo.
echo    6.  Batch decompile all apks in a project folder
echo.
echo    7.  Select version of apktool to work with
echo.
echo    8.  Set Max Memory Size (Default: 512mb)
echo.
echo    9.  Setup, notes ^& credits
echo.
echo   10.  Quit
echo.
echo  --------------------------------------------------------------------------------------------------
echo.
set /P menunr=- Please select your option: 
if %menunr%==1 goto ProjectFolderSelect
if %menunr%==2 goto CreateProjectFolder
if %menunr%==3 goto ApkSelect
if %menunr%==4 goto DecompileUserApk
if %menunr%==5 goto DecompileSystemApk
if %menunr%==6 goto DecompileAll
if %menunr%==7 goto ApktoolSelect
if %menunr%==8 goto MaxMemorySize
if %menunr%==9 goto Help
if %menunr%==10 goto Quit

REM If an out of range number is entered, redirect to OutOfRangeError
if %menunr%==0 goto OutOfRangeError
if %menunr% GTR 10 goto OutOfRangeError

:ProjectFolderSelect
set projectFolder=None
set currentApp=None
echo.
REM Check if there are any existing project folders and redirect to CreateProjectFolder if not
set /A projectcount=0
for /D %%D in (*) do if /I not "%%~nxD"=="tools" (
set /A projectcount+=1
)
if %projectcount%==0 (
echo   There are no existing project folders...
goto CreateProjectFolder
)
echo   Select a project folder to work in...
echo.
set /A projectcount=0
for /D %%D in (*) do if /I not "%%~nxD"=="tools" (
set /A projectcount+=1
set a!projectcount!=%%D
if /I !projectcount! LEQ 9 echo    !projectcount!.  %%D
if /I !projectcount! GTR 9 echo   !projectcount!.  %%D
)
echo.
set /P INPUT=- Enter its number: %=%
if /I %INPUT% GTR !projectcount! goto ProjectSelectError
if /I %INPUT% LSS 1 goto ProjectSelectError
set projectFolder=!a%INPUT%!
REM Count the number of apps in projectFolder and, if there is only one, set it as currentApp
set /A filecount=0
for %%F in (!a%INPUT%!/files_in/*.apk) do (
set /A filecount+=1
set a!filecount!=%%F
set file=%%~nF%%~xF
)
if %filecount%==1 set currentApp=%file%
goto ReStart

:CreateProjectFolder
echo.
echo   Create a new project folder to work in...
echo.
set /P INPUT=- Enter the folders name : %=%
set projectFolder= %INPUT: =_%
REM Create projectFolder and sub folders
if not exist "%INPUT%" mkdir "%INPUT: =_%", "%INPUT: =_%\frameworks", "%INPUT: =_%\files_in", "%INPUT: =_%\working"
echo.
echo   Project folder: %projectFolder% has been created
echo.
echo - Press any key to continue...
pause > nul
goto SkipMe

:ApkSelect
echo.
REM Check if a project folder has been selected and Restart if not
if %projectFolder% ==None (
echo   You need to select a project folder to work in first^^!
goto Pause
)
cls
echo.
echo   Select an apk to work on...
echo.
REM use counter to check if there are any apps and redirect to error if not
set /A count=0
for %%F in (%projectFolder%/files_in/*.apk) do (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 echo    !count!.  %%F 
if /I !count! GTR 9 echo   !count!.  %%F 
)
if %count%==0 goto NoAppsError
echo.
set /P INPUT=- Enter its number: %=%
if /I %INPUT% GTR !count! goto ApkSelectError
if /I %INPUT% LSS 1 goto ApkSelectError
set currentApp=!a%INPUT%!
goto ReStart

:DecompileUserApk
cd tools
REM Check if a project folder has been selected and Restart if not
if %projectFolder%==None (
echo.
echo   You need to select a project folder to work in first^^!
goto Pause
)
REM Check if a apk has been selected and Restart if not
if %currentApp%==None (
echo.
echo   You need to select an apk to work on first^^!
goto Pause
)
if exist "%~dp0%projectFolder%\working\%currentApp%" rmdir /S /Q "%~dp0%projectFolder%\working\%currentApp%"
echo.
echo   Decompiling %currentApp%...
java -Xmx%heapy%m -jar %apktool% d "..\%projectFolder%\files_in\%currentApp%" -b -o "..\%projectFolder%\working\%currentApp%" > nul
if errorlevel 1 goto Level1Error
)
echo.
echo   The decompiled %currentApp% 
echo   can be found in your %projectFolder%\working folder
goto Pause

:DecompileSystemApk
cd tools
REM Check if a project folder has been selected and Restart if not
if %projectFolder%==None (
echo.
echo   You need to select a project folder to work in first^^!
goto Pause
)
REM Check if a apk has been selected and Restart if not
if %currentApp%==None (
echo.
echo   You need to select an apk to work on first^^!
goto Pause
)
echo.
REM Delete any installed frameworks and install new one(s)
rmdir /S /Q %userprofile%\AppData\Local\apktool > nul
rmdir /S /Q %userprofile%\apktool > nul
REM set /A count=0
for %%F in (../%projectFolder%/frameworks/*.apk) do (
echo   Installing framework: %%F...
java -jar %apktool% if ..\%projectFolder%\frameworks\%%F > nul
if errorlevel 1 goto Level1Error
)
echo.
if exist "%~dp0%projectFolder%\working\%currentApp%" rmdir /S /Q "%~dp0%projectFolder%\working\%currentApp%"
echo   Decompiling %currentApp%...
java -Xmx%heapy%m -jar %apktool% d "..\%projectFolder%\files_in\%currentApp%" -b -o "..\%projectFolder%\working\%currentApp%" > nul
if errorlevel 1 goto Level1Error
)
echo.
echo   The decompiled %currentApp% 
echo   can be found in your %projectFolder%\working folder
goto Pause

:DecompileAll
cd tools
REM Check if a project folder has been selected and Restart if not
if %projectFolder% ==None (
echo.
echo   You need to select a project folder to work in first^^!
goto Pause
)
echo.
REM Delete any installed frameworks and install new one(s)
rmdir /S /Q %userprofile%\AppData\Local\apktool > nul
rmdir /S /Q %userprofile%\apktool > nul
REM set /A count=0
for %%F in (../%projectFolder%/frameworks/*.apk) do (
echo   Installing framework: %%F...
java -jar %apktool% if ..\%projectFolder%\frameworks\%%F > nul
if errorlevel 1 goto Level1Error
)
echo.
REM use counter to check if there are any apps to decompile and redirect to error if not
set /A count=0
for %%F in (../%projectFolder%/files_in/*.apk) do (
set /A count+=1
if exist "%~dp0%projectFolder%\working\%%F" rmdir /S /Q "%~dp0%projectFolder%\working\%%F"
echo   Decompiling %%F...
java -Xmx%heapy%m -jar %apktool% d "..\%projectFolder%\files_in\%%F" -b -o "..\%projectFolder%\working\%%F" > nul
if errorlevel 1 (echo   There was an error decompiling %%D - please check your log.txt
echo.
echo - Press any key to continue...
pause > nul
)
)
if %count%==0 goto NoAppsError
echo.
echo   All decompiled apks can be found in your 
echo   %projectFolder%\working folder
goto Pause

:ApktoolSelect
cls
echo.
echo   Select an apktool to work with...
echo.
set /A count=0
for %%F in (tools/apktool_*.jar) do (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 echo    !count!.  %%F 
if /I !count! GTR 9 echo   !count!.  %%F 
)
echo.
set /P INPUT=- Enter its number: %=%
if /I %INPUT% GTR !count! goto ApktoolSelectError
if /I %INPUT% LSS 1 goto ApktoolSelectError
set apktool=!a%INPUT%!
goto ReStart

:MaxMemorySize
set /P INPUT=- Enter max size for java heap space in megabytes (eg 512) : %=%
set heapy=%INPUT%
cls
goto ReStart

:Help
cls
echo.
echo  SUBS TOOLKIT
echo  --------------------------------------------------------------------------------------------------
echo.
echo  SETUP
echo.
echo  1. Java MUST be installed for this tool to work.
echo.
echo  2. Create a project folder to work in - this could be named after the rom you're working
echo     with, theme ready gapps or just a generic folder name if you're only working with user apps.
echo.
echo  3. Copy ALL of the framework apks from the rom you're working with into the 'frameworks'
echo     folder of the project folder.
echo.
echo  4. Copy the apks you want to theme from the rom you're working with into the 'files_in' 
echo     folder of the project folder.
echo.
echo  5. Use the menu to select tasks and execute them.
echo.
echo  NOTES
echo.
echo  When decompiling or batch decompiling apks, any previously installed frameworks 
echo  are deleted and the frameworks for the project you're working in are installed automatically.
echo  This enables different roms to be worked on without their frameworks getting mixed up.
echo.
echo  Any number of self-contained project folders can be created and worked with and each 
echo  project folder can contain any number of apks.
echo.
echo  New releases of apktool can be found at: https://ibotpeaches.github.io/Apktool/
echo  To update subsToolkit, download the new apktool_x.x.x.jar, add it to the 'tools' folder 
echo  and select it via option #7 in the subsToolkit menu.
echo.
echo  To build and add the latest snapshot version of apktool to subsToolkit (Git MUST be installed) 
echo  run build_apktool_snapshot.bat, wait for the build to complete and then select the newly built
echo  snapshot via option #7 in the subsToolkit menu.
echo.
echo  The default maximum memory (heap) size is '512'mb 
echo  This should not need to be changed unless there is aproblem with decompiling.
echo.
echo  Running cleanup.bat after quitting will delete all installed frameworks and log.txt
echo.
echo  CREDITS
echo.
echo  subsToolkit is based on apkToolkit: Spannaa @ XDA
echo  apkToolkit is based on Apk Manager: Daneshm90 @ XDA
echo  apktool: iBotPeaches @ XDA ^& Brut.all @ XDA
echo  7za standalone command line version of 7-Zip: Igor Pavlov
echo.
echo  --------------------------------------------------------------------------------------------------
goto Pause

REM Error messages
:OutOfRangeError
echo.
echo   You selected a number that wasn't one of the options^^!
goto Pause

:NoAppsError
echo.
echo   There are no apks in the %projectFolder%\files_in folder^^!
goto Pause

:ProjectSelectError
set projectFolder=None
echo.
echo   You selected a number that wasn't one of the options^^!
goto Pause

:ApkSelectError
set currentApp=None
echo.
echo   You selected a number that wasn't one of the options^^!
goto Pause

:ApktoolSelectError
set apktool=apktool_2.2.4.jar
echo.
echo   You selected a number that wasn't one of the options^^!
goto Pause

:JavaError
echo.
echo   Java was not found, you will not be able to sign apks or use apktool
goto Pause

:Level1Error
echo.
echo   An error occurred - please check your log.txt
goto Pause

:Pause
echo.
echo - Press any key to continue...
pause > nul
goto Restart

:Quit
