/****** Object:  Procedure [BT].[spUpdateBudgetQtyAndRate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BT.spUpdateBudgetQtyAndRate
as
SELECT MONTHLYMATERIALBUDGETCODE,PROJECTCODE,TOOLCODE,CATEGORYTYPE,BUDGETCATEGORYNAME,CumulativeQty,BUDGETRATE,BUDGETAMOUNT 
INTO  #TEMP0 
FROM BT.MonthlyMaterialBudget  

ALTER TABLE #TEMP0 ADD BORGID INT 
UPDATE #TEMP0 SET BORGID=BTP.BORGID FROM BT.PROJECTS BTP INNER JOIN #TEMP0 ON #TEMP0.PROJECTCODE=BTP.PROJECTID 

ALTER TABLE #TEMP0 ADD ITEMID INT 
ALTER TABLE #TEMP0 ADD TENDERQTY DECIMAL(18,4) 
ALTER TABLE #TEMP0 ADD TENDERRATE DECIMAL(18,4) 

UPDATE #TEMP0 SET ITEMID=T.ITEMID, TENDERQTY=T.QTY, TENDERRATE=T.RATE 
FROM TENDERITEMS T 
INNER JOIN #TEMP0 ON #TEMP0.TOOLCODE=T.RESCODE AND #TEMP0.BORGID=T.BORG  

 

 
SELECT PROJECTCODE,TOOLCODE,SUM(BUDGETQTY) BUDGETQTY, SUM(BUDGETAMOUNT) BUDGETAMONT
INTO #TEMP1
FROM BT.ProjectMaterialBudgetMaster 
GROUP BY PROJECTCODE,TOOLCODE 

ALTER TABLE #TEMP0 ADD FINALBUDGETQTY DECIMAL(18,4) 
ALTER TABLE #TEMP0 ADD FINALBUDGETAMOUNT DECIMAL(18,4) 

UPDATE #TEMP0 SET FINALBUDGETQTY = T.BUDGETQTY, FINALBUDGETAMOUNT=T.BUDGETAMONT 
FROM #TEMP1 T 
INNER JOIN #TEMP0 ON #TEMP0.PROJECTCODE= T.PROJECTCODE AND #TEMP0.TOOLCODE=T.TOOLCODE 

SELECT * FROM #TEMP0 ORDER BY CATEGORYTYPE 