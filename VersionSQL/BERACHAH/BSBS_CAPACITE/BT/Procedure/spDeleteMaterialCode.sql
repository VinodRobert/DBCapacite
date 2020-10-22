/****** Object:  Procedure [BT].[spDeleteMaterialCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spDeleteMaterialCode](@TOOLCODE VARCHAR(10),@PROJECTCODE VARCHAR(10),@STATUSCODE INT OUTPUT)
AS
  DECLARE @STATUS INT 
  DECLARE @MATERIALID INT 
  DECLARE @RETURNSTATUS INT
  SET @RETURNSTATUS=0

 
  SELECT @STATUS = STATUS,@MATERIALID = MATERIALID 
         FROM BT.Material WHERE TOOLCODE=@TOOLCODE AND PROJECTCODE=@PROJECTCODE

   

  IF @STATUS = 0
     BEGIN
	    DELETE FROM BT.MATERIALSPREAD WHERE MATERIALCODE=@MATERIALID 
	    DELETE FROM BT.Material WHERE TOOLCODE=@TOOLCODE AND PROJECTCODE=@PROJECTCODE 
		SET @RETURNSTATUS=1
     END


  SET @STATUSCODE = @RETURNSTATUS 
   