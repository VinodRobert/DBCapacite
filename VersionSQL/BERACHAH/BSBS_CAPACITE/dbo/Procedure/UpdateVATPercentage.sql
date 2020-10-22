/****** Object:  Procedure [dbo].[UpdateVATPercentage]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure UpdateVATPercentage
as
-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update ReqItems set vatperc = (vatamount/(qty*price * ( (100-discount)/100)  ))*100 where vatamount>0  and [dbo].[ufn_CountChar] ( vatid, ':' )=1 