/****** Object:  Procedure [dbo].[VRUNRECON]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[VRUNRECON]
AS

SELECT * INTO #TEMP1 FROM VRMONI
ALTER TABLE #TEMP1 ADD TBORGID INT
UPDATE #TEMP1 SET TBORGID = B.BORGID FROM BORGS B INNER JOIN #TEMP1 ON #TEMP1.PROJECTCODE=LEFT(B.BORGNAME,5)
 
ALTER TABLE #TEMP1 ADD ORDID INT 
UPDATE #TEMP1 SET ORDID = O.ORDID FROM ORD O INNER JOIN #TEMP1 ON #TEMP1.ORDERNUMBER=O.ORDNUMBER


ALTER TABLE #TEMP1 ADD ALLOCATED INT
ALTER TABLE #TEMP1 ADD DLVRID INT 
UPDATE #TEMP1 SET ALLOCATED=9

UPDATE #TEMP1 SET ALLOCATED = D.ALLOCATED, DLVRID =D.DLVRID  FROM DELIVERIES D 
INNER JOIN #TEMP1 T ON T.ORDID=D.ORDID AND T.GRNNO = D.GRNNO AND T.DLVRQTY=D.DLVRQTY AND T.RATE = D.PRICE AND 
T.TBORGID =D.TBORGID AND T.DLVRNUMBER=D.DLVRNO 

UPDATE #TEMP1 SET ALLOCATED = D.ALLOCATED, DLVRID =D.DLVRID  FROM DELIVERIES D 
INNER JOIN #TEMP1 T ON T.ORDID=D.ORDID AND T.GRNNO = D.GRNNO   AND T.RATE = D.PRICE AND 
T.TBORGID =D.TBORGID AND T.DLVRNUMBER=D.DLVRNO 

UPDATE #TEMP1 SET ALLOCATED = D.ALLOCATED, DLVRID =D.DLVRID  FROM DELIVERIES D 
INNER JOIN #TEMP1 T ON T.ORDID=D.ORDID AND T.GRNNO = D.GRNNO   AND T.DLVRQTY = (D.DLVRQTY-D.RECONQTY) AND 
T.TBORGID =D.TBORGID AND T.DLVRNUMBER=D.DLVRNO 

SELECT * FROM DELIVERIES WHERE DLVRDATE > '31-MAR-2015' AND DLVRID IN (SELECT DLVRID FROM #TEMP1 ) 
 

 UPDATE DELIVERIES SET RECONQTY=DLVRQTY , ALLOCATED=1 WHERE DLVRID IN (SELECT DLVRID FROM #TEMP1) 

 
 

 
 



 