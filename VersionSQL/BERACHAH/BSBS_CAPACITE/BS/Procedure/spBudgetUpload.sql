/****** Object:  Procedure [BS].[spBudgetUpload]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spBudgetUpload(@FINYEAR INT ,@ORGID  INT  ) 
AS

DECLARE @LEDGERID INT
DECLARE @CONTRACTID INT
DECLARE @CONTRACTNO VARCHAR(10)
DECLARE @PROJECTID  INT

 
SELECT @PROJECTID = PROJID FROM PROJECTS WHERE BORGID=@ORGID 
SELECT @CONTRACTID=CONTRID,@CONTRACTNO=CONTRNUMBER FROM CONTRACTS WHERE PROJID=@PROJECTID 

SELECT @ORGID ORGID,@CONTRACTID CONTRACTID,@CONTRACTNO CONTRACTNO,2 ACTIVITYID,SPACE(10) ACTIVITYNO,T.LEDGERID LEDGERID,
U.LEDGERCODE LEDGERCODE,@FINYEAR FINYEAR,1 PERIOD,U.BUDGET/12 BUDGET 
INTO #TEMP1
FROM BS.BUDGETUPLOAD U INNER JOIN LEDGERCODES T ON U.LEDGERCODE=T.LEDGERCODE 

DECLARE @PERIODINDEX INT
SET @PERIODINDEX = 1
WHILE @PERIODINDEX<13
BEGIN
  INSERT INTO BUDGETS(BORGID,CONTRACTID,CONTRACTNO,ACTIVITYID,ACTIVITYNO,LEDGERID,LEDGERNO,YEARNO,PERIOD,BUDGET) 
  SELECT * FROM #TEMP1
  UPDATE #TEMP1 SET PERIOD=@PERIODINDEX
  SET @PERIODINDEX = @PERIODINDEX + 1
END 
   