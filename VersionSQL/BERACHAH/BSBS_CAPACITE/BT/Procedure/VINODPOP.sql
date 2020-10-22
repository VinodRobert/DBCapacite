/****** Object:  Procedure [BT].[VINODPOP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[VINODPOP] 
AS
 
--SELECT REQID,LINENUMBER,CATALOGITEMID,BUYERPARTNUMBER,UOM,QTY,PRICE,RESOURCECODE,STOCKID,ITEMDESCRIPTION
--INTO #TEMP0
--FROM REQITEMS WHERE CATALOGITEMID NOT IN (0,-1) ORDER BY REQID DESC

 
--ALTER TABLE #TEMP0 ADD BORGID INT 
--ALTER TABLE #TEMP0 ADD REQNUMBER VARCHAR(35)
--ALTER TABLE #TEMP0 ADD REQSTATUSID INT 
--ALTER TABLE #TEMP0 ADD CREATEDATE DATETIME 
--ALTER TABLE #TEMP0 ADD RECTYPE VARCHAR(15)
--ALTER TABLE #TEMP0 ADD TENDERITEMID INT
--ALTER TABLE #TEMP0 ADD TENDERITEMNAME VARCHAR(600)
--ALTER TABLE #TEMP0 ADD PROJECTCODE INT
--ALTER TABLE #TEMP0 ADD HEADERID INT
--ALTER TABLE #TEMP0 ADD TOOLCODE VARCHAR(25)
--ALTER TABLE #TEMP0 ADD TOOLNAME VARCHAR(200)


--UPDATE #TEMP0 SET BORGID=R.BORGID,
--                  REQNUMBER=R.REQNUMBER,
--				  REQSTATUSID=R.REQSTATUSID,
--				  CREATEDATE=R.CREATEDATE ,
--				  RECTYPE=R.RECTYPE
--		FROM REQ R
--		INNER JOIN #TEMP0 ON #TEMP0.REQID = R.REQID 

--DELETE FROM #TEMP0 WHERE RECTYPE<>'STD'

--UPDATE #TEMP0 SET TENDERITEMID=T.ITEMID,
--                  TENDERITEMNAME =SUBSTRING(T.DESCR ,1,200)
--		FROM TENDERITEMS T 
--		INNER JOIN #TEMP0 ON #TEMP0.CATALOGITEMID=T.ITEMID 


--UPDATE #TEMP0 SET PROJECTCODE = BT.PROJECTID 
--		FROM BT.PROJECTS BT 
--		INNER JOIN #TEMP0 ON #TEMP0.BORGID = BT.BorgID


--UPDATE #TEMP0 SET HEADERID = H.HEADERID,
--                  TOOLCODE = H.TOOLCODE,
--				  TOOLNAME = H.TOOLNAME 
--		FROM BT.BUDGETMATERAILMOVEMENTHEAD H
--		INNER JOIN #TEMP0 ON #TEMP0.PROJECTCODE = H.PROJECTCODE AND #TEMP0.RESOURCECODE=H.TOOLCODE 

--DELETE FROM #TEMP0 WHERE BORGID IN (65,118,158,164)
----SELECT * FROM #TEMP0 ORDER BY PROJECTCODE 
--DELETE FROM #TEMP0 WHERE HEADERID IS NULL

--SELECT HEADERID,
--       TOOLCODE,
--	   RESOURCECODE,
--	   TOOLNAME,
--	   TENDERITEMNAME,
--	   BORGID,
--	   PROJECTCODE,
--	   REQID,
--	   REQNUMBER,
--	   CREATEDATE,
--	   REQSTATUSID,
--	   LINENUMBER,
--	   STOCKID,
--	   BUYERPARTNUMBER,
--	   ITEMDESCRIPTION,
--	   QTY,
--	   PRICE,
--	   UOM,
--	   CATALOGITEMID,
--	   TENDERITEMID 
--	FROM #TEMP0  WHERE REQSTATUSID=36
--	ORDER BY HEADERID 

--SELECT DISTINCT REQSTATUSID FROM #TEMP0 
 
--DELETE FROM BT.BUDGETMATERIALMOVEMENTDETAIL
--DBCC CHECKIDENT( '[BT].[BUDGETMATERIALMOVEMENTDETAIL]',RESEED)
--INSERT INTO BT.BUDGETMATERIALMOVEMENTDETAIL(HEADERID,REQID,REQDATE,REQNUMBER,LINENUMBER,STOCKCODE,STOCKNAME,PRQTY,PRRATE,PRAMOUNT,PRSTATUS,FINALIZED)
--SELECT HEADERID,REQID,CREATEDATE,REQNUMBER,LINENUMBER,BUYERPARTNUMBER,UPPER(ITEMDESCRIPTION),QTY,PRICE,(QTY*PRICE),REQSTATUSID,2 FROM #TEMP0 ORDER BY PROJECTCODE,REQID  
--UPDATE BT.BUDGETMATERIALMOVEMENTDETAIL SET CANCELLEDQTY=0,REJECTQTY=0
--SELECT * FROM BT.BUDGETMATERIALMOVEMENTDETAIL




-- FROM PR TO ORDER 
--SELECT DETAILID, REQID,LINENUMBER INTO #TEMP2 FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PRSTATUS=173
--ALTER TABLE #TEMP2 ADD ORDID INT
--ALTER TABLE #TEMP2 ADD ORDNUMBER VARCHAR(25)
--ALTER TABLE #TEMP2 ADD ORDDATE DATETIME
--ALTER TABLE #TEMP2 ADD ORDQTY DECIMAL(18,4)
--ALTER TABLE #TEMP2 ADD ORDRATE DECIMAL(18,4)
--ALTER TABLE #TEMP2 ADD ORDAMOUNT DECIMAL(18,4) 
--ALTER TABLE #TEMP2 ADD ORDSTATUS INT

--UPDATE #TEMP2 
--   SET ORDID = O.ORDID ,
--       ORDNUMBER = O.ORDNUMBER,
--	   ORDDATE = O.CREATEDATE ,
--	   ORDSTATUS = O.ORDSTATUSID
--   FROM ORD O 
--   INNER JOIN #TEMP2 ON #TEMP2.REQID = O.REQID 



--UPDATE #TEMP2 
--   SET ORDQTY = OI.QTY ,
--       ORDRATE = OI.PRICE,
--	   ORDAMOUNT = OI.QTY*OI.PRICE 
--   FROM ORDITEMS OI
--   INNER JOIN #TEMP2 ON #TEMP2.ORDID = OI.ORDID AND #TEMP2.LINENUMBER = OI.LINENUMBER 

--UPDATE BT.BUDGETMATERIALMOVEMENTDETAIL
--  SET ORDNUMBER = T.ORDNUMBER,
--      ORDID=T.ORDID ,
--      ORDDATE = T.ORDDATE,
--	  ORDQTY =T.ORDQTY,
--	  ORDRATE = T.ORDRATE,
--	  ORDAMOUNT = T.ORDAMOUNT,
--	  ORDSTATUS = T.ORDSTATUS 
--  FROM #TEMP2 T
--  INNER JOIN BT.BUDGETMATERIALMOVEMENTDETAIL  
--  ON BT.BUDGETMATERIALMOVEMENTDETAIL.DETAILID = T.DETAILID  
 

--SELECT * FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PRPOQTYDIFF<>0

--UPDATE BT.BUDGETMATERIALMOVEMENTDETAIL
--SET PRPOQTYDIFF = (PRQTY-ORDQTY) WHERE PRSTATUS=173
DECLARE @DETAILID INT 
DECLARE @DELIVERYQTY DECIMAL(18,4) 
DECLARE @DELIVERYAMOUNT DECIMAL(18,4) 
DECLARE @ORDID INT
DECLARE @LINENUMBER INT 
SELECT DETAILID, ORDID,LINENUMBER INTO #TEMPD  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE ORDSTATUS IN (41,274)
ALTER TABLE #TEMPD ADD DELIVERYQTY DECIMAL(18,4) 
ALTER TABLE #TEMPD ADD DELIVERYAMOUNT  DECIMAL(18,4) 
DECLARE DLVRYLIST CURSOR FOR SELECT DETAILID,ORDID,LINENUMBER FROM #TEMPD 
OPEN DLVRYLIST 
FETCH NEXT FROM DLVRYLIST INTO @DETAILID, @ORDID,@LINENUMBER 

WHILE @@FETCH_STATUS =0
BEGIN
  SELECT @DELIVERYQTY=SUM(DLVRQTY), @DELIVERYAMOUNT= SUM(DLVRQTY*PRICE)  FROM DELIVERIES WHERE ORDID=@ORDID AND ORDITEMLINENO = @LINENUMBER 
  UPDATE #TEMPD SET DELIVERYQTY = @DELIVERYQTY ,DELIVERYAMOUNT = @DELIVERYAMOUNT WHERE ORDID=@ORDID AND LINENUMBER=@LINENUMBER 
  FETCH NEXT FROM DLVRYLIST INTO @DETAILID, @ORDID,@LINENUMBER 

END 
CLOSE DLVRYLIST
DEALLOCATE DLVRYLIST

UPDATE BT.BUDGETMATERIALMOVEMENTDETAIL 
SET DELIVEREDQTY=D.DELIVERYQTY,DELIVERYAMOUNT=D.DELIVERYAMOUNT 
FROM #TEMPD D INNER JOIN BT.BUDGETMATERIALMOVEMENTDETAIL  ON BT.BUDGETMATERIALMOVEMENTDETAIL.DETAILID=D.DETAILID 

 

SELECT * FROM DELIVERIES