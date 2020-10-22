/****** Object:  Procedure [BS].[spBalanceSheet]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spBalanceSheet](@YEAR INT,@UPTOPERIOD INT, @BORGID INT,@ZONE INT)
AS

DECLARE @BORGTEXT VARCHAR(100)
DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
SET @FILENAME = 'BSBS_TEMP.DBO.CAPBALSHEET'

-- Extract Ledgers part of Balance Sheet
SELECT 
 L.BSHEET,
 L.LEDGERCODE,
 L.LEDGERNAME 
INTO #LEDGERNAME
FROM 
 LEDGERCODES L
WHERE 
 L.LedgerAlloc = 'Balance Sheet' AND
 L.LEDGERSUMMARY = 0 AND
 L.BSHEET <>''


CREATE TABLE #TRANSLISTING ( LEDGERCODE VARCHAR(10), DEBIT MONEY, CREDIT MONEY, CURRENCY VARCHAR(15), HOMECURRAMOUNT MONEY ) 
CREATE TABLE #TRANSLISTINGLASTYEAR ( LEDGERCODE VARCHAR(10), DEBIT MONEY, CREDIT MONEY, CURRENCY VARCHAR(15), HOMECURRAMOUNT MONEY ) 

-- Extract all Transactions for Chaning the Currency Values For This Year and Last Year
IF @ZONE = 1
 BEGIN
    INSERT INTO #TRANSLISTING 
    SELECT LEDGERCODE,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT
    FROM TRANSACTIONS 
    WHERE YEAR=@YEAR AND PERIOD <= @UPTOPERIOD AND ORGID = @BORGID AND LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERNAME ) 

	INSERT INTO #TRANSLISTINGLASTYEAR
	SELECT LEDGERCODE,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT
    FROM TRANSACTIONS 
    WHERE YEAR=@YEAR-1 AND PERIOD <= @UPTOPERIOD AND ORGID = @BORGID AND LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERNAME ) 

	SELECT @BORGTEXT = BORGNAME FROM BORGS WHERE BORGID = @BORGID 

 END
ELSE 
 BEGIN
   IF @ZONE =0 
     BEGIN
	    SELECT @BORGTEXT  = 'CIPL Consolidated'
	    INSERT INTO #TRANSLISTING 
        SELECT LEDGERCODE,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT
		FROM TRANSACTIONS 
		WHERE YEAR=@YEAR AND PERIOD <= @UPTOPERIOD AND   LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERNAME ) AND
		ORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG BETWEEN 23 AND 26 )

		INSERT INTO #TRANSLISTINGLASTYEAR
		SELECT LEDGERCODE,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT
		FROM TRANSACTIONS 
		WHERE YEAR=@YEAR-1 AND PERIOD <= @UPTOPERIOD   AND LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERNAME ) AND
		ORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG BETWEEN 23 AND 26 )
    END   
   ELSE
    BEGIN
	    SELECT @BORGTEXT = ( SELECT BORGNAME FROM BORGS WHERE BORGID = @ZONE ) 
	    INSERT INTO #TRANSLISTING 
	    SELECT LEDGERCODE,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT
		FROM TRANSACTIONS 
		WHERE YEAR=@YEAR AND PERIOD <= @UPTOPERIOD AND   LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERNAME ) AND
		ORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG =@ZONE  )

		INSERT INTO #TRANSLISTINGLASTYEAR
		SELECT LEDGERCODE,DEBIT,CREDIT,CURRENCY,HOMECURRAMOUNT
		FROM TRANSACTIONS 
		WHERE YEAR=@YEAR-1 AND PERIOD <= @UPTOPERIOD   AND LEDGERCODE IN (SELECT LEDGERCODE FROM #LEDGERNAME ) AND
		ORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG =@ZONE  )
	END
 END



 
UPDATE #TRANSLISTING 
SET DEBIT=HOMECURRAMOUNT 
WHERE DEBIT>0 AND CURRENCY <> 'INR'
UPDATE #TRANSLISTING 
SET CREDIT = HOMECURRAMOUNT 
WHERE CREDIT>0 AND CURRENCY <> 'INR'



UPDATE #TRANSLISTINGLASTYEAR 
SET DEBIT=HOMECURRAMOUNT 
WHERE DEBIT>0 AND CURRENCY <> 'INR'
UPDATE #TRANSLISTINGLASTYEAR 
SET CREDIT = HOMECURRAMOUNT 
WHERE CREDIT>0 AND CURRENCY <> 'INR'


-- Forming Balance Sheet Table
SELECT 
  B.BSCODE,
  B.BSDETAIL,
  B.BSDESC 
INTO #BS
FROM BALSHEET B 

SELECT * INTO #BSMASTER FROM #BS 

ALTER TABLE #BS ADD LEDGERCODE VARCHAR(10)
ALTER TABLE #BS ADD LEDGERNAME VARCHAR(100)
ALTER TABLE #BS ADD THISYEAR   DECIMAL(18,2)
ALTER TABLE #BS ADD LASTYEAR   DECIMAL(18,2)

  
INSERT INTO #BS(BSCODE,BSDETAIL,BSDESC,LEDGERCODE,LEDGERNAME) 
SELECT L.BSHEET,5,SPACE(55), L.LEDGERCODE,L.LEDGERNAME 
FROM #LEDGERNAME  L 
 

UPDATE #BS SET BSDESC = #BSMASTER.BSDESC FROM #BSMASTER INNER JOIN #BS ON #BS.BSCODE = #BSMASTER.BSCODE 
UPDATE #BS SET BSDESC = SPACE(55) WHERE BSDESC IS NULL
UPDATE #BS SET THISYEAR=0,LASTYEAR=0 
 
 

SELECT 
  T.LEDGERCODE,
  SUM(T.DEBIT-T.CREDIT) NETBALANCE
INTO #CURRENTYEAR
FROM 
  #TRANSLISTING T
GROUP BY 
  T.LEDGERCODE 

 

SELECT 
  T.LEDGERCODE,
  SUM(T.DEBIT-T.CREDIT) NETBALANCE
INTO #LASTYEAR
FROM 
  #TRANSLISTINGLASTYEAR T
GROUP BY 
  T.LEDGERCODE 
 
UPDATE #BS SET THISYEAR = NETBALANCE FROM #CURRENTYEAR INNER JOIN #BS ON #BS.LEDGERCODE=#CURRENTYEAR.LEDGERCODE 
 

UPDATE #BS SET LASTYEAR = NETBALANCE FROM #LASTYEAR INNER JOIN #BS ON #BS.LEDGERCODE=#LASTYEAR.LEDGERCODE 


DELETE FROM #BS WHERE THISYEAR=0 AND LASTYEAR=0 AND BSDETAIL=5

 
ALTER TABLE #BS ADD BORGNAME VARCHAR(100)
ALTER TABLE #BS ADD UPTOPERIOD VARCHAR(50) 
ALTER TABLE #BS ADD FINYEAR CHAR(4)
ALTER TABLE #BS ADD INDEXCODE INT
UPDATE #BS SET INDEXCODE=1 WHERE LEFT(BSCODE,1)='1'
UPDATE #BS SET INDEXCODE=2 WHERE LEFT(BSCODE,1)='5'

SELECT BSCODE BSCODE5,SUM(THISYEAR) THISSUM,SUM(LASTYEAR) LASTSUM 
INTO #SUMS5
FROM #BS
WHERE BSDETAIL='5'
GROUP BY BSCODE 

 

UPDATE #BS SET THISYEAR = THISSUM , LASTYEAR = LASTSUM 
FROM #SUMS5 
INNER JOIN #BS ON #BS.BSCODE = #SUMS5.BSCODE5 
WHERE #BS.BSDETAIL = 4
 

SELECT LEFT(BSCODE,3) BSCODE3,SUM(THISYEAR) THISSUM, SUM(LASTYEAR) LASTSUM 
INTO #SUMS3
FROM #BS 
WHERE BSDETAIL='4'
GROUP BY LEFT(BSCODE,3)

UPDATE #BS SET THISYEAR = THISSUM, LASTYEAR = LASTSUM 
FROM #SUMS3
INNER JOIN #BS ON #BS.BSCODE = #SUMS3.BSCODE3 
WHERE #BS.BSDETAIL = 3



SELECT LEFT(BSCODE,2) BSCODE2,SUM(THISYEAR) THISSUM, SUM(LASTYEAR) LASTSUM 
INTO #SUMS2
FROM #BS 
WHERE BSDETAIL='3'
GROUP BY LEFT(BSCODE,2)

UPDATE #BS SET THISYEAR = THISSUM, LASTYEAR = LASTSUM 
FROM #SUMS2
INNER JOIN #BS ON #BS.BSCODE = #SUMS2.BSCODE2 
WHERE #BS.BSDETAIL = 2



SELECT LEFT(BSCODE,1) BSCODE1,SUM(THISYEAR) THISSUM, SUM(LASTYEAR) LASTSUM 
INTO #SUMS1
FROM #BS 
WHERE BSDETAIL='2'
GROUP BY LEFT(BSCODE,1)

UPDATE #BS SET THISYEAR = THISSUM, LASTYEAR = LASTSUM 
FROM #SUMS1
INNER JOIN #BS ON #BS.BSCODE = #SUMS1.BSCODE1
WHERE #BS.BSDETAIL = 1


UPDATE #BS SET BORGNAME = @BORGTEXT
UPDATE #BS SET UPTOPERIOD = (SELECT PERIODDESC FROM PERIODMASTER WHERE PERIODID = @UPTOPERIOD )
UPDATE #BS SET UPTOPERIOD = 'Opening Balance' WHERE @UPTOPERIOD = 0 
UPDATE #BS SET FINYEAR = @YEAR

UPDATE #BS SET BSDESC = SPACE(55) WHERE BSDETAIL=5

DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT
 
SET @Lower = 1 ---- The lowest random number
SET @Upper = 999 ---- The highest random number
SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)

SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
+ (DATEPART(ss, GETDATE()) * 1000 )
+ DATEPART(ms, GETDATE()) )*1000) + STR(@RANDOM) 

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(6),@FILEID)))
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #BS  ORDER BY BSCODE,BSDETAIL,BSDESC,LEDGERCODE,LEDGERNAME    '
EXEC(@SQL)
SELECT @FILENAME 
RETURN @FILEID