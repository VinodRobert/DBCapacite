/****** Object:  Procedure [BT].[spReplaceWorkOrderItems]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BT.spReplaceWorkOrderItems(@PROJECTID INT,@OLDTEMPLATEID VARCHAR(15),@NEWTEMPLATEID VARCHAR(15),@SUCCESS INT)
AS
DECLARE @BORGID INT
DECLARE @CHECKNEWTOOLCODE INT
SET @CHECKNEWTOOLCODE=0
SELECT @CHECKNEWTOOLCODE = COUNT(*) FROM BT.WORKORDERITEMS WHERE PROJECT=@PROJECTID AND TOOLCODE=@NEWTEMPLATEID
IF @CHECKNEWTOOLCODE = 0 
 BEGIN
   SET @SUCCESS=0
   RETURN
 END
ELSE
 BEGIN
   SELECT @BORGID = BORGID FROM BT.PROJECTS WHERE PROJECTID=@PROJECTID 
   UPDATE TENDERITEMS SET RESCODE=@NEWTEMPLATEID
     WHERE RESCODE=@OLDTEMPLATEID AND BORG=@BORGID
   UPDATE BT.WORKORDER SET MINORWORKHEADID = @NEWTEMPLATEID 
     WHERE PROJECTCODE=@PROJECTID AND MINORWORKHEADID = @OLDTEMPLATEID
   UPDATE BT.WORKORDERITEMS SET TOOLCODE=@NEWTEMPLATEID 
     WHERE PROJECT=@PROJECTID AND TOOLCODE=@NEWTEMPLATEID 
   SET @SUCCESS = 1
   RETURN
 END 
   