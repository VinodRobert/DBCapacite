/****** Object:  Procedure [BS].[spClearSpecialCharacters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spClearSpecialCharacters
as
-- If Remark is having single quote this will get replaced by space
UPDATE SUBCRECONS 
SET REMARK = REPLACE(REMARK,'''',' ')