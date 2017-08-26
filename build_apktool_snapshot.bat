@echo off
mode con:cols=130 lines=32
git clone git://github.com/iBotPeaches/Apktool.git
cd Apktool
call gradlew.bat build shadowJar
copy "%~dp0\tools\7za.exe" "7za.exe" > nul
7za e "brut.apktool\apktool-cli\build\libs\apktool-cli-all.jar" "apktool.properties" -r > nul
for /f "tokens=*" %%a in ('find /i "application.version="^<apktool.properties') do set %%a
copy "brut.apktool\apktool-cli\build\libs\apktool-cli-all.jar" "%~dp0\tools\apktool_%application.version%.jar" > nul
cd %~dp0
rd /q /s "Apktool"
echo.
echo apktool_%application.version%.jar built sucessfully and is now available to select in subsToolkit.
echo.
pause
exit