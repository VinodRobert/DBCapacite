/****** Object:  Procedure [BI].[spGetDebtors]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BI.spGetDebtors
as

DECLARE @STARTDEBTOR VARCHAR(10)
DECLARE @ENDDEBTOR VARCHAR(10)
SELECT @STARTDEBTOR=CONTROLFROMGL , @ENDDEBTOR=CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME='Debtors' 
SELECT LEDGERCODE,UPPER(LEDGERNAME) LEDGERNAME FROM LEDGERCODES
 WHERE LEDGERCODE IN (SELECT LEDGERCODE FROM LEDGERCODES WHERE LEDGERCODE BETWEEN  @STARTDEBTOR  AND @ENDDEBTOR )
 ORDER BY LEDGERCODE