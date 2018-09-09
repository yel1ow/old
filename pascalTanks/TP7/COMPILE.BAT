@echo off
IF "%1"=="" GOTO EXIT
tasm %1.asm /m2
IF NOT ERRORLEVEL==0 GOTO EXIT
IF NOT EXIST %1.obj GOTO EXIT
IF NOT "%2"=="/t" GOTO nocom
tlink %1.obj /x %2
GOTO cont1
:nocom
tlink %1.obj /x 
:cont1
del %1.obj
:EXIT
