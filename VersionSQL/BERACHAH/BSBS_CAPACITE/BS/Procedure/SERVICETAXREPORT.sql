/****** Object:  Procedure [BS].[SERVICETAXREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[SERVICETAXREPORT](@ORGID INT,@STARTDATESTRING VARCHAR(15), @ENDDATESTRING VARCHAR(15),@FINYEAR INT,@ZONEID INT )
AS

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)


SET @FILENAME = 'BSBS_TEMP.DBO.STREGISTER'

CREATE TABLE #BORGS(BORGID INT) 
IF @ZONEID <> 0 
	    INSERT INTO #BORGS 
	    SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONEID 
ELSE
	    INSERT INTO #BORGS(BORGID) VALUES (@ORGID) 


SELECT BANKLEDGER INTO #BANKS  FROM BANKS  
INSERT INTO  #BANKS VALUES ('2551000') 

     
CREATE TABLE #TEMP1
(
 TRANGRP INT,
 ORGID INT,
 TRANSDATE DATETIME,
 TRANSTYPE VARCHAR(15),
 BATCHREF VARCHAR(10),
 TRANSREF  VARCHAR(10),
 CREDNUMBER VARCHAR(10),
 NARRATION VARCHAR(250),
 TAXPERCENTAGE DECIMAL(18,2),
 BASEAMOUNT DECIMAL(18,2),
 DEBITAMOUNT  DECIMAL(18,2),
 CREDITAMOUNT DECIMAL(18,2),
 DESCRIPTION VARCHAR(250),
 LEDGERCODE  VARCHAR(10)
)

CREATE TABLE #TEMP2
(

 TRANGRP INT,
 ORGID INT ,
 BATCHREF VARCHAR(10),
 TRANSREF VARCHAR(10),
 NARRATION VARCHAR(250),
 BASEAMOUNT DECIMAL(18,2),
 TAXAMOUNT DECIMAL(18,2)
)
 
DECLARE @TRANSGRP INT
DECLARE @ORGID2 INT
DECLARE @BASEAMOUNT DECIMAL(18,2)
DECLARE @STINDIVIDUAL    DECIMAL(18,2)
DECLARE @STARTDATE     DATETIME
DECLARE @ENDDATE       DATETIME
DECLARE @BATCHREF   VARCHAR(10)
DECLARE @TRANSREF VARCHAR(10) 
DECLARE @CONTRACTREVENUE_S VARCHAR(10)
DECLARE @CONTRACTREVENUE_E VARCHAR(10)

DECLARE @WIP CHAR(10)
DECLARE @RETAINED CHAR(10)
DECLARE @STLEDGERCODE CHAR(10)
DECLARE @TRANSTYPE VARCHAR(15)
DECLARE @CREDNUMBER VARCHAR(10)
DECLARE @BANKSTART  VARCHAR(10)
DECLARE @BANKEND    VARCHAR(10)
DECLARE @PETTYCASH VARCHAR(10)
DECLARE @CREDITORCONTROL VARCHAR(10)
DECLARE @SUBBIECONTROL VARCHAR(10)

SELECT @RETAINED = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Retained Income'
SELECT @WIP      = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Work In Progress'
SELECT @STLEDGERCODE = LEDGERCODE FROM VATGROUPS WHERE NAME='SERVICE TAX INPUT'
SELECT @STARTDATE = CONVERT(DATETIME, @STARTDATESTRING,103) -- dd/mm/yyyy 
SELECT @ENDDATE   = CONVERT(DATETIME, @ENDDATESTRING,103) -- dd/mm/yyyy 
SELECT @PETTYCASH = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME = 'Petty Cash'                         
SELECT @BANKSTART = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME = 'Bank'   
SELECT @BANKEND =   CONTROLTOGL FROM CONTROLCODES WHERE CONTROLNAME = 'Bank'   
SELECT @CREDITORCONTROL = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Creditors'
SELECT @SUBBIECONTROL = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
SELECT @CONTRACTREVENUE_S = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME = 'Contract Revenue'
SELECT @CONTRACTREVENUE_E = CONTROLTOGL   FROM CONTROLCODES WHERE CONTROLNAME = 'Contract Revenue'



DECLARE @TRANSDATE DATE
DECLARE @NARRATION VARCHAR(250)
DECLARE @NARRATION2 VARCHAR(250) 
DECLARE @STAMOUNT DECIMAL(18,2) 
DECLARE @RETENTION DECIMAL(18,2)
DECLARE @GROSSBILLING DECIMAL(18,2)
DECLARE @REVERSE INT

                                 


INSERT INTO #TEMP1(TRANGRP,ORGID,TRANSDATE,TRANSREF,TRANSTYPE,CREDNUMBER, NARRATION,TAXPERCENTAGE,BASEAMOUNT,DEBITAMOUNT,CREDITAMOUNT,BATCHREF,LEDGERCODE) 
SELECT TRANGRP,ORGID,PDATE,TRANSREF, LEFT(TRANSTYPE,3),CREDNO,DESCRIPTION,0,0,DEBIT,CREDIT ,BATCHREF ,LEDGERCODE
FROM 
  TRANSACTIONS
WHERE
   ORGID IN (SELECT BORGID FROM #BORGS)
   AND LEDGERCODE = @STLEDGERCODE
   AND PDATE BETWEEN @STARTDATE AND @ENDDATE 
   AND YEAR = @FINYEAR 


-- CBC , PCP  BILL AMOUNT
SELECT ORGID,TRANGRP,SUM(DEBIT) BILLAMOUNT  
INTO #CBCBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE IN ('CBC','PCP') ) 
AND VATDEBIT>0 
GROUP BY ORGID,TRANGRP   
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT  FROM #CBCBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #CBCBILLAMOUNT

-- CBD, CCN BILL AMOUNT
SELECT ORGID,TRANGRP,SUM(CREDIT) BILLAMOUNT  
INTO #CBCBILLAMOUNTCREDIT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE IN ('CBD','CCN') ) 
AND VATCREDIT>0 
GROUP BY ORGID,TRANGRP   
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT  FROM #CBCBILLAMOUNTCREDIT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #CBCBILLAMOUNTCREDIT

--CBC , CBD, CCN , REV DESCRIPTION 
SELECT ORGID,TRANGRP,CREDNO,DESCRIPTION 
INTO #CBCDESCRIPTION 
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE IN ('CBC','CBD', 'CCN','REV' ) ) 
AND LEDGERCODE IN (SELECT BANKLEDGER FROM #BANKS )
UPDATE #TEMP1 SET CREDNUMBER=CB.CREDNO ,DESCRIPTION = CB.DESCRIPTION FROM #CBCDESCRIPTION CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #CBCDESCRIPTION

-- CRI BILL AMOUN,T DESCRIPTION ETC 
SELECT ORGID,TRANGRP,CREDIT BILLAMOUNT,CREDNO,DESCRIPTION 
INTO #CRIBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='CRI' ) 
AND LEDGERCODE IN (@CREDITORCONTROL,@SUBBIECONTROL) 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT , CREDNUMBER=CB.CREDNO, DESCRIPTION = CB.Description
FROM #CRIBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #CRIBILLAMOUNT


-- DEL  BILL AMOUNT
SELECT ORGID,TRANGRP,SUM(DEBIT) BILLAMOUNT   
INTO #DELBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='DEL') 
AND VATDEBIT>0 
GROUP BY ORGID,TRANGRP 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT 
FROM #DELBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #DELBILLAMOUNT


-- DEL  DESCRIPTION 
SELECT ORGID,TRANGRP,DESCRIPTION, CREDNO  
INTO #DELNARRATION
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='DEL') 
AND LEDGERCODE IN (@CREDITORCONTROL,@SUBBIECONTROL)  
UPDATE #TEMP1 SET CREDNUMBER=CB.CREDNO, DESCRIPTION = CB.Description
FROM #DELNARRATION CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #DELNARRATION



--JNL
UPDATE #TEMP1 SET DESCRIPTION = NARRATION WHERE TRANSTYPE IN ('JNL','OPB') 

-- REVERSAL OF JOURNALS 
UPDATE #TEMP1 SET DESCRIPTION = NARRATION WHERE TRANSTYPE = 'REV' AND LEFT(BATCHREF,3) = 'JNL' 

-- REVERAL OF CBC , CCN 
SELECT ORGID,TRANGRP,SUM(CREDIT) BILLAMOUNT  
INTO #CBCREVCBC
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE = 'REV'  AND LEFT(BATCHREF,3) = 'CBC'  ) 
AND VATCREDIT>0 
GROUP BY ORGID,TRANGRP   
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT  FROM #CBCREVCBC CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #CBCREVCBC


-- REVERSAL CBD   BILL AMOUNT
SELECT ORGID,TRANGRP,SUM(DEBIT) BILLAMOUNT  
INTO #REVCBCBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE ='REV' AND LEFT(BATCHREF,3) IN ( 'CBD', 'CCN')  ) 
AND VATDEBIT>0 
GROUP BY ORGID,TRANGRP   
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT  FROM #REVCBCBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #REVCBCBILLAMOUNT 


-- REVERSAL  CRI BILL AMOUN,T DESCRIPTION ETC 
SELECT ORGID,TRANGRP,DEBIT BILLAMOUNT,CREDNO,DESCRIPTION 
INTO #REVCRIBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='REV'  AND LEFT(BATCHREF,3) = 'CRI')  
AND LEDGERCODE IN (@CREDITORCONTROL,@SUBBIECONTROL) 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT , CREDNUMBER=CB.CREDNO, DESCRIPTION = CB.Description
FROM #REVCRIBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #REVCRIBILLAMOUNT


-- REVEERSAL DEL  BILL AMOUNT
SELECT ORGID,TRANGRP,SUM(CREDIT) BILLAMOUNT   
INTO #REVDELBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='REV' AND LEFT(BATCHREF,3)= 'DEL') 
AND VATCREDIT>0 
GROUP BY ORGID,TRANGRP 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT 
FROM #REVDELBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #REVDELBILLAMOUNT

-- REVERSAL  DEL  DESCRIPTION 
SELECT ORGID,TRANGRP,DESCRIPTION, CREDNO  
INTO #REVDELNARRATION
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='REV'  AND LEFT(BATCHREF,3) = 'DEL' ) 
AND LEDGERCODE IN (@CREDITORCONTROL,@SUBBIECONTROL)  
UPDATE #TEMP1 SET CREDNUMBER=CB.CREDNO, DESCRIPTION = CB.Description
FROM #REVDELNARRATION CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #REVDELNARRATION



-- DTI BILL AMOUNT 
SELECT ORGID,TRANGRP,CREDIT  BILLAMOUNT   ,LEDGERCODE
INTO #DTIBILLAMOUNT1
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='DTI' ) 
AND LEDGERCODE BETWEEN @CONTRACTREVENUE_S AND @CONTRACTREVENUE_E  
AND  CREDIT > 0 
 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT ,LEDGERCODE=CB.LEDGERCODE 
FROM #DTIBILLAMOUNT1 CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #DTIBILLAMOUNT1

-- DTI BILL AMOUNT  - CREDIT 
SELECT ORGID,TRANGRP,DEBIT  BILLAMOUNT   
INTO #DTIBILLAMOUNT2
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #TEMP1 WHERE TRANSTYPE='DTI' ) 
AND LEDGERCODE BETWEEN @CONTRACTREVENUE_S AND @CONTRACTREVENUE_E  
AND  DEBIT > 0 
 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT 
FROM #DTIBILLAMOUNT2 CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #DTIBILLAMOUNT2

-- ADDITIONAL REMARKS COLUMN
ALTER TABLE #TEMP1 ADD REMARKS VARCHAR(250)
UPDATE #TEMP1 SET REMARKS = D.REMARK  FROM DEBTRECONS_ARCHIEVE D INNER JOIN #TEMP1 ON #TEMP1.TRANGRP=D.TRANGRP 


-- KEEP A TEMP TABLE FOR SCI TRANGRP 
SELECT TRANGRP INTO #SCITRANGRP FROM #TEMP1 WHERE TRANSTYPE = 'SCI'



-- SCI DEBIT
SELECT ORGID,TRANGRP,SUM(DEBIT) BILLAMOUNT  ,LEDGERCODE 
INTO #SCIBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #SCITRANGRP ) 
AND VATDEBIT>0 
GROUP BY ORGID,TRANGRP   ,LEDGERCODE
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT ,LEDGERCODE=CB.LEDGERCODE 
FROM #SCIBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DELETE FROM #SCITRANGRP WHERE TRANGRP IN (SELECT TRANGRP FROM #SCIBILLAMOUNT) 
DROP TABLE #SCIBILLAMOUNT

-- SCI CREDIT
SELECT ORGID,TRANGRP,SUM(CREDIT) BILLAMOUNT  ,LEDGERCODE
INTO #SCICREDITBILLAMOUNT
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #SCITRANGRP  ) 
AND VATCREDIT>0 
GROUP BY ORGID,TRANGRP   ,LEDGERCODE
DELETE FROM #SCITRANGRP WHERE TRANGRP IN (SELECT TRANGRP FROM #SCICREDITBILLAMOUNT) 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT ,LEDGERCODE=CB.LEDGERCODE  
FROM #SCICREDITBILLAMOUNT CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DROP TABLE #SCICREDITBILLAMOUNT


-- SCI VARIANT 1

SELECT ORGID,TRANGRP,SUM(DEBIT) BILLAMOUNT  ,LEDGERCODE 
INTO #SCIVARIANT1
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #SCITRANGRP ) 
AND ALLOCATION = 'Contracts' 
AND DESCRIPTION NOT LIKE '%Retention%'
GROUP BY ORGID,TRANGRP ,LEDGERCODE
DELETE FROM #SCIVARIANT1 WHERE BILLAMOUNT= 0
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT  ,LEDGERCODE=CB.LEDGERCODE 
FROM #SCIVARIANT1 CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DELETE FROM #SCITRANGRP WHERE TRANGRP IN (SELECT TRANGRP FROM #SCIVARIANT1) 
DROP TABLE #SCIVARIANT1


-- SCI VARIANT 2
 
SELECT ORGID,TRANGRP,SUM(CREDIT) BILLAMOUNT  ,LEDGERCODE 
INTO #SCIVARIANT2
FROM TRANSACTIONS
WHERE TRANGRP IN (SELECT TRANGRP FROM #SCITRANGRP ) 
AND ALLOCATION = 'Contracts' 
AND DESCRIPTION NOT LIKE '%Retention%'
GROUP BY ORGID,TRANGRP ,LEDGERCODE
 
UPDATE #TEMP1 SET BASEAMOUNT  = CB.BILLAMOUNT  ,LEDGERCODE=CB.LEDGERCODE 
FROM #SCIVARIANT2 CB INNER JOIN #TEMP1 ON #TEMP1.ORGID=CB.ORGID AND #TEMP1.TRANGRP=CB.TRANGRP 
DELETE FROM #SCITRANGRP WHERE TRANGRP IN (SELECT TRANGRP FROM #SCIVARIANT2) 
DROP TABLE #SCIVARIANT2

-- ADDITIONAL REMARKS FOR SUBBIE
UPDATE #TEMP1 SET REMARKS = S.REMARK  FROM SUBCRECONS_ARCHIEVE S INNER JOIN #TEMP1 ON #TEMP1.TRANGRP=S.TRANGRP 


ALTER TABLE #TEMP1 ADD PARTY VARCHAR(150)
UPDATE #TEMP1 SET PARTY = C.CREDNAME FROM CREDITORS C INNER JOIN #TEMP1 ON #TEMP1.CREDNUMBER = C.CREDNUMBER
UPDATE #TEMP1 SET PARTY = S.SUPPNAME FROM SUPPLIERS S INNER JOIN #TEMP1 ON #TEMP1.CREDNUMBER = S.SUPPCODE
UPDATE #TEMP1 SET PARTY = D.DEBTNAME FROM DEBTORS D INNER JOIN #TEMP1 ON #TEMP1.CREDNUMBER= D.DEBTNUMBER 

ALTER TABLE  #TEMP1 ADD STARTDATE DATETIME
ALTER TABLE  #TEMP1 ADD ENDDATE   DATETIME
ALTER TABLE  #TEMP1 ADD BORGNAME  VARCHAR(100)
ALTER TABLE  #TEMP1 ADD LEDGERNAME  VARCHAR(50)
ALTER TABLE  #TEMP1 ADD TAXCOMPUTED DECIMAL(18,4)
ALTER TABLE  #TEMP1 ADD ALERTS INT 

UPDATE #TEMP1 SET ALERTS = 0
UPDATE #TEMP1 SET ALERTS = 1 WHERE DESCRIPTION LIKE '%REVERSAL%'
UPDATE #TEMP1 SET TAXCOMPUTED = 0

UPDATE #TEMP1 SET LEDGERNAME = L.LEDGERNAME FROM LEDGERCODES L INNER JOIN #TEMP1 T ON T.LEDGERCODE=L.LEDGERCODE
UPDATE #TEMP1 SET BORGNAME = B.BORGNAME FROM BORGS B INNER JOIN #TEMP1 T ON T.ORGID = B.BORGID 
UPDATE #TEMP1 SET STARTDATE = @STARTDATE,ENDDATE = @ENDDATE 
UPDATE #TEMP1 SET NARRATION = UPPER(NARRATION),PARTY = UPPER(PARTY),REMARKS = UPPER(REMARKS) ,DESCRIPTION = UPPER(DESCRIPTION) 
UPDATE #TEMP1 SET TAXPERCENTAGE = 12.36 WHERE NARRATION LIKE '%12.36%'
UPDATE #TEMP1 SET TAXPERCENTAGE = 3.09  WHERE NARRATION LIKE '%3.09%'
UPDATE #TEMP1 SET TAXPERCENTAGE = 4.944  WHERE NARRATION LIKE '%4.944%'
UPDATE #TEMP1 SET TAXCOMPUTED = (ABS(CREDITAMOUNT-DEBITAMOUNT)/BASEAMOUNT)*100.00 WHERE TAXPERCENTAGE= 0 AND BASEAMOUNT>0
UPDATE #TEMP1 SET NARRATION=SPACE(1) WHERE NARRATION=DESCRIPTION



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
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #TEMP1  ORDER BY ORGID,TRANSDATE  '
EXEC(@SQL)

SELECT @FILENAME 
RETURN @FILEID
 