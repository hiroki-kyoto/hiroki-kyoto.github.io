ECHO OFF
setlocal enabledelayedexpansion
CD data_structure
ECHO SWITCHED TO WORKING DIRECTORY

CD 2G
ECHO SWITCHED TO 2G DIRECTORY
ECHO CREATE SQL SCRIPT FOR 2G
ECHO.	> "../../_2G.PRC"
ECHO CREATE IMPORT BATCH FOR 2G
ECHO.	> "../../IMPORT_2G.BAT"
FOR /F %%i IN ('DIR /B') DO (
	SET F=0
	ECHO CREATE TABLE %%i
	ECHO DROP TABLE %%i; >> "../../_2G.PRC"
	ECHO CREATE TABLE %%i ^( >> "../../_2G.PRC"
	FOR /F "tokens=1 delims= " %%j IN (%%i) DO (
		IF !F! == 1 ( 
			ECHO.	, %%j >> "../../_2G.PRC" 
		) ELSE (
			ECHO.	%%j >> "../../_2G.PRC"
		)
		SET F=1
	)
	ECHO ^); >> "../../_2G.PRC"
	ECHO. >> "../../_2G.PRC"
	ECHO CREATE IMPORT CONTROL FILE FOR TABLE [%%i]
	ECHO OPTIONS^(BINDSIZE=8388608,READSIZE=8388608,ERRORS=-1,ROWS=50000^) > "../../_2G_%%i.CTL"
	ECHO LOAD DATA >> "../../_2G_%%i.CTL"
	ECHO INFILE 'example_data/2G/%%i_ANSI.csv' >> "../../_2G_%%i.CTL"
	ECHO BADFILE 'bad.txt' >> "../../_2G_%%i.CTL"
	ECHO DISCARDFILE 'discard.txt' >> "../../_2G_%%i.CTL"
	ECHO REPLACE INTO TABLE %%i >> "../../_2G_%%i.CTL"
	ECHO FIELDS TERMINATED BY ',' >> "../../_2G_%%i.CTL"
	ECHO ^(	>> "../../_2G_%%i.CTL"
	SET F=0
	FOR /F "delims=	" %%k IN (%%i) DO (
		IF !F! == 1 (
			ECHO.	, %%k >> "../../_2G_%%i.CTL"
		) ELSE (
			ECHO.	%%k >> "../../_2G_%%i.CTL"
		)
		SET F=1
	)
	ECHO ^) >> "../../_2G_%%i.CTL"
	ECHO SQLLDR 2G/root control=_2G_%%i.CTL log=log.txt bad=bad.txt >> "../../IMPORT_2G.BAT"
)
ECHO EXIT >> "../../_2G.PRC"
ECHO LEAVE 2G DIRECTORY
CD ..


CD 3G
ECHO SWITCHED TO 3G DIRECTORY
ECHO CREATE SQL SCRIPT FOR 3G
ECHO.	> "../../_3G.PRC"
ECHO CREATE IMPORT BATCH FOR 3G
ECHO.	> "../../IMPORT_3G.BAT"
FOR /F %%i IN ('DIR /B') DO (
	SET F=0
	ECHO CREATE TABLE %%i
	ECHO DROP TABLE %%i; >> "../../_3G.PRC"
	ECHO CREATE TABLE %%i ^( >> "../../_3G.PRC"
	FOR /F "tokens=1 delims= " %%j IN (%%i) DO (
		IF !F! == 1 ( 
			ECHO.	, %%j >> "../../_3G.PRC" 
		) ELSE (
			ECHO.	%%j >> "../../_3G.PRC"
		)
		SET F=1
	)
	ECHO ^); >> "../../_3G.PRC"
	ECHO. >> "../../_3G.PRC"
	ECHO CREATE IMPORT CONTROL FILE FOR TABLE [%%i]
	ECHO OPTIONS^(BINDSIZE=8388608,READSIZE=8388608,ERRORS=-1,ROWS=50000^) > "../../_3G_%%i.CTL"
	ECHO LOAD DATA >> "../../_3G_%%i.CTL"
	ECHO INFILE 'example_data/3G/%%i_ANSI.csv' >> "../../_3G_%%i.CTL"
	ECHO BADFILE 'bad.txt' >> "../../_3G_%%i.CTL"
	ECHO DISCARDFILE 'discard.txt' >> "../../_3G_%%i.CTL"
	ECHO REPLACE INTO TABLE %%i >> "../../_3G_%%i.CTL"
	ECHO FIELDS TERMINATED BY ',' >> "../../_3G_%%i.CTL"
	ECHO ^(	>> "../../_3G_%%i.CTL"
	SET F=0
	FOR /F "delims=	" %%k IN (%%i) DO (
		IF !F! == 1 (
			ECHO.	, %%k >> "../../_3G_%%i.CTL"
		) ELSE (
			ECHO.	%%k >> "../../_3G_%%i.CTL"
		)
		SET F=1
	)
	ECHO ^) >> "../../_3G_%%i.CTL"
	ECHO SQLLDR 3G/root control=_3G_%%i.CTL log=log.txt bad=bad.txt >> "../../IMPORT_3G.BAT"
)
ECHO EXIT >> "../../_3G.PRC"
ECHO LEAVE 3G DIRECTORY
CD ..


CD 4G
ECHO SWITCHED TO 4G DIRECTORY
ECHO CREATE SQL SCRIPT FOR 4G
ECHO.	> "../../_4G.PRC"
ECHO CREATE IMPORT BATCH FOR 4G
ECHO.	> "../../IMPORT_4G.BAT"
FOR /F %%i IN ('DIR /B') DO (
	SET F=0
	ECHO CREATE TABLE %%i
	ECHO DROP TABLE %%i; >> "../../_4G.PRC"
	ECHO CREATE TABLE %%i ^( >> "../../_4G.PRC"
	FOR /F "tokens=1 delims= " %%j IN (%%i) DO (
		IF !F! == 1 ( 
			ECHO.	, %%j >> "../../_4G.PRC" 
		) ELSE (
			ECHO.	%%j >> "../../_4G.PRC"
		)
		SET F=1
	)
	ECHO ^); >> "../../_4G.PRC"
	ECHO. >> "../../_4G.PRC"
	ECHO CREATE IMPORT CONTROL FILE FOR TABLE [%%i]
	ECHO OPTIONS^(BINDSIZE=8388608,READSIZE=8388608,ERRORS=-1,ROWS=50000^) > "../../_4G_%%i.CTL"
	ECHO LOAD DATA >> "../../_4G_%%i.CTL"
	ECHO INFILE 'example_data/4G/%%i_ANSI.csv' >> "../../_4G_%%i.CTL"
	ECHO BADFILE 'bad.txt' >> "../../_4G_%%i.CTL"
	ECHO DISCARDFILE 'discard.txt' >> "../../_4G_%%i.CTL"
	ECHO REPLACE INTO TABLE %%i >> "../../_4G_%%i.CTL"
	ECHO FIELDS TERMINATED BY ',' >> "../../_4G_%%i.CTL"
	ECHO ^(	>> "../../_4G_%%i.CTL"
	SET F=0
	FOR /F "delims=	" %%k IN (%%i) DO (
		IF !F! == 1 (
			ECHO.	, %%k >> "../../_4G_%%i.CTL"
		) ELSE (
			ECHO.	%%k >> "../../_4G_%%i.CTL"
		)
		SET F=1
	)
	ECHO ^) >> "../../_4G_%%i.CTL"
	ECHO SQLLDR 4G/root control=_4G_%%i.CTL log=log.txt bad=bad.txt >> "../../IMPORT_4G.BAT"
)
ECHO EXIT >> "../../_4G.PRC"
ECHO LEAVE 4G DIRECTORY
CD ..


ECHO LEAVE WORKING DIRECTORY
CD ..
ECHO DONE!
PAUSE