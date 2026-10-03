@echo off
REM ---------------------------------------------------------------------
REM Bibliography environment self-check (v1.2.4)
REM Usage: double-click this file, or run  checkbib.bat [jobname]
REM
REM This tool only READS files and reports what is missing. It never
REM modifies or deletes anything.
REM
REM NOTE: this file is intentionally pure ASCII. Chinese characters in a
REM       .bat file get mis-decoded by cmd.exe and break the script.
REM ---------------------------------------------------------------------
setlocal enabledelayedexpansion
set "JOB=%~1"
if "%JOB%"=="" set "JOB=main"

echo ==========================================================
echo  NCU thesis template - bibliography environment check
echo  (read-only: nothing is modified or deleted)
echo ==========================================================
echo.

echo [1/5] xelatex
where xelatex >nul 2>nul
if errorlevel 1 (
  echo       MISSING  -  install TeX Live or MiKTeX first.
  set MISSINGX=1
) else (
  for /f "tokens=1,2,3" %%a in ('xelatex --version 2^>nul ^| findstr /b "XeTeX"') do echo       OK  -  %%a %%b %%c
)

echo [2/5] biber  (the bibliography backend this template REQUIRES)
where biber >nul 2>nul
if errorlevel 1 (
  echo       MISSING  ^<==  THIS IS WHY THE BIBLIOGRAPHY IS EMPTY
  echo       Fix: install a complete TeX Live, or in TeXstudio set
  echo            Options - Setup - Build - Default Bibliography Tool = biber
  set MISSINGB=1
) else (
  for /f "delims=" %%v in ('biber --version 2^>nul') do echo       OK  -  %%v
)

echo [3/5] latexmk  (optional, auto-runs the whole chain)
where latexmk >nul 2>nul
if errorlevel 1 (echo       not found - optional) else (echo       OK)

echo [4/5] %JOB%.bcf  (written by xelatex, read by biber)
if exist "%JOB%.bcf" (
  echo       OK  -  present
) else (
  echo       not found  -  run xelatex at least once.
)

echo [5/5] %JOB%.bbl  (written by biber, read by xelatex)
if not exist "%JOB%.bbl" (
  echo       MISSING  -  biber never ran. This is the direct cause of
  echo                   the empty bibliography.
  set BBLSTATE=missing
) else (
  for %%F in ("%JOB%.bbl") do set SIZE=%%~zF
  if !SIZE! EQU 0 (
    echo       0 bytes  ^<==  EMPTY. BibTeX was run instead of biber.
    echo       Fix: delete %JOB%.bbl and run biber.
    set BBLSTATE=empty
  ) else (
    echo       OK  -  !SIZE! bytes
    set BBLSTATE=ok
  )
)

echo.
echo ----------------------------------------------------------
echo  VERDICT
echo ----------------------------------------------------------
if defined MISSINGB (
  echo  biber is not installed / not in PATH. Install a full TeX Live,
  echo  then compile with:  xelatex -^> biber -^> xelatex -^> xelatex
  echo  Easiest: double-click build.bat in this folder.
) else if not exist "%JOB%.bcf" (
  echo  No %JOB%.bcf found. Run xelatex once first.
) else if "%BBLSTATE%"=="empty" (
  echo  %JOB%.bbl is 0 bytes: BibTeX ran instead of biber. Delete %JOB%.bbl,
  echo  then compile with biber. Easiest: double-click build.bat here.
) else if "%BBLSTATE%"=="missing" (
  echo  biber exists but has not been run on %JOB%.
  echo  Easiest: double-click build.bat in this folder, or run:
  echo      xelatex %JOB%  -^>  biber %JOB%  -^>  xelatex %JOB%  -^>  xelatex %JOB%
) else (
  echo  Environment looks correct. Compile with build.bat / build.sh / latexmk.
  echo  If references are still missing afterwards, check that the keys used
  echo  in \cite{...} exist in references.bib.
)
echo.
echo If everything above says OK but references are still missing,
echo see README.md, section "references only show a heading".
echo.
pause
exit /b 0
