/****** Object:  Procedure [dbo].[spPostTransProvinceID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Okker Botes
-- Create date: 2009-06-09
-- Description:	Returns the province ID's to spPostTrans. Used in the multi tax posting 
-- Notes
-- 2009/06/10 OAB 
-- Adapted the procedure from spInsertTaxTrans 
-- This now forms part of the Balance check and multi Tax posting    
-- =============================================
CREATE PROCEDURE [dbo].[spPostTransProvinceID] 
	-- Add the parameters for the stored procedure here	
	@ledgerCode char(10),
	@Credno char(10),
	@DlvrID int	,
	@OrgID int,

	@provinceidS int output,	-- source
	@provinceidO int output,	-- origin
	@provinceidD int output		-- destanasion
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @HoldError int
	set @HoldError = 0

	declare @dctlFrom char(10), @dctlTo char(10), @cctlFrom char(10), @cctlTo char(10), @sctlFrom char(10), @sctlTo char(10)
	set @dctlFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Debtors' )
	if @@error <> 0 return @@error
	set @dctlTo = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Debtors' )
	if @@error <> 0 return @@error
	set @cctlFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Creditors' )
	if @@error <> 0 return @@error
	set @cctlTo = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Creditors' )
	if @@error <> 0 return @@error
	set @sctlFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Sub Contractors' )
	if @@error <> 0 return @@error
	set @sctlTo = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Sub Contractors' )
	if @@error <> 0 return @@error

--select 'GetProvID'

-- source
-- get provinceID for the source (DEBTOR, CREDITOR, SUBC or BORG)
--debtor
	if @dctlFrom >= @ledgerCode and @dctlTo <= @ledgerCode
	begin
		SELECT @provinceidS = isnull(DEBTORS.PROVINCEID, -1) FROM DEBTORS WHERE (DebtNumber = @Credno)
		if @@error <> 0 return @@error
	end
--creditor
	else if @cctlFrom >= @ledgerCode and @cctlTo <= @ledgerCode
	begin
		SELECT @provinceidS = isnull(PROVINCEID, -1) FROM CREDITORS WHERE (CredNumber = @Credno)	
		if @@error <> 0 return @@error
	end
--subc
	else if @sctlFrom >= @ledgerCode and @sctlTo <= @ledgerCode
	begin
		SELECT  @provinceidS = isnull(PROVINCEID, -1) FROM SUBCONTRACTORS WHERE (SubNumber = @Credno)
		if @@error <> 0 return @@error
	end
	else 
	begin
		set @provinceids = -1
		if @@error <> 0 return @@error
	end

-- origin
--get provinceID for the organisation or origin/transaction company
	SELECT @provinceidO = isnull(provinceid, -1)
	FROM BORGS 
	INNER JOIN BILLTOADDRESSES
	ON BORGS.BILLTO = BILLTOADDRESSES.BILLTOID
	INNER JOIN COMPADDRESSES
	ON BILLTOADDRESSES.ADDRESSID = COMPADDRESSES.ADDRID
	WHERE BORGID = @OrgID
	if @@error <> 0 return @@error

--get provinceID for the Supplier or source 
	SELECT   @provinceidD =  Isnull(PROVINCEID,-1)
	FROM         DELIVERIES INNER JOIN
						  ORDITEMS ON DELIVERIES.ORDID = ORDITEMS.ORDID AND DELIVERIES.ORDITEMLINENO = ORDITEMS.LINENUMBER INNER JOIN
						  SHIPTOADDRESSES ON ORDITEMS.DLVRID = SHIPTOADDRESSES.SHIPTOID INNER JOIN
						  COMPADDRESSES ON SHIPTOADDRESSES.ADDRID = COMPADDRESSES.ADDRID
	WHERE     (DELIVERIES.DLVRID = @DlvrID)
	if @@error <> 0 return @@error

	return 0
END
		