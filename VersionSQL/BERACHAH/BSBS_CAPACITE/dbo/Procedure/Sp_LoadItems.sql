/****** Object:  Procedure [dbo].[Sp_LoadItems]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_LoadItems]
	-- Add the parameters for the stored procedure here
	@StkStore nvarchar(10),
	@borgid nvarchar(20)
AS
BEGIN
declare @sql nvarchar(4000)
set @sql ='select StkStore,StkCode,stkdesc,stkunit from INVENTORY  where StkStore ='''+@StkStore+''' and borgid='''+@borgid+'''  order by StkCode'
exec(@sql)

	
END