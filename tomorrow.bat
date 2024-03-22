@echo off

rem tomorrow.bat v0.2
rem 2024-22-01
rem DVD-DAVIDE's utils (https://github.com/DVD-DAVIDE/utils)

rem Get day, month, year from variable.
rem To extract part of a string you use the format %var:~offset,length%
rem You may want to change it depending on your locale.
rem echo %date%
set /a d=%date:~8,2%
if "%date:~0,2%" == "08" (set /a d=8)
if "%date:~0,2%" == "09" (set /a d=9)
set /a m=%date:~5,2%
if "%date:~3,2%" == "08" (set /a m=8)
if "%date:~3,2%" == "09" (set /a m=9)
set /a y=%date:~0,4%

rem Change to next day.
rem If the day is greater than 31, change it back to 1 and increment the month.
rem If the month number is greater than 12, set it to 1 and increment the year.
:loop
  set /a d+=1

  if %d% gtr 31 (
    set d=1
    set /a m+=1
     
    if %m% gtr 12 (
      set m=1
      set /a y+=1
    )
  )

rem To check is the date is valid we use a "hack" with xcopy.
rem The /d:month-day-year parameter is used to select only files last editet after a date.
rem This parameter causes xcopy to throw an error if the date is invalid.
rem This way we can jump back to loop and increment the day again.
rem This trick handles 30-day months, february, and leap years.
xcopy /d:%m%-%d%-%y% /l . .. >nul 2>&1 || goto loop

rem We want all directory paths to be the same length, so that they may be found more easily.
rem With this we add a "0" before days and months that would only be 1 character long.
rem So instead of having 1, 2, 3, 4 as the month or day names, we have 01, 02, 03, 04, etc.
if %d% lss 10 set d=0%d%
if %m% lss 10 set m=0%m%

rem We set a variable named 'dir' because we will need it more than once.
set dir=.\%y%\%m%\%d%

rem Create the directory.
mkdir "%dir%"

rem Open Explorer.exe on the directory.
start "" explorer.exe "%dir%"
