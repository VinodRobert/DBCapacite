/****** Object:  Procedure [BT].[spGetManpowerBudgetDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spGetManpowerBudgetDetails](@PROJECTCODE INT,@STARTPERIOD INT, @ENDPERIOD INT, @REVISIONID INT)
AS

SELECT * INTO #TEMP0 FROM [BT].[TempBudgetSpread]


INSERT INTO #TEMP0(BUDGETCODE,DESCRIPTION,AMOUNT) 
SELECT 
       MA.SKILLTYPECODE,
	   MA.SKILLTYPE,
	   MA.BUDGETCOUNT
FROM BT.MANPOWERBUDGET MA
WHERE 
     MA.PROJECTCODE = @PROJECTCODE  AND 
	 REVISIONID = @REVISIONID 


 

DECLARE @SQL0 VARCHAR(4000)
DECLARE @SQL1 VARCHAR(200)
 
DECLARE @SQL4 VARCHAR(4000)
DECLARE @COUNTER INT
DECLARE @PERIODID INT 

SET @PERIODID=@STARTPERIOD
SET @COUNTER=0
SET @SQL0 = 'SELECT [BUDGETCODE],[DESCRIPTION],[AMOUNT],' 
SET @SQL1 =''
 
 
WHILE @PERIODID <=@ENDPERIOD
BEGIN

   SET @COUNTER = @COUNTER+1
   SET @SQL1 = 'UPDATE #TEMP0 SET ['+LTRIM(RTRIM(STR(@COUNTER)))+'A]= BTS.PERIODBUDGET  FROM BT.MANPOWERBUDGETSPREAD BTS INNER JOIN #TEMP0 ON #TEMP0.BUDGETCODE= BTS.MANPOWERCODE WHERE YEARPERIODCODE='+LTRIM(RTRIM(STR(@PERIODID)))+' AND PROJECTCODE=';
   SET @SQL1 = @SQL1 + LTRIM(RTRIM(STR(@PROJECTCODE)))+'  AND REVISIONID = '+LTRIM(RTRIM(STR(@REVISIONID)))
  
   EXEC(@SQL1)


   SET @SQL0 = @SQL0 + '['+LTRIM(RTRIM(STR(@COUNTER)))+'A],  '

   SET @PERIODID = @PERIODID+1
END
 

 

SET @SQL4 = SUBSTRING(@SQL0,1,LEN(@SQL0)-1)+' FROM #TEMP0 ORDER BY BUDGETCODE' 

 
EXEC(@SQL4)
 