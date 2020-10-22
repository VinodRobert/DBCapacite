/****** Object:  Procedure [BI].[spStockAging_190117]    Committed by VersionSQL https://www.versionsql.com ******/

 create procedure [BI].[spStockAging_190117](@CUTOFFDATE AS VARCHAR(15) , @LISTINVENTORY   LISTSTOCKITEMS READONLY , @LISTORGIDS  LISTORGIDS READONLY)
AS

CREATE TABLE #IPLA(LEDGERCODE VARCHAR(10))
INSERT INTO #IPLA 
SELECT ICGLCODE  FROM BORGS 
DELETE FROM #IPLA WHERE LEDGERCODE IS NULL

 

CREATE TABLE #STOCKS(STOCKCODE  VARCHAR(15))
INSERT INTO  #STOCKS  
SELECT STOCKNO FROM @LISTINVENTORY
DELETE FROM #STOCKS WHERE STOCKCODE IS NULL 

 
CREATE TABLE #BORGS(ORGID INT)
INSERT INTO #BORGS   
SELECT ORGID  FROM @LISTORGIDS
DELETE FROM #BORGS WHERE ORGID IS NULL





DECLARE @CUTDATE DATETIME
SELECT  @CUTDATE = CONVERT(DATETIME, @CUTOFFDATE,103)

DECLARE @YEAR INT
DECLARE @MONTH INT
DECLARE @FINYEAR INT
DECLARE @CUTOFFINYEAR INT 

DECLARE @PERIODSTART DATETIME
DECLARE @PERIODEND   DATETIME
DECLARE @DATESTRING VARCHAR(15)
DECLARE @YEARBEGIN DATETIME
DECLARE @YEAREND   DATETIME 

SELECT @YEAR = YEAR(@CUTDATE) 
SELECT @MONTH = MONTH(@CUTDATE)

SET @DATESTRING = '01/01/'+LTRIM(RTRIM(@YEAR)) 

SELECT @YEARBEGIN = CONVERT(DATETIME, @DATESTRING, 103) 
SET @DATESTRING = '31/03/'+LTRIM(RTRIM(@YEAR)) 
SELECT @YEAREND   = CONVERT(DATETIME ,@DATESTRING,103)


IF @CUTDATE>=@YEARBEGIN AND @CUTDATE<=@YEAREND 
   SET @CUTOFFINYEAR = @YEAR
ELSE
   SET @CUTOFFINYEAR = @YEAR+1

 

CREATE TABLE #STORES(STORECODE VARCHAR(15))
INSERT INTO #STORES 
SELECT DISTINCT STKSTORE FROM INVENTORY WHERE BORGID IN (SELECT ORGID FROM #BORGS)  AND LEFT(STKSTORE,4)='MS-9'


DECLARE @STORECODE VARCHAR(15)
-- GET THE LIVE STOCK
SELECT STKSTORE,STKCODE,STKDESC,STKUNIT,ISNULL(STKQUANTITY,0) LIVESTOCK ,ISNULL(STKCOSTRATE,0) STKCOSTRATE ,ISNULL( (STKQUANTITY*STKCOSTRATE),0 )  LIVESTOCKVALUE, STKID,BORGID
INTO #TEMP0 
FROM INVENTORY 
WHERE STKSTORE IN (SELECT STORECODE FROM #STORES )  AND STKCODE IN (SELECT STOCKCODE FROM #STOCKS) 

--SELECT * FROM #TEMP0 
 
 
-- GET ALL XFRS 
SELECT STORE,STOCKNO,QUANTITY,UNIT,RATE,DEBIT,CREDIT,ORGID  
INTO #TEMPXFR
FROM TRANSACTIONS 
WHERE 
PDATE >@CUTDATE AND 
      STORE IN (SELECT STORECODE FROM #STORES) AND 
	  STOCKNO IN (SELECT STOCKCODE FROM #STOCKS) AND 
	  ORGID IN (SELECT ORGID FROM #BORGS)  AND
	  TRANSTYPE = 'XFR' AND 
	  LEDGERCODE NOT IN (SELECT LEDGERCODE FROM #IPLA) 

 

SELECT ORGID,STORE,STOCKNO,SUM(QUANTITY) PLUSQTY ,SUM(DEBIT) PLUSVALUE INTO #XFRPLUS FROM #TEMPXFR WHERE QUANTITY>0  GROUP BY ORGID,STORE,STOCKNO
 
SELECT ORGID,STORE,STOCKNO,SUM(QUANTITY) MINUSQTY, SUM(CREDIT) MINUSVALUE INTO #XFRMINUS FROM #TEMPXFR WHERE QUANTITY<0 GROUP BY ORGID,STORE,STOCKNO 
 

ALTER TABLE #XFRPLUS ADD STKID INT 
ALTER TABLE #XFRMINUS ADD STKID INT 
UPDATE #XFRPLUS  SET STKID = INV.STKID FROM INVENTORY INV INNER JOIN #XFRPLUS ON #XFRPLUS.STOCKNO = INV.STKCODE  AND #XFRPLUS.STORE = INV.STKSTORE  
UPDATE #XFRMINUS SET STKID = INV.STKID FROM INVENTORY INV INNER JOIN #XFRPLUS ON #XFRPLUS.STOCKNO = INV.STKCODE  AND #XFRPLUS.STORE = INV.STKSTORE  
 
 


--GET ALL THE DELIVERIES 
SELECT  DLVRQTY,DLVRDATE,ORDID,ORDITEMLINENO,TBORGID,PRICE,(DLVRQTY*PRICE) DLVRAMOUNT
INTO #TEMPDELIVERY 
FROM DELIVERIES
WHERE TBORGID IN (SELECT ORGID FROM #BORGS) 

 

ALTER TABLE #TEMPDELIVERY ADD STKID INT
UPDATE #TEMPDELIVERY SET STKID=OI.STOCKID FROM ORDITEMS OI INNER JOIN #TEMPDELIVERY T ON T.ORDID=OI.ORDID AND T.ORDITEMLINENO=OI.LINENUMBER
ALTER TABLE #TEMPDELIVERY ADD STOCKCODE VARCHAR(15)
UPDATE #TEMPDELIVERY SET STOCKCODE = OI.BUYERPARTNUMBER  FROM ORDITEMS OI INNER JOIN #TEMPDELIVERY T ON T.ORDID= OI.ORDID AND T.ORDITEMLINENO = OI.LINENUMBER 
DELETE FROM #TEMPDELIVERY WHERE STKID=-1
DELETE FROM #TEMPDELIVERY	WHERE STOCKCODE NOT IN (SELECT  STOCKCODE FROM #STOCKS) 


INSERT INTO #TEMPDELIVERY(DLVRQTY,TBORGID,DLVRAMOUNT,STKID,STOCKCODE,DLVRDATE,ORDID,ORDITEMLINENO,PRICE) 
SELECT PLUSQTY,ORGID,PLUSVALUE,STKID,STOCKNO,GETDATE(),0,0,0 FROM #XFRPLUS


 
--GET SUM OF DELIVERIES HAPPENED BETWEEN CUTOFF DATE AND CURRENT DATE
SELECT STKID,SUM(DLVRQTY) DELIVERYQTY,SUM(DLVRAMOUNT) DELIVERYAMOUNT 
INTO #PERIODDELIVERY
FROM #TEMPDELIVERY
WHERE DLVRDATE >@CUTDATE 
GROUP BY STKID 

 



ALTER TABLE #TEMP0  ADD PERIODDELIVERY DECIMAL(18,2) 
ALTER TABLE #TEMP0  ADD PERIODAMOUNT   DECIMAL(18,2)
UPDATE #TEMP0 SET PERIODDELIVERY=0.0, PERIODAMOUNT = 0.0
UPDATE #TEMP0 SET PERIODDELIVERY = P.DELIVERYQTY, PERIODAMOUNT = P.DELIVERYAMOUNT  
FROM #PERIODDELIVERY P INNER JOIN #TEMP0 ON #TEMP0.STKID = P.STKID


 


-- INCORPORATING XFR INTO ISSUE
UPDATE #PERIODDELIVERY 
SET DELIVERYQTY	= DELIVERYQTY	+ X.PLUSQTY , DELIVERYAMOUNT= DELIVERYAMOUNT+X.PLUSVALUE 
FROM #PERIODDELIVERY INNER JOIN #XFRPLUS X ON X.STKID = #PERIODDELIVERY.STKID 


 

-- GET STOCK ISSUE BETWEEN CUTOFFDATE AND LIVE DATE 
SELECT ORGID,STOCKNO,QUANTITY ,(CREDIT-DEBIT) AMOUNT
INTO #PERIODISSUE
FROM TRANSACTIONS 
WHERE ORGID IN (SELECT  ORGID FROM #BORGS)  AND LEFT(TRANSTYPE,3) IN ('SIC','SSR') AND STORE IN (SELECT STORECODE FROM #STORES) 
AND PDATE>@CUTDATE  AND YEAR>=@CUTOFFINYEAR AND ALLOCATION='Balance Sheet' AND LEDGERCODE <> '2990000' AND STOCKNO IN (SELECT STOCKCODE FROM #STOCKS)
 

INSERT INTO #PERIODISSUE(ORGID,STOCKNO,QUANTITY,AMOUNT) 
SELECT  ORGID, STOCKNO, MINUSQTY ,MINUSVALUE     FROM #XFRMINUS

 

SELECT ORGID,STOCKNO,SUM(QUANTITY) ISSUEQTY,SUM(AMOUNT) ISSUEAMOUNT 
INTO  #ISSUEDETAILS
FROM #PERIODISSUE 
GROUP BY STOCKNO,ORGID 

 


ALTER TABLE #TEMP0 ADD PERIODISSUE DECIMAL(18,2)
ALTER TABLE #TEMP0 ADD ISSUEAMOUNT DECIMAL(18,2) 
UPDATE #TEMP0 SET PERIODISSUE = 0.0 ,ISSUEAMOUNT = 0.0

UPDATE #TEMP0 SET PERIODISSUE = ABS(P.ISSUEQTY) ,ISSUEAMOUNT =ABS(P.ISSUEAMOUNT) FROM #ISSUEDETAILS P INNER JOIN #TEMP0 ON #TEMP0.STKCODE = P.STOCKNO 

ALTER TABLE #PERIODISSUE ADD STKID INT

UPDATE #PERIODISSUE SET STKID = INV.STKID FROM INVENTORY INV INNER JOIN #PERIODISSUE ON #PERIODISSUE.OrgID = INV.BORGID AND #PERIODISSUE.Stockno=INV.STKCODE 
 
 


 
-- OBQTY is the Opening Quantity as on the Cut off Date 

ALTER TABLE #TEMP0 ADD OB_0_QTY   DECIMAL(18,2)
ALTER TABLE #TEMP0 ADD OB_0_VALUE DECIMAL(18,2) 

UPDATE #TEMP0 SET OB_0_QTY=0.0,OB_0_VALUE = 0.0
UPDATE #TEMP0 SET OB_0_QTY = LIVESTOCK-PERIODDELIVERY+PERIODISSUE  , OB_0_VALUE = LIVESTOCKVALUE-PERIODAMOUNT+ISSUEAMOUNT 


 

SELECT * 
INTO #TEMP1 
FROM #TEMP0 
WHERE OB_0_QTY>0


DELETE FROM #TEMPDELIVERY WHERE DLVRDATE >=@CUTDATE 



SET @PERIODEND = @CUTDATE 
SET @PERIODSTART   = @PERIODEND-30



SELECT STKID,SUM(DLVRQTY) DELIVERYQTY ,SUM(DLVRAMOUNT) DELIVERYAMOUNT 
INTO #ZT_DELIVERY
FROM #TEMPDELIVERY
WHERE DLVRDATE > @PERIODSTART  AND  DLVRDATE<= @PERIODEND 
GROUP BY STKID 

ALTER TABLE #TEMP1 ADD ZT_DELIVERY  DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD ZTV_DELIVERY DECIMAL(18,2)
UPDATE #TEMP1 SET ZT_DELIVERY=0,ZTV_DELIVERY=0
UPDATE #TEMP1 SET ZT_DELIVERY = T.DELIVERYQTY ,ZTV_DELIVERY = T.DELIVERYAMOUNT  
FROM #ZT_DELIVERY T INNER JOIN #TEMP1 ON #TEMP1.STKID = T.STKID

 

SET @PERIODEND  = @PERIODSTART
SET @PERIODSTART   = @PERIODEND-90 

SELECT STKID,SUM(DLVRQTY) DELIVERYQTY ,SUM(DLVRAMOUNT) DELIVERYAMOUNT 
INTO #TN_DELIVERY
FROM #TEMPDELIVERY
WHERE DLVRDATE > @PERIODSTART  AND  DLVRDATE<= @PERIODEND 
GROUP BY STKID 
 


ALTER TABLE #TEMP1 ADD TN_DELIVERY   DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD TNV_DELIVERY  DECIMAL(18,2)
UPDATE #TEMP1 SET TN_DELIVERY=0,TNV_DELIVERY=0
UPDATE #TEMP1 SET TN_DELIVERY = T.DELIVERYQTY ,TNV_DELIVERY = T.DELIVERYAMOUNT  
FROM #TN_DELIVERY T INNER JOIN #TEMP1 ON #TEMP1.STKID = T.STKID


SET @PERIODEND     = @PERIODSTART
SET @PERIODSTART   = @PERIODEND-180

SELECT STKID,SUM(DLVRQTY) DELIVERYQTY ,SUM(DLVRAMOUNT) DELIVERYAMOUNT 
INTO #NG_DELIVERY
FROM #TEMPDELIVERY
WHERE DLVRDATE > @PERIODSTART  AND  DLVRDATE<= @PERIODEND 
GROUP BY STKID 
 

ALTER TABLE #TEMP1 ADD NG_DELIVERY DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD NGV_DELIVERY  DECIMAL(18,2)
UPDATE #TEMP1 SET NG_DELIVERY=0,NGV_DELIVERY=0
UPDATE #TEMP1 SET NG_DELIVERY = T.DELIVERYQTY ,NGV_DELIVERY = T.DELIVERYAMOUNT  
FROM #NG_DELIVERY T INNER JOIN #TEMP1 ON #TEMP1.STKID = T.STKID

 

-- Adding New Buckets 2
ALTER TABLE #TEMP1 ADD AGEBUCKET_0_30       DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD AGEBUCKET_0_30_VALUE DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD OB_31_QTY    DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD OB_31_VALUE  DECIMAL(18,2) 
UPDATE #TEMP1 SET AGEBUCKET_0_30=0,AGEBUCKET_0_30_VALUE=0,OB_31_QTY=0,OB_31_VALUE=0
UPDATE #TEMP1 SET AGEBUCKET_0_30 = ZT_DELIVERY , AGEBUCKET_0_30_VALUE = ZTV_DELIVERY     WHERE OB_0_QTY> ZT_DELIVERY
UPDATE #TEMP1 SET AGEBUCKET_0_30 = OB_0_QTY    , AGEBUCKET_0_30_VALUE = OB_0_VALUE       WHERE OB_0_QTY<=ZT_DELIVERY
UPDATE #TEMP1 SET OB_31_QTY    = OB_0_QTY   - AGEBUCKET_0_30 
UPDATE #TEMP1 SET OB_31_VALUE  = OB_0_VALUE - AGEBUCKET_0_30_VALUE


      
-- Adding New Buckets 3 (30-90)
ALTER TABLE #TEMP1 ADD AGEBUCKET_30_90       DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD AGEBUCKET_30_90_VALUE DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD OB_91_QTY    DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD OB_91_VALUE  DECIMAL(18,2) 
UPDATE #TEMP1 SET AGEBUCKET_30_90=0,AGEBUCKET_30_90_VALUE=0,OB_91_QTY=0,OB_91_VALUE=0
UPDATE #TEMP1 SET AGEBUCKET_30_90 = TN_DELIVERY , AGEBUCKET_30_90_VALUE  = TNV_DELIVERY      WHERE OB_31_QTY> TN_DELIVERY
UPDATE #TEMP1 SET AGEBUCKET_30_90 = OB_31_QTY   , AGEBUCKET_30_90_VALUE  = OB_31_VALUE       WHERE OB_31_QTY<=TN_DELIVERY
UPDATE #TEMP1 SET OB_91_QTY    = OB_31_QTY   - AGEBUCKET_30_90 
UPDATE #TEMP1 SET OB_91_VALUE  = OB_31_VALUE - AGEBUCKET_30_90_VALUE

                      

-- Adding New Buckets 3 (91-180)
ALTER TABLE #TEMP1 ADD AGEBUCKET_91_180       DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD AGEBUCKET_91_180_VALUE DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD OB_181_QTY   DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD OB_181_VALUE DECIMAL(18,2) 
UPDATE #TEMP1 SET AGEBUCKET_91_180=0,AGEBUCKET_91_180_VALUE=0,OB_181_QTY=0,OB_181_VALUE=0
UPDATE #TEMP1 SET AGEBUCKET_91_180 = NGV_DELIVERY , AGEBUCKET_91_180_VALUE = NGV_DELIVERY   WHERE OB_91_QTY>  NGV_DELIVERY
UPDATE #TEMP1 SET AGEBUCKET_91_180 = OB_91_QTY    , AGEBUCKET_91_180_VALUE = OB_91_VALUE    WHERE OB_91_QTY<= NGV_DELIVERY
UPDATE #TEMP1 SET OB_181_QTY    = OB_91_QTY   - AGEBUCKET_91_180 
UPDATE #TEMP1 SET OB_181_VALUE  = OB_91_VALUE - AGEBUCKET_91_180_VALUE




-- Age Between >180 Days & New Buckets
ALTER TABLE #TEMP1 ADD AGEBUCKET_ABOVE_180       DECIMAL(18,2)
ALTER TABLE #TEMP1 ADD AGEBUCKET_ABOVE_180_VALUE DECIMAL(18,2)
UPDATE #TEMP1 SET AGEBUCKET_ABOVE_180=0,AGEBUCKET_ABOVE_180_VALUE=0 
UPDATE #TEMP1 SET AGEBUCKET_ABOVE_180 = OB_181_QTY  , AGEBUCKET_ABOVE_180_VALUE = OB_181_VALUE  WHERE OB_181_QTY> 0
UPDATE #TEMP1 SET AGEBUCKET_ABOVE_180 = 0           , AGEBUCKET_ABOVE_180_VALUE = 0             WHERE OB_181_QTY<=0



-- Final Bucket 
 
SELECT 
 STKSTORE,STKCODE,STKDESC,STKUNIT,OB_0_QTY,OB_0_VALUE,AGEBUCKET_0_30,AGEBUCKET_0_30_VALUE,AGEBUCKET_30_90,AGEBUCKET_30_90_VALUE,
 AGEBUCKET_91_180,AGEBUCKET_91_180_VALUE,AGEBUCKET_ABOVE_180,AGEBUCKET_ABOVE_180_VALUE 
FROM 
 #TEMP1 