/****** Object:  Procedure [BT].[spUpdateBudgetReleaseLogs]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE  [BT].[spUpdateBudgetReleaseLogs] (@START BIGINT,@END BIGINT)
AS
BEGIN
 
SELECT RELEASESUMMARYID,RELEASEDATE,PROJECTCODE,TOOLCODE,RELEASEQTY  
INTO #TEMP1
FROM [BT].[RELEASESUMMARY]
WHERE RELEASESUMMARYID BETWEEN @START AND @END 


UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET RELEASED=0 WHERE RELEASED IS NULL

UPDATE BT.BUDGETMATERAILMOVEMENTHEAD 
SET RELEASED  = RELEASED+RELEASEQTY 
FROM #TEMP1 
INNER JOIN BT.BUDGETMATERAILMOVEMENTHEAD  H 
ON #TEMP1.PROJECTCODE=H.PROJECTCODE AND #TEMP1.TOOLCODE=H.TOOLCODE 






INSERT INTO BT.MATERIALBUDGETLOG(LOGDATE,TRANSACTIONTYPE,PROJECTCODE,TOOLCODE,QTY,RATE,AMOUNT,CROSSREFERENCEID)
SELECT GETDATE(),'R',PROJECTCODE,TOOLCODE,RELEASEQTY,0,0,RELEASESUMMARYID FROM #TEMP1 
 

 
END 
 
 