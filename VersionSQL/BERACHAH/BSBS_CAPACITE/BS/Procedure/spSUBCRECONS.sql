/****** Object:  Procedure [BS].[spSUBCRECONS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spSUBCRECONS]
AS

--DECLARE @ORGID INT
--DECLARE @SUBCONUMBER INT
--DECLARE @CONTRACT VARCHAR(10)
--DECLARE @USERID VARCHAR(15)
--DECLARE @ORDERNO VARCHAR(25)
--DECLARE @COUNTERS INT

--DECLARE @MAXID  INT

--SELECT ORGID,SUBCONNUMBER,CONTRACT,USERID,ORDERNO,COUNT(*) COUNTERS 
--INTO #TEMP1 
--FROM SUBCRECONS 
--WHERE CODE='PO' AND ORGID<>1 
--GROUP BY ORGID,SUBCONNUMBER,CONTRACT,USERID,ORDERNO
--HAVING COUNT(*)>1

--DECLARE DUPLICATES CURSOR 
--FOR SELECT * FROM #TEMP1 

--OPEN DUPLICATES
--FETCH NEXT FROM DUPLICATES INTO @ORGID,@SUBCONUMBER,@CONTRACT,@USERID,@ORDERNO,@COUNTERS 
--WHILE @@FETCH_STATUS = 0
--BEGIN

--  SELECT @MAXID = MAX(RECONID) FROM SUBCRECONS WHERE 
--  ORGID=@ORGID AND
--  SUBCONNUMBER=@SUBCONUMBER AND
--  CONTRACT = @CONTRACT AND
--  USERID = @USERID AND
--  ORDERNO = @ORDERNO AND
--  CODE='PO' 

--  UPDATE SUBCRECONS SET ORGID=1  WHERE RECONID=@MAXID 

--  FETCH NEXT FROM DUPLICATES INTO @ORGID,@SUBCONUMBER,@CONTRACT,@USERID,@ORDERNO,@COUNTERS
--END

--CLOSE DUPLICATES
--DEALLOCATE DUPLICATES