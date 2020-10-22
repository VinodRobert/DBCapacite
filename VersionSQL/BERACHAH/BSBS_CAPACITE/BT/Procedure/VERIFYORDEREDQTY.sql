/****** Object:  Procedure [BT].[VERIFYORDEREDQTY]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE BT.VERIFYORDEREDQTY
AS
-- A TEMPORARY PROCEDURE CAN BE DELETED LATER
CREATE TABLE #TEMP0(ID INT PRIMARY KEY IDENTITY(1,1),BORGID INT,PROJECTCODE INT, TOOLCODE VARCHAR(15), REMAININGBUDGET DECIMAL(18,4), PRQTY DECIMAL(18,4), BALANCEFORPURCHASE DECIMAL(18,4),ITEMID INT)


INSERT INTO #TEMP0(PROJECTCODE,TOOLCODE,REMAININGBUDGET) 
SELECT PROJECTCODE,TOOLCODE,CUMULATIVEQTY FROM BT.MonthlyMaterialBudget

UPDATE #TEMP0 SET BORGID = BTP.BORGID FROM BT.PROJECTS BTP INNER JOIN #TEMP0 ON #TEMP0.PROJECTCODE=BTP.ProjectID
DELETE FROM #TEMP0 WHERE BORGID=-1
UPDATE #TEMP0 SET BALANCEFORPURCHASE=0 
UPDATE #TEMP0 SET BALANCEFORPURCHASE=(T.QTY-T.ORDEREDQTY),ITEMID=T.ITEMID  FROM TENDERITEMS T INNER JOIN #TEMP0 ON #TEMP0.BORGID=T.BORG AND #TEMP0.TOOLCODE=T.RESCODE 

SELECT * FROM #TEMP0 