/****** Object:  Procedure [BT].[spGetMaterialQtyDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spGetMaterialQtyDetails](@PROJECTCODE INT,@STARTPERIOD INT, @ENDPERIOD INT,@REVISIONID DECIMAL(18,2))
AS

 

SELECT * INTO #TEMP0 FROM [BT].[TempMaterialSpread]

CREATE TABLE #TEMPBUDGETSPREAD(TOOLCODE VARCHAR(15),MONTHID INT,BUDGETQTY DECIMAL(18,2),BUDGETAMOUNT DECIMAL(18,2),REVISIONID DECIMAL(6,2)) 

IF @REVISIONID = -1
 BEGIN
    INSERT INTO #TEMPBUDGETSPREAD
	SELECT M.TOOLCODE,D.MONTHID,SUM(D.BUDGETQTY)BUDGETQTY,SUM(D.BUDGETAMOUNT)BUDGETAMOUNT,-1
	FROM BT.ProjectMaterialBudgetMaster M INNER JOIN BT.PROJECTMATERIALBUDGETDETAIL D 
	ON M.PROJECTMATERIALBUDGETCODE = D.PROJECTMATERIALBUDGETID AND M.PROJECTCODE=@PROJECTCODE 
	GROUP BY TOOLCODE,MONTHID 
	ORDER BY TOOLCODE 
 END
ELSE
 BEGIN
    INSERT INTO #TEMPBUDGETSPREAD
    SELECT M.TOOLCODE,D.MONTHID,D.BUDGETQTY,D.BUDGETAMOUNT,M.REVISIONID
	FROM BT.ProjectMaterialBudgetMaster M INNER JOIN BT.PROJECTMATERIALBUDGETDETAIL D 
	ON M.PROJECTMATERIALBUDGETCODE = D.PROJECTMATERIALBUDGETID AND 
	M.REVISIONID = @REVISIONID AND D.REVISIONID=@REVISIONID AND M.PROJECTCODE=@PROJECTCODE 
    ORDER BY M.TOOLCODE 
 END 


--SELECT M.TOOLCODE,D.MONTHID,D.BUDGETQTY,D.BUDGETAMOUNT,M.REVISIONID
--INTO #TEMPBUDGETSPREAD
--FROM BT.ProjectMaterialBudgetMaster M INNER JOIN BT.PROJECTMATERIALBUDGETDETAIL D 
--ON M.PROJECTMATERIALBUDGETCODE = D.PROJECTMATERIALBUDGETID AND 
--M.REVISIONID = @REVISIONID AND D.REVISIONID=@REVISIONID 
--ORDER BY M.TOOLCODE 





SELECT TOOLCODE,MONTHID,SUM(BUDGETQTY) BUDGETQTY, SUM(BUDGETAMOUNT) BUDGETAMOUNT ,REVISIONID
INTO #TEMPBUDGETSPREADSUMMARY
FROM #TEMPBUDGETSPREAD
GROUP BY TOOLCODE,MONTHID ,REVISIONID 

 


SELECT DISTINCT TOOLCODE,BUDGETRATE
INTO #TEMPRATESONLY
FROM BT.ProjectMaterialBudgetMaster 
WHERE PROJECTCODE=@PROJECTCODE 
--AND REVISIONID = @REVISIONID 

ALTER TABLE #TEMPBUDGETSPREADSUMMARY ADD BUDGETRATE DECIMAL(18,2) 
UPDATE #TEMPBUDGETSPREADSUMMARY SET BUDGETRATE = R.BUDGETRATE 
FROM #TEMPRATESONLY R  INNER JOIN #TEMPBUDGETSPREADSUMMARY 
ON #TEMPBUDGETSPREADSUMMARY.TOOLCODE = R.TOOLCODE 
 
 

CREATE TABLE #TEMPMASTERBUDGET(TOOLCODE VARCHAR(15),BUDGETQTY DECIMAL(18,2),BUDGETAMOUNT DECIMAL(18,2)) 

IF @REVISIONID = -1
 BEGIN
    INSERT INTO #TEMPMASTERBUDGET
    SELECT TOOLCODE,SUM(BUDGETQTY) BUDGETQTY, SUM(BUDGETAMOUNT) BUDGETAMOUNT 
	FROM BT.ProjectMaterialBudgetMaster
	WHERE PROJECTCODE  = @PROJECTCODE  
	GROUP BY TOOLCODE 
 END
ELSE
 BEGIN
    INSERT INTO #TEMPMASTERBUDGET
    SELECT TOOLCODE,SUM(BUDGETQTY) BUDGETQTY, SUM(BUDGETAMOUNT) BUDGETAMOUNT 
	FROM BT.ProjectMaterialBudgetMaster
	WHERE PROJECTCODE  = @PROJECTCODE AND REVISIONID = @REVISIONID 
	GROUP BY TOOLCODE 
 END 



ALTER TABLE #TEMPMASTERBUDGET ADD BUDGETRATE DECIMAL(18,2) 
UPDATE #TEMPMASTERBUDGET SET BUDGETRATE = R.BUDGETRATE 
FROM #TEMPRATESONLY R INNER JOIN #TEMPMASTERBUDGET
ON #TEMPMASTERBUDGET.TOOLCODE = R.TOOLCODE 


INSERT INTO #TEMP0(TOOLCODE,BUDGETTOOLNAME,CATEGORY,UOM,QTY,RATE,AMOUNT)
SELECT 
    BTPM.TOOLCODE,
    BT.TEMPLATENAME,
	BT.CATEGORY,
	BT.UOM,
	BTPM.BUDGETQTY,
	BTPM.BUDGETRATE,
	BTPM.BUDGETAMOUNT
FROM #TEMPMASTERBUDGET BTPM  INNER JOIN BT.mastermaterialbudget BT ON BT.TEMPLATECODE = BTPM.TOOLCODE 
 


 


DECLARE @SQL0 VARCHAR(4000)
DECLARE @SQL1 VARCHAR(200)
DECLARE @SQL2 VARCHAR(200)
DECLARE @SQL3 VARCHAR(200)
DECLARE @SQL4 VARCHAR(4000)
DECLARE @COUNTER INT
DECLARE @PERIODID INT 

SET @PERIODID=@STARTPERIOD
SET @COUNTER=0
SET @SQL0 = 'SELECT [TOOLCODE]      ,[BUDGETTOOLNAME]      ,[CATEGORY], [UOM]      ,[QTY]      ,[RATE]      ,[AMOUNT],' 
SET @SQL1 =''
SET @SQL2 =''
SET @SQL3 =''
 
WHILE @PERIODID <=@ENDPERIOD
BEGIN

   SET @COUNTER = @COUNTER+1
   SET @SQL1 = 'UPDATE #TEMP0 SET ['+LTRIM(RTRIM(STR(@COUNTER)))+'Q]= BUDGETQTY     FROM  #TEMPBUDGETSPREADSUMMARY   INNER JOIN #TEMP0 ON #TEMP0.TOOLCODE= #TEMPBUDGETSPREADSUMMARY.TOOLCODE   WHERE MONTHID='+LTRIM(RTRIM(STR(@PERIODID)))
 
   SET @SQL2 = 'UPDATE #TEMP0 SET ['+LTRIM(RTRIM(STR(@COUNTER)))+'R]= BUDGETRATE    FROM  #TEMPBUDGETSPREADSUMMARY   INNER JOIN #TEMP0 ON #TEMP0.TOOLCODE= #TEMPBUDGETSPREADSUMMARY.TOOLCODE   WHERE MONTHID='+LTRIM(RTRIM(STR(@PERIODID)))
 
   SET @SQL3 = 'UPDATE #TEMP0 SET ['+LTRIM(RTRIM(STR(@COUNTER)))+'A]= BUDGETAMOUNT  FROM  #TEMPBUDGETSPREADSUMMARY   INNER JOIN #TEMP0 ON #TEMP0.TOOLCODE= #TEMPBUDGETSPREADSUMMARY.TOOLCODE   WHERE MONTHID='+LTRIM(RTRIM(STR(@PERIODID)))
 
   EXEC(@SQL1)
   EXEC(@SQL2)
   EXEC(@SQL3)
   SET @SQL0 = @SQL0 + '['+LTRIM(RTRIM(STR(@COUNTER)))+'Q], ['+LTRIM(RTRIM(STR(@COUNTER)))+'R] ,['+LTRIM(RTRIM(STR(@COUNTER)))+'A],'

   SET @PERIODID = @PERIODID+1

   
END



SET @SQL4 = SUBSTRING(@SQL0,1,LEN(@SQL0)-1)+' FROM #TEMP0 ORDER BY BUDGETTOOLNAME' 

 
EXEC(@SQL4)
 