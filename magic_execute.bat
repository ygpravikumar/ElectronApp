@echo off
set "startTime=%time%"
REM call python to rename all images and remove any output files

set source_directory=%1
set target_directory=%2

set numprocessors=%3
set loopcount=%4

python ./changes_name_mogrify.py

REM call mogrify to minimize/crop the images
FOR /L %%A IN (0,1,14) DO (
  start /B magick mogrify -resize 1280x720 -strip -define jpeg:extent=40kb -path %target_directory%/ %target_directory%/%%A-*.jpg
)
:LOOP
tasklist /FI "IMAGENAME eq magick.exe" 2>NUL | find /I /N "magick.exe">NUL
if %ERRORLEVEL%==0 (
    ping localhost -n 1 >nul
    GOTO LOOP
)
REM call python to reset file names for ffmpeg
python ./changes_name_ffmpeg.py
REM call ffmpeg to create the video
F:\Img_to_Video\ffmpeg\bin\ffmpeg.exe -framerate 25  -start_number 1 -pattern_type sequence -i %target_directory%/%%d.jpg -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p %target_directory%/output.mp4

set "stopTime=%time%"
call :timeDiff diff startTime stopTime
echo %diff% milli seconds
goto :eof

:timeDiff
setlocal
call :timeToMS time1 "%~2"
call :timeToMS time2 "%~3"
set /a diff=time2-time1
(
  ENDLOCAL
  set "%~1=%diff%"
  goto :eof
)

:timeToMS
::### WARNING, enclose the time in " ", because it can contain comma seperators
SETLOCAL EnableDelayedExpansion
FOR /F "tokens=1,2,3,4 delims=:,.^ " %%a IN ("!%~2!") DO (
  set /a "ms=(((30%%a%%100)*60+7%%b)*60+3%%c-42300)*1000+(1%%d0 %% 1000)"
)
(
  ENDLOCAL
  set %~1=%ms%
  goto :eof
)