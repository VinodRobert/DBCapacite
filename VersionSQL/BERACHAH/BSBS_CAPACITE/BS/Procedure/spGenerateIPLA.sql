/****** Object:  Procedure [BS].[spGenerateIPLA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spGenerateIPLA(@FINYEAR INT,@STARTPERIOD INT,@ENDPERIOD INT)
AS
SELECT BORGID,BORGNAME,ICGLCODE IPLACODE INTO #IPLAMASTER  FROM BORGS 
DELETE FROM #IPLAMASTER WHERE IPLACODE IS NULL


SELECT ORGID,LEDGERCODE,DEBIT,CREDIT 
INTO #IPLATRANS
FROM TRANSACTIONS 
WHERE LEDGERCODE IN (SELECT IPLACODE FROM #IPLAMASTER) 
AND   YEAR = @FINYEAR AND PERIOD BETWEEN @STARTPERIOD AND @ENDPERIOD 

ALTER TABLE  #IPLATRANS ADD FIRSTORGNAME   VARCHAR(30)
ALTER TABLE  #IPLATRANS ADD OTHERORGID INT 
ALTER TABLE  #IPLATRANS ADD OTHERORGNAME  VARCHAR(5)
ALTER TABLE  #IPLATRANS ADD OTHERBORGVALUE  INT 

UPDATE #IPLATRANS 
  SET OTHERORGID =#IPLAMASTER.BORGID 
  FROM #IPLAMASTER INNER JOIN #IPLATRANS ON #IPLATRANS.LEDGERCODE = #IPLAMASTER.IPLACODE 

UPDATE #IPLATRANS 
  SET OTHERORGNAME =LEFT(#IPLAMASTER.BORGNAME,5)
  FROM #IPLAMASTER INNER JOIN #IPLATRANS ON #IPLATRANS.OTHERORGID = #IPLAMASTER.BORGID 

  
UPDATE #IPLATRANS SET OTHERBORGVALUE = OTHERORGNAME

UPDATE #IPLATRANS 
  SET  FIRSTORGNAME =LEFT(#IPLAMASTER.BORGNAME,30)
  FROM #IPLAMASTER INNER JOIN #IPLATRANS ON #IPLATRANS.ORGID = #IPLAMASTER.BORGID 

SELECT * FROM #IPLATRANS ORDER BY FIRSTORGNAME,OTHERBORGVALUE 

SELECT SUM(DEBIT-CREDIT) FROM #IPLATRANS WHERE  ORGID=2
SELECT SUM(DEBIT-CREDIT) FROM #IPLATRANS WHERE OTHERORGID =2