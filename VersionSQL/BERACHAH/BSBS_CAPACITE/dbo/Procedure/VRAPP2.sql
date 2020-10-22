/****** Object:  Procedure [dbo].[VRAPP2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE  VRAPP2
AS
DECLARE @PLANTNO VARCHAR(15)
DECLARE @PERIOD INT

DECLARE ASSETS CURSOR FOR SELECT PLANTNO,PERIOD FROM VRAPP
OPEN ASSETS

FETCH NEXT FROM ASSETS  INTO @PLANTNO,@PERIOD

WHILE @@FETCH_STATUS = 0
BEGIN
  DELETE FROM ASSETPOSTS WHERE PLANTNO =@PLANTNO AND PERIOD=@PERIOD 
  FETCH NEXT FROM ASSETS INTO @PLANTNO,@PERIOD
END
CLOSE ASSETS
DEALLOCATE ASSETS