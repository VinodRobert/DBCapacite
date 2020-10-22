/****** Object:  Procedure [BS].[spUpdateGSTPercentage]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   PROCEDURE [BS].[spUpdateGSTPercentage]
as
DECLARE @TBORGID INT
DECLARE @ORDID INT
DECLARE @LINENUMBER INT
DECLARE @VATID VARCHAR(15)
DECLARE @PERCENTAGE DECIMAL(18,2)
DECLARE @GSTGROUP VARCHAR(2)
DECLARE @GSTSTRING VARCHAR(15)

SELECT TBORGID,OI.ORDID,LINENUMBER,  LTRIM(RTRIM(VATID)) GSTIDS INTO #GSTIDS FROM ORDITEMS OI
INNER JOIN ORD O ON O.ORDID = OI.ORDID 
WHERE O.RECTYPE IN ( 'STD') AND 
        CATORTENDITEM <>9  AND VATAMOUNT>0 AND VATID LIKE '%G%' 
ALTER TABLE #GSTIDS ADD PERCENTAGE DECIMAL(8,2)
ALTER TABLE #GSTIDS ADD GSTGROUP VARCHAR(2)
 
DECLARE VATGP CURSOR FOR SELECT * FROM #GSTIDS 
OPEN VATGP 
FETCH NEXT FROM VATGP INTO @TBORGID,@ORDID,@LINENUMBER,@VATID,@PERCENTAGE,@GSTGROUP 

WHILE @@FETCH_STATUS =0
BEGIN
  SELECT S.ITEMS INTO #TEMP FROM DBO.SPLIT(@VATID,',') S WHERE S.ITEMS IS NOT NULL 
  DELETE FROM #TEMP WHERE ITEMS =''
  SELECT TOP 1  @GSTSTRING =LTRIM(RTRIM(ITEMS)) FROM #TEMP 
 
  UPDATE #GSTIDS SET GSTIDS = @GSTSTRING WHERE TBORGID=@TBORGID AND ORDID =@ORDID AND LINENUMBER=@LINENUMBER  

  FETCH NEXT FROM VATGP INTO @TBORGID,@ORDID,@LINENUMBER,@VATID,@PERCENTAGE,@GSTGROUP 
  DROP TABLE #TEMP 
END

CLOSE VATGP
DEALLOCATE VATGP

 


UPDATE #GSTIDS SET PERCENTAGE = VATPERC,GSTGROUP=VATGC  FROM VATTYPES 
INNER JOIN  #GSTIDS ON LEFT(#GSTIDS.GSTIDS,2)=VATTYPES.VATID  AND #GSTIDS.TBORGID = VATTYPES.BORGID WHERE LEFT(VATGC,1)='G'
UPDATE #GSTIDS SET PERCENTAGE = 2*PERCENTAGE WHERE GSTGROUP NOT IN ('G3','G6','G9' ) 

--ALTER TABLE #GSTIDS ADD REQID INT
--UPDATE #GSTIDS SET REQID = ORD.REQID FROM ORD INNER JOIN #GSTIDS ON #GSTIDS.ORDID=ORD.ORDID 

DELETE  FROM #GSTIDS WHERE GSTGROUP IS NULL

 

UPDATE ORDITEMS    SET VATPERC = PERCENTAGE ,CATORTENDITEM = 9 FROM #GSTIDS 
INNER JOIN ORDITEMS ON ORDITEMS.ORDID=#GSTIDS.ORDID AND ORDITEMS.LINENUMBER=#GSTIDS.LINENUMBER 

DROP TABLE #GSTIDS 