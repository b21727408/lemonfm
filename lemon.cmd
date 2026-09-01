@echo off
setlocal
set "GIT_BASH=%ProgramFiles%\Git\bin\bash.exe"
if not exist "%GIT_BASH%" set "GIT_BASH=%ProgramFiles(x86)%\Git\bin\bash.exe"
if not exist "%GIT_BASH%" (
  echo Git for Windows bash is required to run lemon.cmd. 1>&2
  exit /b 69
)
"%GIT_BASH%" "%~dp0lemon" %*
exit /b %ERRORLEVEL%
