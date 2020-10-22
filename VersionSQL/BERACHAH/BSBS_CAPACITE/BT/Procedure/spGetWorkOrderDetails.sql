/****** Object:  Procedure [BT].[spGetWorkOrderDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BT.spGetWorkOrderDetails(@WORKORDERNUMBER VARCHAR(50))
AS

DECLARE @RECONID INT 
DECLARE @ORGID INT

CREATE TABLE #HEADER(ORDID INT,BORGID INT,PROJECT VARCHAR(200),ORDNUMBER VARCHAR(25),ORDERDATE DATETIME,SUPPID INT,SUBCONTRACTORS VARCHAR(200))
CREATE TABLE #DETAILS(ORID INT,LINENUMBER INT,ITEMDESCRIPTION VARCHAR(250),UOM VARCHAR(15),QTY DECIMAL(18,4),RATE DECIMAL(18,4),PROGQTY DECIMAL(18,4),BALANCEQTY DECIMAL(18,4),RESOURCECODE VARCHAR(20) ) 
CREATE TABLE #RECONS(RECONID INT,HEADERID INT,DETAILID INT,DESCRIPTION VARCHAR(250),UNIT VARCHAR(15),QUANTITY DECIMAL(18,4),PROGQTY DECIMAL(18,4),FINALQTY DECIMAL(18,4),RATE DECIMAL(18,4))

INSERT INTO #HEADER 
SELECT O.ORDID,O.BORGID,UPPER(B.BORGNAME) PROJECT ,O.ORDNUMBER,O.CREATEDATE,O.SUPPID,UPPER(S.SUPPNAME) SUBCONTRACTORS 
FROM ORD O
INNER JOIN BORGS B ON O.BORGID=B.BORGID 
INNER JOIN SUPPLIERS S ON O.SUPPID=S.SUPPID
WHERE O.RECTYPE='SC' AND O.ORDNUMBER = @WORKORDERNUMBER 

INSERT INTO #DETAILS 
SELECT ORDID,LINENUMBER,ITEMDESCRIPTION,UOM,QTY,PRICE,0,0,RESOURCECODE  FROM ORDITEMS WHERE ORDID = (SELECT ORDID FROM #HEADER) 

SELECT @RECONID = RECONID FROM SUBCRECONS WHERE ORDERNO = @WORKORDERNUMBER


INSERT INTO #RECONS 
SELECT @RECONID,HEADERID,DETAILID,DESCRIPTION,UNIT,QUANTITY,[PROG QTY] PROGQTY,[FINAL QTY]FINALQTY,RATE 
FROM ACCBOQDETAIL WHERE 
HEADERID = (SELECT HEADERID FROM ACCBOQHEADER WHERE RECONID = (SELECT RECONID FROM SUBCRECONS WHERE ORDERNO=@WORKORDERNUMBER))  
 

DELETE  FROM #RECONS WHERE DESCRIPTION ='Scheduled Items'

UPDATE #DETAILS 
SET PROGQTY = R.PROGQTY 
FROM #RECONS R 
INNER JOIN #DETAILS ON #DETAILS.ITEMDESCRIPTION=R.DESCRIPTION 


UPDATE #DETAILS SET BALANCEQTY = QTY-PROGQTY 

SELECT @ORGID=BORGID FROM #HEADER 

ALTER TABLE #DETAILS ADD ITEMID INT 
UPDATE #DETAILS SET ITEMID = TI.ITEMID FROM TENDERITEMS TI INNER JOIN #DETAILS ON #DETAILS.RESOURCECODE = TI.RESCODE WHERE TI.BORG=@ORGID 

ALTER TABLE #DETAILS ADD SHORTCLOSEDQTY DECIMAL(18,4)
UPDATE #DETAILS SET SHORTCLOSEDQTY=0.0



SELECT * FROM #HEADER
SELECT * FROM #DETAILS 
SELECT * FROM #RECONS