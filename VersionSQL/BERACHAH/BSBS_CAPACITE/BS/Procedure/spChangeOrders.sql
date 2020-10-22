/****** Object:  Procedure [BS].[spChangeOrders]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spChangeOrders
AS
DECLARE @ORDID INT
DECLARE @ORIGINALORDERNUMBER VARCHAR(50)
DECLARE @AMENDMENTNUMBER INT 
DECLARE @ORIGINALORDID INT
DECLARE @RECONID INT 
DECLARE @ACCBOQHEADID INT 
DECLARE @AMENDMENTORDERNUMBER VARCHAR(25)
DECLARE @STARTID INT 
DECLARE @DETAIIDS INT 
DECLARE @COUNTER INT 
DECLARE @LINENUMBER VARCHAR(10) 
DECLARE @DETAILIDS INT 

DECLARE CHANGEORDERS CURSOR FOR 
   SELECT ORDID FROM ORD WHERE RECTYPE='CO' AND SENDATTTOSUPP=0 

OPEN CHANGEORDERS
FETCH NEXT FROM CHANGEORDERS INTO @ORDID 
WHILE @@FETCH_STATUS = 0
BEGIN
  SELECT @AMENDMENTORDERNUMBER = ORDNUMBER FROM ORD WHERE ORDID=@ORDID 
  SELECT @ORIGINALORDERNUMBER = SCORDNUMBER  FROM REQ WHERE REQID = (SELECT REQID FROM ORD WHERE ORDID = @ORDID )
  SELECT @ORIGINALORDID = ORDID FROM ORD WHERE ORDNUMBER=@ORIGINALORDERNUMBER
  SELECT @AMENDMENTNUMBER = SENDATTTOSUPP FROM ORD WHERE ORDID = @ORIGINALORDID
  SET    @AMENDMENTNUMBER = @AMENDMENTNUMBER + 1

  SELECT @RECONID = ISNULL(RECONID,0) FROM SUBCRECONS WHERE Orderno=@ORIGINALORDERNUMBER 
  SELECT @ACCBOQHEADID = HEADERID FROM ACCBOQHEADER WHERE RECONID=@RECONID 
  SELECT @ACCBOQHEADID 
  SELECT @STARTID  = DETAILID FROM ACCBOQDETAIL WHERE DESCRIPTION LIKE 'VARIATION ORDER%' 

  UPDATE ACCBOQDETAIL SET DESCRIPTION = 'Amendment'+STR(@AMENDMENTNUMBER)+'  Order Number' + LTRIM(RTRIM(@AMENDMENTORDERNUMBER)) WHERE DETAILID=@STARTID 
  DECLARE RECONDETAILS CURSOR FOR SELECT  DETAILID FROM ACCBOQDETAIL WHERE DETAILID>@STARTID AND HEADERID = @ACCBOQHEADID AND RECONHISTID = -1
  OPEN RECONDETAILS
  FETCH NEXT FROM RECONDETAILS INTO @DETAILIDS
  SET @COUNTER = 0
  WHILE @@FETCH_STATUS = 0 
  BEGIN
        SET @COUNTER = @COUNTER+1
        SELECT @LINENUMBER = 'Amd.'+LTRIM(RTRIM(@AMENDMENTNUMBER))+'.'+LTRIM(RTRIM(STR(@COUNTER,2))) 
		SELECT @LINENUMBER 
		UPDATE ACCBOQDETAIL SET [doc ref]=@LINENUMBER, QUANTITY=[prog QTY],[final QTY]=[prog QTY]  WHERE DETAILID=@DETAILIDS 
		FETCH NEXT FROM RECONDETAILS INTO @DETAILIDS
  END
  CLOSE RECONDETAILS
  DEALLOCATE RECONDETAILS
  UPDATE ORD SET SENDATTTOSUPP=1 WHERE ORDID=@ORDID 

  FETCH NEXT FROM CHANGEORDERS INTO @ORDID 
END
CLOSE CHANGEORDERS
DEALLOCATE CHANGEORDERS

 