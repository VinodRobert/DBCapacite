/****** Object:  Procedure [BT].[spAddEditEquipmentMaster]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BT].[spAddEditEquipmentMaster](@EQUIPMENTID INT,@PROJECTCODE INT,@EQUIPNUMBER VARCHAR(20),@EQUIPNAME VARCHAR(200),@MAKE VARCHAR(50),
@MODEL VARCHAR(50),@CAPACITY VARCHAR(50),@TYPE VARCHAR(50),@OWNER VARCHAR(50)) 
AS
DECLARE @NEXTNUMBER INT
IF @EQUIPMENTID = 0 
 BEGIN 
  SELECT @NEXTNUMBER =ISNULL( MAX(EQUIPMENTID),1000) FROM BT.EQUIPMENTMASTER WHERE PROJECTCODE=@PROJECTCODE AND OWNERID = 2 
  SET @NEXTNUMBER=@NEXTNUMBER+1
  INSERT INTO BT.EQUIPMENTMASTER(EQUIPMENTID,PROJECTCODE,EQUIPNUMBER,EQUIPNAME,MAKE,MODEL,CAPACITY,TYPE,SHIFTS,OWNERID,OWNER,CHECKINDATE,STATUS) 
  VALUES ( @NEXTNUMBER,@PROJECTCODE,UPPER(@EQUIPNUMBER),UPPER(@EQUIPNAME),UPPER(@MAKE),UPPER(@MODEL),UPPER(@CAPACITY),UPPER(@TYPE),1,2,UPPER(@OWNER),GETDATE(),1 )

 END
ELSE
 BEGIN
    UPDATE BT.EQUIPMENTMASTER
	SET EQUIPNAME=UPPER(@EQUIPNAME),MAKE =UPPER(@MAKE), MODEL =UPPER(@MODEL), CAPACITY =UPPER(@CAPACITY), TYPE =UPPER(@TYPE), 
	OWNER=UPPER(@OWNER) WHERE EQUIPMENTID =@EQUIPMENTID 

 END