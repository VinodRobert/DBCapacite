/****** Object:  Procedure [BT].[POUPLATEFORMATERIALRELEASE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[POUPLATEFORMATERIALRELEASE](@PROJECTID INT, @TOPERIOD INT)
AS

 

DECLARE @BORGID INT 
SELECT @BORGID = BORGID FROM BT.PROJECTS WHERE PROJECTID=@PROJECTID 

SELECT 
       MA.PROJECTCODE,
       MS.TOOLCODE,
 	   SUM(MS.QTY) BUDGETQTY 
INTO #BUDGET
FROM   BT.MATERIAL MA INNER JOIN BT.MATERIALSPREAD MS ON MA.MATERIALID = MS.MATERIALCODE 
                      INNER JOIN BT.MATERIALMASTER MM ON MA.TOOLCODE = MM.TOOLCODE 
WHERE  MA.PROJECTCODE = @PROJECTID AND MS.YEARPERIODCODE<=@TOPERIOD 
GROUP BY 
       MA.PROJECTCODE,MS.TOOLCODE 

 select * from #budget 
SELECT 
   TOOLCODE,
   SUM(RELEASEQTY) ALREADYREALEASED
INTO
   #ALREADYRELEASED
FROM 
   BT.RELEASESUMMARY  BTR
WHERE
   BTR.PROJECTCODE = @PROJECTID 
GROUP BY 
   TOOLCODE 


SELECT TE.RESCODE,
       TE.QTY,
	   TE.BORG,
	   TE.ORDEREDQTY,
	   MM.TOOLCODE 
INTO #CURRENTSTATUS
FROM TENDERITEMS TE INNER JOIN BT.MATERIALMASTER MM ON TE.RESCODE=MM.MATERIALCODE 
WHERE BORG = @BORGID 

 

CREATE TABLE #FINAL(TOOLCODE VARCHAR(10),MATERIALCODE VARCHAR(10),MATERIALNAME VARCHAR(200),UOM VARCHAR(10),BUDGETQTY DECIMAL(18,4),
                    RELEASEQTY DECIMAL(18,4), ORDEREDQTY DECIMAL(18,4), BALANCEQTY DECIMAL(18,4), THISRELEASE DECIMAL(18,4) , RATE DECIMAL(18,2),
					MATERIALCATEGORY VARCHAR(100), GLCODE VARCHAR(10) ) 

INSERT INTO #FINAL(TOOLCODE,BUDGETQTY,RELEASEQTY,THISRELEASE,ORDEREDQTY)
SELECT TOOLCODE,BUDGETQTY,0,0,0 FROM #BUDGET 

UPDATE #FINAL SET RATE = MA.RATE FROM BT.MATERIAL  MA INNER JOIN #FINAL ON #FINAL.TOOLCODE = MA.ToolCode 
UPDATE #FINAL SET MATERIALCATEGORY=MA.MATERIALCATEGORY, GLCODE= MA.GLCODE   FROM BT.MATERIALMASTER  MA INNER JOIN #FINAL ON #FINAL.TOOLCODE = MA.ToolCode 
UPDATE #FINAL SET RELEASEQTY = RA.ALREADYREALEASED FROM #ALREADYRELEASED RA INNER JOIN #FINAL ON #FINAL.TOOLCODE=RA.TOOLCODE 
UPDATE #FINAL SET ORDEREDQTY = CS.ORDEREDQTY FROM #CURRENTSTATUS CS INNER JOIN #FINAL ON #FINAL.TOOLCODE=CS.TOOLCODE 
UPDATE #FINAL SET BALANCEQTY = BUDGETQTY - RELEASEQTY 

UPDATE #FINAL SET MATERIALCODE = MM.MATERIALCODE , MATERIALNAME=MM.MATERIALNAME, UOM=MM.UOM ,THISRELEASE = BALANCEQTY 
FROM #FINAL INNER JOIN BT.MATERIALMASTER MM ON #FINAL.TOOLCODE = MM.TOOLCODE 

                    
 

SELECT
   MATERIALCATEGORY,
   TOOLCODE,
   MATERIALCODE,
   MATERIALNAME,
   UOM,
   RATE,
   BUDGETQTY,
   RELEASEQTY,
   ORDEREDQTY,
   BALANCEQTY,
   THISRELEASE,
   GLCODE 
FROM 
   #FINAL 
WHERE 
   BALANCEQTY>0 
ORDER BY 
   MATERIALCATEGORY,MATERIALNAME 
 