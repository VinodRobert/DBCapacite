/****** Object:  Procedure [BI].[spGetBorgs]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [BI].[spGetBorgs](@ZONE INT)
AS
CREATE TABLE #TEMP0(BORGID INT,BORGNAME VARCHAR(100))

IF @ZONE=0
  INSERT INTO #TEMP0 
  SELECT BORGID,BORGNAME FROM BORGS WHERE PARENTBORG IN (23,24,25,26,27,172,209)  
ELSE
  INSERT INTO #TEMP0 
  SELECT BORGID,BORGNAME FROM BORGS WHERE PARENTBORG=@ZONE 

IF @ZONE=99
  INSERT INTO #TEMP0 
  SELECT BORGID,BORGNAME FROM BORGS WHERE BORGID=2 


DECLARE @CNT INT
SELECT @CNT=COUNT(*) FROM #TEMP0
IF @CNT = 0 
   INSERT INTO #TEMP0 VALUES  (0,'No Projects' )

SELECT * FROM #TEMP0  ORDER BY BORGNAME
SELECT DISTINCT COMPREG FROM BORGS WHERE BORGID IN (SELECT BORGID FROM #TEMP0) 

 