/****** Object:  Procedure [BT].[AddEditDPRPictures]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[AddEditDPRPictures](@PROJECTCODE INT,@DPRDATESTRING VARCHAR(15),@NARRATION VARCHAR(100),@PICTURE IMAGE,@PATH VARCHAR(100)) 
AS
DECLARE @DPRDATE DATETIME
SET @DPRDATE = CONVERT(DATETIME,@DPRDATESTRING,103)
SET @PATH = '/WEBDPR-PUBLISH'+@PATH 
INSERT INTO BT.DPRIMAGE(PROJECTID,DPRDATE,NARRATION,PICTURE,PATH) 
VALUES (@PROJECTCODE,@DPRDATE,@NARRATION,@PICTURE,@PATH) 

 