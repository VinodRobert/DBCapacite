/****** Object:  Procedure [BT].[spReleaseQtyBackToBudget]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spReleaseQtyBackToBudget]
AS

DECLARE @REQQTY DECIMAL(18,4) 
DECLARE @INDEXCODE INT 
DECLARE @TENDERID INT 
DECLARE @MONTHLYMATERIALBUDGETCODE INT 
DECLARE @REQAMOUNT DECIMAL(18,4) 
DECLARE @PROJECTID INT 
DECLARE @TOOLCODE VARCHAR(15) 
DECLARE @BORGID INT 
DECLARE @ORDQTY DECIMAL(18,4)
DECLARE @ORDRATE DECIMAL(18,2)
DECLARE @ORDAMOUNT DECIMAL(18,4) 
DECLARE @DELIVEREDQTY DECIMAL(18,4) 
DECLARE @DIFFERENCEQTY DECIMAL(18,4) 
DECLARE @DIFFERENCEAMOUNT DECIMAL(18,2) 


-- THIS ROUTINE WILL READ THE OPEN PRs and FIRST CHANGE THE STATUS OF THE REQUISITION 
-- THE NEW STATUS COULD BE 'CANCELLED', 'REJECTED'  , 'AWAITING APPROVAL', 'PO CREATED' 

CREATE TABLE #TEMP0(INDEXCODE INT, REQID INT, LINENUMBER INT) 
INSERT INTO #TEMP0(INDEXCODE,REQID,LINENUMBER) 
SELECT INDEXCODE,REQID,LINENUMBER 
FROM BT.MATERIALMOVEMENTDETAIL
WHERE REQSTATUS=163 AND FINALIZATIONSTATUS=0

ALTER TABLE #TEMP0 ADD NEWSTATUS INT 
ALTER TABLE #TEMP0 ADD REQRATE DECIMAL(18,4) 
ALTER TABLE #TEMP0 ADD REQNUMBER VARCHAR(35)

UPDATE #TEMP0 SET NEWSTATUS = REQITEMS.ITEMSTATUSID,REQRATE=REQITEMS.PRICE FROM REQITEMS 
INNER JOIN #TEMP0 ON #TEMP0.REQID=REQITEMS.REQID AND #TEMP0.LINENUMBER = REQITEMS.LINENUMBER 
DELETE FROM #TEMP0 WHERE NEWSTATUS=163
UPDATE #TEMP0 SET REQNUMBER = REQ.REQNUMBER FROM REQ INNER JOIN #TEMP0 ON #TEMP0.REQID = #TEMP0.REQID 
UPDATE BT.MATERIALMOVEMENTDETAIL 
SET REQSTATUS=#TEMP0.NEWSTATUS ,
    REQRATE = #TEMP0.REQRATE,
	REQAMOUNT = BT.MATERIALMOVEMENTDETAIL.REQQTY*#TEMP0.REQRATE
FROM #TEMP0 INNER JOIN BT.MATERIALMOVEMENTDETAIL ON #TEMP0.INDEXCODE=BT.MATERIALMOVEMENTDETAIL.INDEXCODE

DROP TABLE #TEMP0 



--- PURCHASE ORDER CREATED - CHANGING THE STATUS 

CREATE TABLE #TEMP1(INDEXCODE INT, REQID INT, LINENUMBER INT) 
INSERT INTO #TEMP1(INDEXCODE,REQID,LINENUMBER) 
SELECT INDEXCODE,REQID,LINENUMBER 
FROM BT.MATERIALMOVEMENTDETAIL
WHERE REQSTATUS=173 AND FINALIZATIONSTATUS=0

ALTER TABLE #TEMP1 ADD NEWSTATUS INT 
ALTER TABLE #TEMP1 ADD ORDID INT 
ALTER TABLE #TEMP1 ADD ORDNUMBER VARCHAR(25)
ALTER TABLE #TEMP1 ADD ORDDATE DATETIME
ALTER TABLE #TEMP1 ADD ORDQTY DECIMAL(18,4)
ALTER TABLE #TEMP1 ADD ORDRATE DECIMAL(18,2) 
ALTER TABLE #TEMP1 ADD ORDSTATUS INT 

UPDATE #TEMP1 
SET ORDID = O.ORDID ,
    ORDNUMBER = O.ORDNUMBER,
	ORDDATE = O.CREATEDATE
FROM ORD O INNER JOIN #TEMP1 ON #TEMP1.REQID = O.REQID 


UPDATE #TEMP1 
  SET NEWSTATUS = OI.ITEMSTATUSID,
      ORDQTY = OI.QTY,
	  ORDRATE = OI.PRICE,
	  ORDSTATUS = OI.ITEMSTATUSID 
FROM ORDITEMS OI 
INNER JOIN #TEMP1 ON #TEMP1.ORDID = OI.ORDID AND #TEMP1.LINENUMBER = OI.LINENUMBER 


UPDATE BT.MATERIALMOVEMENTDETAIL 
SET ORDID = T.ORDID ,
    ORDNUMBER = T.ORDNUMBER,
	ORDDATE = T.ORDDATE,
	ORDQTY = T.ORDQTY,
	ORDRATE = T.ORDRATE,
	ORDAMOUNT = T.ORDQTY*T.ORDRATE,
	ORDSTATUS = T.ORDSTATUS
FROM #TEMP1 T INNER JOIN BT.MATERIALMOVEMENTDETAIL ON T.INDEXCODE=BT.MATERIALMOVEMENTDETAIL.INDEXCODE

DROP TABLE #TEMP1 



---- ADDRESSING REQUISITION CANCELLATIONS / REJECTIONS 

DECLARE CANCELLEDPRS CURSOR FOR 
SELECT INDEXCODE,TENDERID FROM BT.MATERIALMOVEMENTDETAIL WHERE REQSTATUS IN (36,202) AND FINALIZATIONSTATUS=0

OPEN CANCELLEDPRS 
FETCH NEXT FROM CANCELLEDPRS INTO @INDEXCODE,@TENDERID 

WHILE @@FETCH_STATUS=0 
BEGIN
  SELECT @TOOLCODE=RESCODE FROM TENDERITEMS WHERE ITEMID =@TENDERID 
  SELECT @REQQTY = REQQTY ,@REQAMOUNT =REQAMOUNT,@BORGID=BORGID  FROM BT.MATERIALMOVEMENTDETAIL WHERE INDEXCODE=@INDEXCODE 
  SELECT @PROJECTID = PROJECTID FROM BT.PROJECTS WHERE BORGID=@BORGID 
  SELECT @MONTHLYMATERIALBUDGETCODE = MONTHLYMATERIALBUDGETCODE  FROM BT.MonthlyMaterialBudget 
         WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE  


  UPDATE BT.MonthlyMaterialBudget  SET CumulativeQty=CumulativeQty+@REQQTY  WHERE CATEGORYTYPE='Q' AND MonthlyMaterialBudgetCode=@MONTHLYMATERIALBUDGETCODE
  UPDATE BT.MonthlyMaterialBudget  SET BUDGETAMOUNT=BUDGETAMOUNT+@REQAMOUNT WHERE CATEGORYTYPE='L' AND MonthlyMaterialBudgetCode=@MONTHLYMATERIALBUDGETCODE
  UPDATE BT.MATERIALMOVEMENTDETAIL SET FINALIZATIONSTATUS=1   WHERE INDEXCODE=@INDEXCODE 
  

  FETCH NEXT FROM CANCELLEDPRS INTO @INDEXCODE,@TENDERID
END 


CLOSE CANCELLEDPRS
DEALLOCATE CANCELLEDPRS


---- COMPLETED POS - SHORT CLOSING OF POS


CREATE TABLE #TEMP3(INDEXCODE INT,ORDID  INT,LINENUMBER INT,TENDERID INT,NEWSTATUS INT)
INSERT INTO #TEMP3(INDEXCODE,ORDID,LINENUMBER,TENDERID,NEWSTATUS)
SELECT INDEXCODE,ORDID,LINENUMBER,TENDERID,0 FROM BT.MATERIALMOVEMENTDETAIL WHERE ORDSTATUS=274 AND FINALIZATIONSTATUS=0


UPDATE #TEMP3 SET NEWSTATUS=ITEMSTATUSID FROM ORDITEMS 
INNER JOIN #TEMP3 ON #TEMP3.ORDID =ORDITEMS.ORDID AND #TEMP3.LINENUMBER=ORDITEMS.LINENUMBER 



-- NO CHANGE WHEN THE STATUS IS STILL 274 - PO READY 
DELETE FROM #TEMP3 WHERE NEWSTATUS=274 

DECLARE COMPLETEDORDERS CURSOR FOR 
SELECT INDEXCODE,TENDERID FROM #TEMP3 WHERE NEWSTATUS IN (41)

OPEN COMPLETEDORDERS 
FETCH NEXT FROM COMPLETEDORDERS INTO @INDEXCODE,@TENDERID 

WHILE @@FETCH_STATUS=0 
BEGIN
  SELECT @TOOLCODE=RESCODE FROM TENDERITEMS WHERE ITEMID =@TENDERID 
  SELECT @ORDQTY=ORDQTY,@ORDRATE=ORDRATE,@ORDAMOUNT=ORDAMOUNT,@BORGID=BORGID,@DELIVEREDQTY=DELIVEREDQTY 
  FROM BT.MATERIALMOVEMENTDETAIL WHERE INDEXCODE=@INDEXCODE 

  SET @DIFFERENCEQTY = (@ORDQTY-@DELIVEREDQTY) 
  SET @DIFFERENCEAMOUNT = @DIFFERENCEQTY * @ORDRATE 

  SELECT @PROJECTID = PROJECTID FROM BT.PROJECTS WHERE BORGID=@BORGID 
  SELECT @MONTHLYMATERIALBUDGETCODE = MONTHLYMATERIALBUDGETCODE  FROM BT.MonthlyMaterialBudget 
         WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE  


  UPDATE BT.MonthlyMaterialBudget  SET CumulativeQty=CumulativeQty+@DIFFERENCEQTY  WHERE CATEGORYTYPE='Q' AND MonthlyMaterialBudgetCode=@MONTHLYMATERIALBUDGETCODE
  UPDATE BT.MonthlyMaterialBudget  SET BUDGETAMOUNT=BUDGETAMOUNT+@DIFFERENCEAMOUNT WHERE CATEGORYTYPE='L' AND MonthlyMaterialBudgetCode=@MONTHLYMATERIALBUDGETCODE
  UPDATE BT.MATERIALMOVEMENTDETAIL SET FINALIZATIONSTATUS=1    WHERE INDEXCODE=@INDEXCODE 
  

  FETCH NEXT FROM COMPLETEDORDERS INTO @INDEXCODE,@TENDERID
END 
 
DELETE FROM #TEMP3

CLOSE COMPLETEDORDERS
DEALLOCATE COMPLETEDORDERS


UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Awaiting Approval'  WHERE REQSTATUS=32 
UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Cancelled'  WHERE REQSTATUS=36 

UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Open'  WHERE REQSTATUS=163 
UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'PO Created'  WHERE REQSTATUS=173

UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Rejected'  WHERE REQSTATUS=202
UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Change Order '  WHERE REQSTATUS=500

UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Change Order Done'  WHERE REQSTATUS=501
UPDATE BT.MATERIALMOVEMENTDETAIL SET STATUS_REQ = 'Completed'  WHERE REQSTATUS=41

UPDATE BT.MATERIALMOVEMENTDETAIL SET REQNUMBER=REQ.REQNUMBER FROM REQ INNER JOIN BT.MATERIALMOVEMENTDETAIL ON BT.MATERIALMOVEMENTDETAIL.REQID=REQ.REQID 