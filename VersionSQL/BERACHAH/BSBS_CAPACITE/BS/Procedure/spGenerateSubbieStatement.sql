/****** Object:  Procedure [BS].[spGenerateSubbieStatement]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spGenerateSubbieStatement](@BORGID INT,@FINYEAR INT,@CREDNO VARCHAR(10),@STARTPERIOD INT, @ENDPERIOD INT   )
AS
 

DECLARE @FILENAME VARCHAR(100)
DECLARE @FILEID   VARCHAR(10)
DECLARE @SQL      VARCHAR(250)
DECLARE @ORGID INT

SET @FILENAME = 'BSBS_TEMP.DBO.SUBBIESTATEMENT'


CREATE TABLE #SUBBIE(LEDGERCODE VARCHAR(10)  COLLATE SQL_Latin1_General_CP1_CI_AS )

DECLARE @STARTSUBBIE VARCHAR(10)
DECLARE @ENDSUBBIE   VARCHAR(10)
SELECT  @STARTSUBBIE=CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
SELECT  @ENDSUBBIE  =CONTROLTOGL   FROM CONTROLCODES WHERE CONTROLNAME='Sub Contractors'
DECLARE @TRANGRP     INT
DECLARE @RETAINED    VARCHAR(10)
DECLARE @WIP         VARCHAR(10)
DECLARE @TRANSID     INT


DECLARE @ADVANCE VARCHAR(10)
DECLARE @CERTIFIED VARCHAR(10)
DECLARE @VAT  VARCHAR(10)
DECLARE @ST   VARCHAR(10)
DECLARE @RETENTION VARCHAR(10)
DECLARE @WHT  VARCHAR(10)
DECLARE @CONTRA VARCHAR(10)
DECLARE @SUBBIE  VARCHAR(10)
DECLARE @THISWORKDONE DECIMAL(18,2) 
DECLARE @THISNETPAYABLE DECIMAL(18,2)
DECLARE @THISWHT  DECIMAL(18,2) 
DECLARE @THISCONTRA DECIMAL(18,2) 
DECLARE @THISST DECIMAL(18,2) 
DECLARE @ADMINCHARGE VARCHAR(10)
DECLARE @STBYSP VARCHAR(10)
DECLARE @YEARNAME VARCHAR(25) 

DECLARE @OB DECIMAL(18,2) 
DECLARE @OBRETENTION DECIMAL(18,2)
DECLARE @OBADVANCE DECIMAL(18,2) 


SET @ADVANCE = '1320003'
SET @ST = '1310002'
SET @VAT = '1310000' 
SET @RETENTION = '1320001' 
SET @WHT = '1310005' 
SET @CONTRA = '630313'
SET @SUBBIE = '1320000'
SET @ADMINCHARGE = '5120241'   
SET @STBYSP = '1310008'  

SELECT @RETAINED = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Retained Income'
SELECT @WIP      = CONTROLFROMGL FROM CONTROLCODES WHERE CONTROLNAME='Work In Progress'                  
                    
 

CREATE TABLE #STATEMENT (CREDNO VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS , BILLDATE DATETIME, BILLNUMBER VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS  
 , ADVANCE MONEY, CERTIFIED MONEY, VAT MONEY, ST MONEY 
 , RETENTION MONEY , CONTRA MONEY , TDS MONEY ,ADMINCHARGE MONEY, STBYSP MONEY 
 , NETPAYABLE MONEY ,PAID MONEY,CHEQUENUMBER VARCHAR(10), BANKNAME VARCHAR(50) ,TRANSTYPE VARCHAR(15), 
   SETTLEMENTDISCOUNT MONEY, ORDERNUMBER VARCHAR(50), ID  INT , TRANSID INT , TRANGRP VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
   PERIOD INT,BATCHREF VARCHAR(10) ) 

 

INSERT INTO #SUBBIE 
SELECT LEDGERCODE FROM LEDGERCODES WHERE LEDGERCODE BETWEEN @STARTSUBBIE AND @ENDSUBBIE
--INSERT INTO #SUBBIE VALUES ( @ADVANCE ) REQUIRED TO TAKE CARE DIRECT ADVANCE PAYMENT THROUGH CBC OR PCP 



-- OTHER THAN OPENING BALANCE
DECLARE TRANGRPS CURSOR FOR
SELECT DISTINCT TRANGRP FROM TRANSACTIONS WHERE LEDGERCODE IN (SELECT LEDGERCODE FROM #SUBBIE)
 AND YEAR=@FINYEAR  AND ORGID=@BORGID AND CREDNO = @CREDNO AND PERIOD<>0  
 --AND TRANGRP= 269580

OPEN TRANGRPS 
FETCH NEXT FROM TRANGRPS INTO @TRANGRP 

WHILE @@FETCH_STATUS = 0 
BEGIN
  SELECT LEDGERCODE,DESCRIPTION ,DEBIT,CREDIT,CREDNO ,SUBCONTRAN ,TRANGRP,PDATE,TRANSREF  ,ALLOCATION ,TRANSTYPE ,ORDERNO ,TRANSID ,PERIOD,BATCHREF 
  INTO #TEMP 
  FROM TRANSACTIONS 
  WHERE TRANGRP = @TRANGRP AND LEDGERCODE NOT IN (@WIP,@RETAINED) 
  
 

  INSERT INTO #STATEMENT (ID,CREDNO,BILLDATE,BILLNUMBER,TRANSTYPE,ORDERNUMBER,PERIOD,BATCHREF  ) 
  SELECT TOP 1 TRANGRP,CREDNO,PDATE,TRANSREF,TRANSTYPE,ORDERNO,PERIOD ,BATCHREF  FROM #TEMP WHERE LEDGERCODE=@SUBBIE

  UPDATE #STATEMENT SET ADVANCE = (DEBIT-CREDIT) FROM #TEMP WHERE LEDGERCODE = @ADVANCE   AND  ID = @TRANGRP 
  SET @THISWORKDONE = 0
  SELECT @THISWORKDONE = SUM(DEBIT-CREDIT) FROM #TEMP WHERE ALLOCATION = 'Contracts' AND ( SUBCONTRAN='WorkDone'  OR SUBCONTRAN= 'Work Done' )  
  UPDATE #STATEMENT SET CERTIFIED = @THISWORKDONE WHERE ID=@TRANGRP 
  SET @THISST = 0
  SELECT @THISST = SUM(DEBIT-CREDIT) FROM #TEMP WHERE LEDGERCODE=@ST 
  UPDATE #STATEMENT SET ST = @THISST  WHERE  ID = @TRANGRP 
  UPDATE #STATEMENT SET VAT = (DEBIT-CREDIT) FROM #TEMP WHERE LEDGERCODE = @VAT AND  ID = @TRANGRP 
  UPDATE #STATEMENT SET RETENTION = (CREDIT-DEBIT) FROM #TEMP WHERE LEDGERCODE = @RETENTION AND  ID = @TRANGRP 
  SET @THISWHT = 0
  SELECT @THISWHT = SUM(CREDIT-DEBIT) FROM #TEMP WHERE LEDGERCODE=@WHT 
  UPDATE #STATEMENT SET TDS = @THISWHT WHERE    ID = @TRANGRP 
  SET @THISCONTRA = 0
  SELECT @THISCONTRA = SUM(CREDIT-DEBIT) FROM #TEMP WHERE SUBCONTRAN LIKE 'Contra%' 
  UPDATE #STATEMENT SET CONTRA = @THISCONTRA WHERE   ID = @TRANGRP 
  UPDATE #STATEMENT SET ADMINCHARGE = CREDIT FROM #TEMP WHERE LEDGERCODE=@ADMINCHARGE AND ID=@TRANGRP 
  SET @THISNETPAYABLE = 0 
  SELECT @THISNETPAYABLE = CREDIT-DEBIT FROM #TEMP WHERE LEDGERCODE=@SUBBIE AND  ( SUBCONTRAN LIKE '%Certified Amount%' OR SUBCONTRAN LIKE '%Payable%' )
  UPDATE #STATEMENT SET NETPAYABLE = @THISNETPAYABLE  WHERE   ID = @TRANGRP 
  UPDATE #STATEMENT SET STBYSP = CREDIT FROM #TEMP WHERE LEDGERCODE=@STBYSP AND ID=@TRANGRP 
  UPDATE #STATEMENT SET PAID  = (DEBIT-CREDIT)  FROM #TEMP WHERE LEDGERCODE=@SUBBIE AND SUBCONTRAN='Payment' AND  ID = @TRANGRP AND #TEMP.CREDNO=@CREDNO AND LEFT(#TEMP.BATCHREF ,3) IN ( 'CBC', 'PCP' )
  UPDATE #STATEMENT SET PAID = -1.0*CREDIT FROM #TEMP WHERE LEDGERCODE=@SUBBIE AND SUBCONTRAN ='Payment' AND ID=@TRANGRP AND  #TEMP.CREDNO=@CREDNO AND LEFT(#TEMP.BATCHREF,3)='CBD'


  DROP TABLE #TEMP 
  FETCH NEXT FROM TRANGRPS INTO @TRANGRP 
END


CLOSE TRANGRPS
DEALLOCATE TRANGRPS

-- OPENING BALANCE 

SET @OB = 0 
SELECT 
  @OB = SUM(CREDIT-DEBIT)   FROM TRANSACTIONS 
  WHERE YEAR=@FINYEAR AND PERIOD=0 AND ORGID=@BORGID AND LEDGERCODE=@SUBBIE AND CREDNO=@CREDNO  

SET @OBRETENTION = 0 
SELECT 
  @OBRETENTION = SUM(CREDIT-DEBIT)   FROM TRANSACTIONS 
  WHERE YEAR=@FINYEAR AND PERIOD=0 AND ORGID=@BORGID AND LEDGERCODE=@RETENTION AND CREDNO=@CREDNO  

SET @OBADVANCE  = 0 
SELECT 
  @OBADVANCE = SUM(CREDIT-DEBIT)   FROM TRANSACTIONS 
  WHERE YEAR=@FINYEAR AND PERIOD=0 AND ORGID=@BORGID AND LEDGERCODE=@ADVANCE AND CREDNO=@CREDNO

IF ( @OB > 0  OR @OBRETENTION > 0  OR @OBADVANCE > 0 )

    INSERT INTO #STATEMENT (CREDNO,ADVANCE,RETENTION,NETPAYABLE,PAID,PERIOD) 
	SELECT @CREDNO,@OBADVANCE,@OBRETENTION,@OB,0,0

IF @OB < 0 
    INSERT INTO #STATEMENT (CREDNO,ADVANCE,RETENTION,NETPAYABLE,PAID,PERIOD) 
	SELECT @CREDNO,@OBADVANCE,@OBRETENTION, 0,@OB,0 

SELECT * FROM #STATEMENT 
SELECT @OB,@OBRETENTION,@OBADVANCE 

-- Filtering Periods

DELETE FROM #STATEMENT WHERE PERIOD > @ENDPERIOD 

IF @STARTPERIOD > 0
BEGIN
   SELECT SUM(ADVANCE) ADVANCE, SUM(CERTIFIED) CERTIFIED, SUM(ST) ST, SUM(VAT) VAT, SUM(RETENTION) RETENTION , SUM(TDS) TDS, SUM(CONTRA) CONTRA,
          SUM(NETPAYABLE) NETPAYABLE, SUM(ADMINCHARGE) ADMINCHARGE, SUM(PAID) PAID, SUM(STBYSP) STBYSP, SUM(SETTLEMENTDISCOUNT) SETTLEMENTDISCOUNT 
   INTO #CF
   FROM #STATEMENT 
   WHERE PERIOD< @STARTPERIOD 

   DELETE FROM #STATEMENT WHERE PERIOD < @STARTPERIOD 

   INSERT INTO #STATEMENT (PERIOD,CREDNO,ADVANCE,CERTIFIED,ST,VAT,RETENTION,TDS,CONTRA,NETPAYABLE,ADMINCHARGE,PAID,STBYSP,SETTLEMENTDISCOUNT)  
   SELECT  -1,@CREDNO,* FROM #CF 
END

-- Resetting Values 
UPDATE #STATEMENT SET ADVANCE = 0 WHERE ADVANCE IS NULL
UPDATE #STATEMENT SET CERTIFIED = 0 WHERE CERTIFIED IS NULL
UPDATE #STATEMENT SET ST = 0 WHERE ST IS NULL
UPDATE #STATEMENT SET VAT = 0 WHERE VAT IS NULL
UPDATE #STATEMENT SET RETENTION = 0  WHERE RETENTION IS NULL 
UPDATE #STATEMENT SET TDS = 0 WHERE TDS IS NULL
UPDATE #STATEMENT SET CONTRA = 0 WHERE CONTRA IS NULL
UPDATE #STATEMENT SET NETPAYABLE = 0 WHERE NETPAYABLE IS NULL
UPDATE #STATEMENT SET ADMINCHARGE = 0 WHERE ADMINCHARGE IS NULL 
UPDATE #STATEMENT SET PAID = 0 WHERE PAID IS NULL 
UPDATE #STATEMENT SET SETTLEMENTDISCOUNT = 0 WHERE SETTLEMENTDISCOUNT IS NULL    
  
ALTER TABLE #STATEMENT ADD PERIODNAME VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
UPDATE #STATEMENT SET PERIODNAME = P.PERIODDESC  FROM PERIODMASTER  P INNER JOIN #STATEMENT ON #STATEMENT.PERIOD=P.PERIODID
UPDATE #STATEMENT SET PERIODNAME='Opening Balance' WHERE PERIOD=0
UPDATE #STATEMENT SET PERIODNAME='Carry Forward' WHERE PERIOD=-1

ALTER TABLE #STATEMENT ADD SUBBIENAME VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS
UPDATE #STATEMENT SET SUBBIENAME = S.SUBNAME FROM SUBCONTRACTORS S INNER JOIN #STATEMENT ON #STATEMENT.CREDNO=S.SUBNUMBER 

ALTER TABLE #STATEMENT ADD BORGNAME VARCHAR(100)
UPDATE #STATEMENT SET BORGNAME = (SELECT BORGNAME FROM BORGS WHERE BORGID=@BORGID) 

ALTER TABLE #STATEMENT ADD STARTPERIOD VARCHAR(25)
ALTER TABLE #STATEMENT ADD ENDPERIOD   VARCHAR(25) 
UPDATE #STATEMENT SET STARTPERIOD = P.PERIODDESC  FROM PERIODMASTER  P WHERE P.PERIODID= @STARTPERIOD 
UPDATE #STATEMENT SET ENDPERIOD = P.PERIODDESC  FROM PERIODMASTER  P WHERE P.PERIODID= @ENDPERIOD 
UPDATE #STATEMENT SET STARTPERIOD='Opening Balance' WHERE @STARTPERIOD=0
UPDATE #STATEMENT SET ENDPERIOD='Opening Balance' WHERE @ENDPERIOD =0

ALTER  TABLE #STATEMENT ADD FINYEAR VARCHAR(25)
SET @YEARNAME = STR(@FINYEAR-1) + ' - ' + LTRIM(RTRIM(STR(@FINYEAR)))
UPDATE #STATEMENT SET FINYEAR = @YEARNAME 


UPDATE #STATEMENT SET CHEQUENUMBER = BILLNUMBER WHERE PAID>0
UPDATE #STATEMENT SET BILLNUMBER = SPACE(10) WHERE PAID<>0 
UPDATE #STATEMENT SET BANKNAME = 'Cheque Reversal' WHERE ( LEFT(TRANSTYPE,3)='CBD' )   OR ( LEFT(BATCHREF,3)='CBC' AND LEFT(TRANSTYPE,3)='REV' )
SELECT ID AS TRANGRP   INTO #T FROM #STATEMENT WHERE PAID>0
ALTER TABLE #T ADD LEDGERCODE VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CI_AS
UPDATE #T SET LEDGERCODE = T.LEDGERCODE FROM TRANSACTIONS T INNER JOIN #T ON #T.TRANGRP=T.TRANGRP AND T.LEDGERCODE IN (SELECT BANKLEDGER FROM BANKS) 
ALTER TABLE  #T ADD BANKNAME VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS
UPDATE #T SET BANKNAME = B.BANKNAME FROM BANKS B INNER JOIN #T ON #T.LEDGERCODE = B.BANKLEDGER 
--SELECT * FROM #T 
UPDATE #STATEMENT SET BANKNAME = T.BANKNAME FROM #T T INNER JOIN #STATEMENT ON T.TRANGRP = #STATEMENT.ID  

UPDATE #STATEMENT SET BILLNUMBER=SPACE(10) WHERE TRANSTYPE='SCP' 
UPDATE #STATEMENT SET BANKNAME = 'Petty Cash' WHERE TRANSTYPE LIKE 'PCP%'
--SELECT * FROM #STATEMENT 

DELETE FROM #STATEMENT WHERE BILLDATE < '01-APR-2015' 

SELECT @FILEID= CONVERT(INT,RAND( (DATEPART(mm, GETDATE()) * 100000 )
+ (DATEPART(ss, GETDATE()) * 1000 )
+ DATEPART(ms, GETDATE()) )*1000)

SET @FILENAME = @FILENAME+LTRIM(RTRIM(CONVERT(VARCHAR(3),@FILEID)))
SELECT @FILENAME 
SET @SQL = 'SELECT *  INTO '+@FILENAME+ ' FROM   #STATEMENT   ORDER BY ID '

EXEC(@SQL)

RETURN @FILEID