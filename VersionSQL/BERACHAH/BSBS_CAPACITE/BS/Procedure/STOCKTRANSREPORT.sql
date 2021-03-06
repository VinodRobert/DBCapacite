/****** Object:  Procedure [BS].[STOCKTRANSREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[STOCKTRANSREPORT](@STORE VARCHAR(15),@STARTDATESTRING DATETIME, @ENDDATESTRING DATETIME)
AS

CREATE TABLE #TEMP1
(
 STORE       VARCHAR(15),
 STOCKCODE   VARCHAR(15),
 STOCKNAME   VARCHAR(150),
 UNIT        VARCHAR(15),
 OPENINGQTY  DECIMAL(18,4),
 OPENINGVAL  DECIMAL(18,2),
 RECEIPT     DECIMAL(18,4),
 RECEIPTVAL  DECIMAL(18,2),
 ISSUE       DECIMAL(18,4),
 ISSUEVAL    DECIMAL(18,2),
 CLOSINGQTY  DECIMAL(18,4),
 CLOSINGVAL  DECIMAL(18,2)
)

CREATE TABLE #ST (STOCKCODE VARCHAR(15) ) 


DECLARE @TRANSSTARTDATE    DATETIME
DECLARE @TRANSENDDATE      DATETIME
SELECT  @TRANSSTARTDATE = CONVERT(DATETIME, @STARTDATESTRING,103) -- dd/mm/yyyy 
SELECT  @TRANSENDDATE   = CONVERT(DATETIME, @ENDDATESTRING,103) -- dd/mm/yyyy 


SELECT STOCKCODE,SUM(INQTY-OUTQTY) OBQTY, SUM(INQTY*RATE-OUTQTY*RATE) OBVALUE INTO #OB  FROM BS.STOCKREPORT 
WHERE TRANSACTIONDATE <=@TRANSSTARTDATE  AND STORE=@STORE  GROUP BY STOCKCODE 
 

SELECT STOCKCODE,SUM(INQTY) INQTY, SUM(INQTY*RATE) INVALUE INTO #RECEIPT FROM BS.STOCKREPORT 
WHERE TRANSACTIONDATE >@TRANSSTARTDATE AND TRANSACTIONDATE <= @TRANSENDDATE  AND STORE=@STORE  GROUP BY STOCKCODE 


SELECT STOCKCODE,SUM(OUTQTY) OUTQTY, SUM(OUTQTY*RATE) OUTVALUE INTO #ISSUE FROM BS.STOCKREPORT 
WHERE TRANSACTIONDATE >@TRANSSTARTDATE AND TRANSACTIONDATE <= @TRANSENDDATE  AND STORE=@STORE  GROUP BY STOCKCODE 



INSERT INTO #ST 
SELECT DISTINCT STOCKCODE FROM 
 ( SELECT DISTINCT STOCKCODE FROM #OB 
  UNION
  SELECT DISTINCT STOCKCODE FROM #RECEIPT
  UNION
  SELECT DISTINCT STOCKCODE FROM #ISSUE ) T

INSERT INTO #TEMP1(STOCKCODE)
SELECT * FROM #ST 
 
 

UPDATE #TEMP1 SET OPENINGQTY = OBQTY, OPENINGVAL = OBVALUE FROM #OB      INNER JOIN #TEMP1 ON #TEMP1.STOCKCODE = #OB.STOCKCODE 
UPDATE #TEMP1 SET RECEIPT = INQTY , RECEIPTVAL = INVALUE   FROM #RECEIPT INNER JOIN #TEMP1 ON #TEMP1.STOCKCODE = #RECEIPT.STOCKCODE
UPDATE #TEMP1 SET ISSUE   = OUTQTY, ISSUEVAL   = OUTVALUE  FROM #ISSUE   INNER JOIN #TEMP1 ON #TEMP1.STOCKCODE = #ISSUE.STOCKCODE 

 
INSERT INTO #TEMP1(STOCKCODE,RECEIPT,RECEIPTVAL)
SELECT STOCKCODE,INQTY,INVALUE FROM #RECEIPT WHERE STOCKCODE NOT IN (SELECT STOCKCODE FROM #TEMP1 )

INSERT INTO #TEMP1(STOCKCODE,ISSUE,ISSUEVAL) 
SELECT STOCKCODE,OUTQTY,OUTVALUE FROM #ISSUE  WHERE STOCKCODE NOT IN (SELECT STOCKCODE FROM #TEMP1) 



UPDATE #TEMP1 SET OPENINGQTY = 0 WHERE OPENINGQTY IS NULL
UPDATE #TEMP1 SET OPENINGVAL = 0 WHERE OPENINGVAL IS NULL
UPDATE #TEMP1 SET RECEIPT    = 0 WHERE RECEIPT IS NULL
UPDATE #TEMP1 SET RECEIPTVAL = 0 WHERE RECEIPTVAL IS NULL
UPDATE #TEMP1 SET ISSUE      = 0 WHERE ISSUE IS NULL
UPDATE #TEMP1 SET ISSUEVAL   = 0 WHERE ISSUEVAL IS NULL

UPDATE #TEMP1 SET CLOSINGQTY = OPENINGQTY+RECEIPT-ISSUE
UPDATE #TEMP1 SET CLOSINGVAL =  OPENINGVAL + RECEIPTVAL - ISSUEVAL 
UPDATE #TEMP1 SET CLOSINGVAL = 0 WHERE CLOSINGQTY = 0 

UPDATE #TEMP1 SET STOCKNAME = STKDESC,UNIT=STKSELLUNIT  FROM INVENTORY INNER JOIN #TEMP1 ON  #TEMP1.STOCKCODE = INVENTORY.STKCODE AND INVENTORY.STKSTORE=@STORE 
UPDATE #TEMP1 SET STORE = @STORE 
SELECT * FROM #TEMP1 WHERE CLOSINGQTY<>0 ORDER BY STOCKCODE 
SELECT SUM(CLOSINGVAL) FROM #TEMP1 