/****** Object:  Procedure [BT].[spDeleteSalesDetails]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [BT].[spDeleteSalesDetails](@PROJECTCODE INT)
AS
DELETE FROM BT.SALESSPREAD  WHERE PROJECTCODE=@PROJECTCODE
DELETE FROM BT.SALES        WHERE PROJECTCODE=@PROJECTCODE 