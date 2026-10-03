@echo off
REM ---------------------------------------------------------------------
REM Nanchang University bachelor thesis template (unified edition v1.2.0)
REM One-click full build
REM
REM Usage: double-click this file, or run  build.bat  [jobname]
REM        (jobname without extension; defaults to main)
REM
REM Pipeline: xelatex -> biber -> xelatex -> xelatex
REM   A single xelatex pass leaves \cite and \ref as ? / ?? -- that is
REM   normal, because cross-references and the bibliography are filled in
REM   during the later passes.
REM   Since v1.2.0 the bibliography uses biblatex with the BIBER backend
REM   (gb7714-2015 style). Do NOT run BibTeX on it: biber reads the .bcf
REM   control file that biblatex writes; BibTeX cannot and will fail.
REM
REM NOTE: this file is intentionally pure ASCII. Chinese characters in a
REM       .bat file get mis-decoded by cmd.exe and break the script.
REM ---------------------------------------------------------------------
setlocal
set "JOB=%~1"
if "%JOB%"=="" set "JOB=main"

where xelatex >nul 2>nul
if errorlevel 1 (
  echo [ERROR] xelatex not found.
  echo         Install TeX Live or MiKTeX and make sure its bin folder is in PATH.
  pause
  exit /b 1
)

echo [1/4] XeLaTeX pass 1 of 3 - writing .bcf and .aux ...
xelatex -interaction=nonstopmode "%JOB%.tex"
if errorlevel 1 goto failed

echo [2/4] biber - writing bibliography .bbl ...
biber "%JOB%"
if errorlevel 1 goto failed

echo [3/4] XeLaTeX pass 2 of 3 - reading .bbl and numbers ...
xelatex -interaction=nonstopmode "%JOB%.tex"
if errorlevel 1 goto failed

echo [4/4] XeLaTeX pass 3 of 3 - stabilising cross-references ...
xelatex -interaction=nonstopmode "%JOB%.tex"
if errorlevel 1 goto failed

echo.
echo Done. Output: %JOB%.pdf
echo.
pause
exit /b 0

:failed
echo.
echo [FAILED] Build interrupted.
echo          Look at the lines beginning with "!" near the end of %JOB%.log,
echo          or at the messages from biber just above.
echo          Common causes: biblatex / gb7714-2015 package not installed,
echo          a syntax error inside references.bib.
echo.
pause
exit /b 1
