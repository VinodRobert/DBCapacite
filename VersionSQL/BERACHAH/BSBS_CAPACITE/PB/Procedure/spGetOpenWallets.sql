/****** Object:  Procedure [PB].[spGetOpenWallets]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [PB].[spGetOpenWallets](@LOGINID VARCHAR(15) ,@BORGID INT,@BANKID INT)
AS

DECLARE @REFERENCE VARCHAR(100)
DECLARE @NEXTNUMBER INT 
DECLARE @YEARREFERENCE VARCHAR(55) 
DECLARE @RTGSREFERENCE VARCHAR(100)
DECLARE @RTGSID INT 
DECLARE @LASTRTGSID INT 

DECLARE @OPENBATCH INT 
SET @OPENBATCH = 0
SELECT @OPENBATCH =ISNULL( COUNT(*),0) FROM PB.RTGSHEADER WHERE LOGINID=@LOGINID AND BORGID=@BORGID AND BANKID=@BANKID AND RTGSSTATUS= 0
 
IF @OPENBATCH = 0 
 BEGIN
   SELECT @REFERENCE=REFERENCE,@NEXTNUMBER=SERIALNUMBER,@YEARREFERENCE=YEARREFERENCE 
   FROM PB.PAYMENTBANKS WHERE BORGID=@BORGID AND BANKID=@BANKID 
   SET @NEXTNUMBER=@NEXTNUMBER+1 
   SET @RTGSREFERENCE  = LTRIM(RTRIM(@REFERENCE))+ LTRIM(RTRIM(@YEARREFERENCE))+'/'+LTRIM(RTRIM(STR(@NEXTNUMBER)))
    
   SELECT @LASTRTGSID =ISNULL( MAX(RTGSID),0) FROM PB.RTGSHEADER 
   SET @LASTRTGSID=@LASTRTGSID+1 
  
   INSERT INTO PB.RTGSHEADER(RTGSID,BORGID,LOGINID,BANKID,RTGSDATE,RTGSNUMBER,RTGSSTATUS)
   VALUES (@LASTRTGSID, @BORGID,@LOGINID,@BANKID,GETDATE(),@RTGSREFERENCE,0 )
 END
 
SELECT @RTGSID = RTGSID FROM PB.RTGSHEADER WHERE BORGID=@BORGID AND LOGINID=@LOGINID AND BANKID = @BANKID 
SELECT RTGSID,RTGSNUMBER,RTGSDATE FROM PB.RTGSHEADER WHERE RTGSID = @RTGSID
SELECT ISNULL(COUNT(*) ,0) FROM PB.RTGSDETAIL WHERE RTGSHeaderID = @RTGSID 
 

 