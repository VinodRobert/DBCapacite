/****** Object:  Procedure [dbo].[sp_UseStringList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[sp_UseStringList]
    @list StringListCredNumber READONLY
AS
BEGIN
    -- Just return the items we passed in
    SELECT l.CredNumber FROM @list l;
END