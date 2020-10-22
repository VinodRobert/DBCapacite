/****** Object:  Procedure [BI].[spPeriodLockStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BI.spPeriodLockStatus(@FINYEAR INT) 
as

SELECT 
 ORGID,PERIOD,DESCR,STATUS 
 INTO #TEMP0 
 FROM PERIODSETUP
 WHERE YEAR=@FINYEAR 