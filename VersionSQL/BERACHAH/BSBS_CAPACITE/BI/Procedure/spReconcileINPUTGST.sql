/****** Object:  Procedure [BI].[spReconcileINPUTGST]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE BI.spReconcileINPUTGST
AS

 


CREATE TABLE #OUTPUTGST(FINYEAR INT,PERIOD INT,ORGID INT,TRANSCGST DECIMAL(18,2),SALESCGST DECIMAL(18,2), TRANSSGST DECIMAL(18,2), SALESSGST DECIMAL(18,2), TRANSIGST DECIMAL(18,2), SALESIGST DECIMAL(18,2)) 
INSERT INTO #OUTPUTGST(FINYEAR,PERIOD,ORGID,SALESCGST,TRANSCGST,SALESSGST,TRANSSGST,SALESIGST,TRANSIGST)
SELECT DISTINCT YEAR,PERIOD,ORGID,0,0,0,0,0,0 FROM TRANSACTIONS WHERE YEAR>=2018 

DELETE FROM #OUTPUTGST WHERE FINYEAR=2018 AND PERIOD IN (1,2,3)
DELETE FROM #OUTPUTGST WHERE PERIOD=0 

SELECT FINYEAR,PERIOD,ORGID, SUM(CGST_AMOUNT) FROMSALESCGST INTO #TEMP0  FROM BI.PURCHASEHISTORY GROUP BY FINYEAR,PERIOD,ORGID  
UPDATE #OUTPUTGST SET SALESCGST = FROMSALESCGST FROM #TEMP0 INNER JOIN #OUTPUTGST ON #OUTPUTGST.FINYEAR=#TEMP0.FINYEAR AND #OUTPUTGST.PERIOD = #TEMP0.PERIOD AND #OUTPUTGST.ORGID = #TEMP0.ORGID


SELECT FINYEAR,PERIOD,ORGID, SUM(SGST_AMOUNT) FROMSALESSGST INTO #TEMP1  FROM BI.PURCHASEHISTORY GROUP BY FINYEAR,PERIOD,ORGID  
UPDATE #OUTPUTGST SET SALESSGST = FROMSALESSGST FROM #TEMP1 INNER JOIN #OUTPUTGST ON #OUTPUTGST.FINYEAR=#TEMP1.FINYEAR AND #OUTPUTGST.PERIOD = #TEMP1.PERIOD AND #OUTPUTGST.ORGID = #TEMP1.ORGID

SELECT FINYEAR,PERIOD,ORGID, SUM(IGST_AMOUNT) FROMSALESIGST INTO #TEMP2  FROM BI.PURCHASEHISTORY GROUP BY FINYEAR,PERIOD,ORGID  
UPDATE #OUTPUTGST SET SALESIGST = FROMSALESIGST FROM #TEMP2 INNER JOIN #OUTPUTGST ON #OUTPUTGST.FINYEAR=#TEMP2.FINYEAR AND #OUTPUTGST.PERIOD = #TEMP2.PERIOD AND #OUTPUTGST.ORGID = #TEMP2.ORGID


SELECT YEAR,PERIOD,SUM(DEBIT-CREDIT) FROMTRANCGST,ORGID INTO #TEMP3  FROM TRANSACTIONS  WHERE LEDGERCODE='1310025'  GROUP BY YEAR,PERIOD,ORGID  
UPDATE #OUTPUTGST SET TRANSCGST = FROMTRANCGST FROM #TEMP3 INNER JOIN #OUTPUTGST ON #OUTPUTGST.FINYEAR=#TEMP3.YEAR AND #OUTPUTGST.PERIOD = #TEMP3.PERIOD AND #OUTPUTGST.ORGID = #TEMP3.ORGID

SELECT YEAR,PERIOD,SUM(DEBIT-CREDIT) FROMTRANSGST,ORGID INTO #TEMP4  FROM TRANSACTIONS  WHERE LEDGERCODE='1310026'  GROUP BY YEAR,PERIOD,ORGID   
UPDATE #OUTPUTGST SET TRANSSGST = FROMTRANSGST FROM #TEMP4 INNER JOIN #OUTPUTGST ON #OUTPUTGST.FINYEAR=#TEMP4.YEAR AND #OUTPUTGST.PERIOD = #TEMP4.PERIOD AND #OUTPUTGST.ORGID = #TEMP4.ORGID

SELECT YEAR,PERIOD,SUM(DEBIT-CREDIT) FROMTRANIGST,ORGID INTO #TEMP5  FROM TRANSACTIONS  WHERE LEDGERCODE='1310027'  GROUP BY YEAR,PERIOD,ORGID   
UPDATE #OUTPUTGST SET TRANSIGST = FROMTRANIGST FROM #TEMP5 INNER JOIN #OUTPUTGST ON #OUTPUTGST.FINYEAR=#TEMP5.YEAR AND #OUTPUTGST.PERIOD = #TEMP5.PERIOD AND #OUTPUTGST.ORGID = #TEMP5.ORGID

DELETE FROM #OUTPUTGST WHERE SALESCGST=0 AND TRANSCGST=0 AND SALESSGST=0 AND TRANSSGST=0 AND SALESIGST=0 AND TRANSIGST=0 

SELECT * FROM #OUTPUTGST WHERE ABS(TRANSCGST-SALESCGST)>2 AND FINYEAR=2019 ORDER BY ORGID,FINYEAR,PERIOD 