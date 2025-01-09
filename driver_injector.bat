@echo off
REM Set the base directory where the FileRepository is located
set "SOURCE_DISQUE=X:" REM Adjust this to match your source disque path
set "DRIVER_DIR=%SOURCE_DISQUE%\Windows\System32\DriverStore\FileRepository"
set "DESTINATION_DISQUE=Y:\"  REM Adjust this to match your destination path

REM Check if at least one argument is provided
if "%~1"=="" (
    echo No arguments provided. Please specify .inf file names.
    echo Usage: add_drivers.bat file1.inf file2.inf ...
    exit /b 1
)

REM Process each argument provided
cd %SOURCE_DISQUE%
for %%I in (%*) do (
    echo Searching for %%I in %DRIVER_DIR%...
    
    REM Search for the folder matching the pattern %%I.*
    for /d %%D in ("%DRIVER_DIR%\%%~nI.*") do (
        echo Found directory: %%D
        REM Check if the .inf file exists in the directory
        if exist "%%D\%%~I" (
            echo Adding driver %%~I from directory %%D...
            dism /Image:%DESTINATION_DISQUE% /Add-Driver /Driver:"%%D\%%~I"
            
            REM Check for errors
            if errorlevel 1 (
                echo Error processing %%~I in %%D
                echo.
            ) else (
                echo Successfully processed %%~I
                echo.
            )
        ) else (
            echo File %%~I not found in %%D
        )
    )
)

echo All tasks completed!
pause