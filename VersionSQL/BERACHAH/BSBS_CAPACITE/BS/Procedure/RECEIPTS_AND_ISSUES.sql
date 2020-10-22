/****** Object:  Procedure [BS].[RECEIPTS_AND_ISSUES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[RECEIPTS_AND_ISSUES](@STORECODE VARCHAR(15),@STARTPERIOD INT, @ENDPERIOD INT ,@FINYEAR INT) 
AS
 

DECLARE @STORELEDGERCODE VARCHAR(10)
SELECT @STORELEDGERCODE = STKCTL FROM INVSTORES WHERE STORECODE = @STORECODE 

DECLARE @STOREBORG INT
SELECT TOP 1 @STOREBORG=  BORGID FROM INVENTORY WHERE STKSTORE= @STORECODE 



DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)


SET @FILENAME = 'BSBS_TEMP.DBO.RECEIPTISSUE'




CREATE TABLE #MOVEMENT(ID INT PRIMARY KEY IDENTITY(1,1) ,TRANSID INT,  MATERIALCODE VARCHAR(15), MATERIALNAME VARCHAR(250),RECEIPT DECIMAL(18,4),RECEIPTVALUE MONEY, ISSUES DECIMAL(18,4),ISSUEVALUE MONEY,TRANSTYPE VARCHAR(10)) 

INSERT INTO #MOVEMENT(TRANSID,MATERIALCODE,RECEIPT,RECEIPTVALUE,TRANSTYPE) 
SELECT TRANSID,STOCKNO,QUANTITY,(DEBIT-CREDIT),TRANSTYPE FROM TRANSACTIONS WHERE STORE=@STORECODE AND YEAR=@FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD  AND 
TRANSTYPE IN ('DEL' ,'STW') AND LEDGERCODE = @STORELEDGERCODE

INSERT INTO #MOVEMENT(TRANSID,MATERIALCODE,RECEIPT,RECEIPTVALUE,TRANSTYPE) 
SELECT TRANSID,STOCKNO,QUANTITY,(DEBIT-CREDIT),TRANSTYPE FROM TRANSACTIONS WHERE STORE=@STORECODE AND YEAR=@FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD  AND 
TRANSTYPE = 'XFR' AND QUANTITY>0 AND LEDGERCODE = @STORELEDGERCODE


INSERT INTO #MOVEMENT(TRANSID,MATERIALCODE,ISSUES,ISSUEVALUE,TRANSTYPE) 
SELECT TRANSID,STOCKNO,QUANTITY,(DEBIT-CREDIT),TRANSTYPE FROM TRANSACTIONS WHERE STORE=@STORECODE AND YEAR=@FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD AND 
TRANSTYPE IN ('SIC' ,'SIB','SIS','SRB', 'SSR','STB') AND LEDGERCODE = @STORELEDGERCODE
UPDATE #MOVEMENT SET ISSUES = -1*ISSUES WHERE TRANSTYPE= 'STB'

INSERT INTO #MOVEMENT(TRANSID,MATERIALCODE,ISSUES,ISSUEVALUE,TRANSTYPE) 
SELECT TRANSID,STOCKNO,QUANTITY,(DEBIT-CREDIT),TRANSTYPE FROM TRANSACTIONS WHERE STORE=@STORECODE AND YEAR=@FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD AND 
TRANSTYPE = 'XFR'  AND Quantity < 0 AND LEDGERCODE = @STORELEDGERCODE

SELECT (D.DLVRQTY-D.RECONQTY) BALANCEQTY,D.ORDID,D.ORDITEMLINENO,D.TBORGID,OI.BUYERPARTNUMBER,D.PRICE
INTO #TEMP0 
FROM DELIVERIES D INNER JOIN ORDITEMS OI ON D.ORDID=OI.ORDID AND D.ORDITEMLINENO= OI.LINENUMBER 
INNER JOIN ORD O ON O.ORDID = D.ORDID 
WHERE  ABS(D.DLVRQTY - D.RECONQTY) > 0 AND D.ALLOCATED = 0 AND O.RECTYPE='STD' AND D.TBORGID = @STOREBORG AND
LYEAR=@FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD
 

DELETE FROM #TEMP0 WHERE BUYERPARTNUMBER  = '' 

INSERT INTO #MOVEMENT(TRANSID,MATERIALCODE,RECEIPT,RECEIPTVALUE) 
SELECT 99999999,BUYERPARTNUMBER,BALANCEQTY,BALANCEQTY*PRICE FROM #TEMP0 


UPDATE #MOVEMENT SET MATERIALNAME = INV.STKDESC FROM INVENTORY INV INNER JOIN #MOVEMENT ON #MOVEMENT.MATERIALCODE = INV.STKCODE WHERE INV.STKSTORE='VMAINSTORE'

UPDATE #MOVEMENT SET RECEIPT=0 ,RECEIPTVALUE = 0 WHERE RECEIPT IS NULL
UPDATE #MOVEMENT SET ISSUES =0, ISSUEVALUE  = 0 WHERE ISSUES IS NULL


 

SELECT MATERIALCODE,MATERIALNAME,SUM(RECEIPT) RECEIPT, SUM(RECEIPTVALUE) RECEIPTVALUE, SUM(ISSUES) ISSUES, SUM(ISSUEVALUE) ISSUEVALUE 
INTO #FINAL
FROM #MOVEMENT 
GROUP BY MATERIALCODE,MATERIALNAME

ALTER TABLE #FINAL ADD UOM VARCHAR(10)
UPDATE #FINAL SET UOM=STKUNIT  FROM INVENTORY INNER JOIN #FINAL ON #FINAL.MATERIALCODE = INVENTORY.STKCODE WHERE INVENTORY.STKSTORE = @STORECODE 

ALTER TABLE #FINAL ADD STORENAME VARCHAR(100)
DECLARE @STORENAME VARCHAR(50)
SELECT @STORENAME = STORENAME  FROM INVSTORES WHERE STORECODE   = @STORECODE 
UPDATE #FINAL SET STORENAME = LTRIM(RTRIM(@STORECODE)) + '-' + LTRIM(RTRIM(@STORENAME)) 

ALTER TABLE #FINAL ADD STARTDATE VARCHAR(15)
ALTER TABLE #FINAL ADD ENDDATE VARCHAR(15)
ALTER TABLE #FINAL ADD FINYEAR VARCHAR(10)

UPDATE #FINAL SET STARTDATE = (SELECT PERIODDESC FROM PERIODMASTER WHERE PERIODID = @STARTPERIOD ) 
UPDATE #FINAL SET ENDDATE  = (SELECT PERIODDESC FROM PERIODMASTER WHERE PERIODID = @ENDPERIOD ) 
UPDATE #FINAL SET FINYEAR =STR(@FINYEAR ,4) 
UPDATE #FINAL SET MATERIALNAME=UPPER(MATERIALNAME),ISSUES = ABS(ISSUES) , ISSUEVALUE = ABS(ISSUEVALUE)


DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT
 
SET @Lower = 1 ---- The lowest random number
SET @Upper = 9999 ---- The highest random number
SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)

SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
	+ (DATEPART(ss, GETDATE()) * 1000 )
	+ DATEPART(ms, GETDATE()) )*1000) + STR(@RANDOM) 

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(6),@FILEID)))

SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #FINAL ORDER BY MATERIALCODE     '
 
SELECT @FILENAME

EXEC(@SQL)

RETURN @FILEID
 