/****** Object:  Procedure [dbo].[spPostTransTaxInsert]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 13-11-2008
-- Description:	returns a table from the Tax calculations 
-- Notes
-- 2009/06/10 OAB 
-- Adapted the procedure from spInsertTaxTrans 
-- This now forms part of the Balance check and multi Tax posting    
-- =============================================
CREATE PROCEDURE [dbo].[spPostTransTaxInsert] 
	-- Add the parameters for the stored procedure here	
	@ledgerCode char(10),
	@Credno char(10),
	@borgID int,
	@DlvrID int,
	@transID int,

	@amount numeric(18, 4),
	@vatType nvarchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @holdError int
	set @holdError = 0
	declare @provinceidS int	-- source
	declare @provinceidO int	-- origin
	declare @provinceidD int	-- destanasion

	declare @dctlFrom char(10), @dctlTo char(10), @cctlFrom char(10), @cctlTo char(10), @sctlFrom char(10), @sctlTo char(10)
	set @dctlFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Debtors' )
	set @dctlTo = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Debtors' )
	set @cctlFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Creditors' )
	set @cctlTo = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Creditors' )
	set @sctlFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Sub Contractors' )
	set @sctlTo = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Sub Contractors' )

--select 'GetProvID'

-- source
-- get provinceID for the source (DEBTOR, CREDITOR, SUBC or BORG)
--debtor
	if @dctlFrom >= @ledgerCode and @dctlTo <= @ledgerCode
	begin
		SELECT @provinceidS = isnull(DEBTORS.PROVINCEID, -1) FROM DEBTORS WHERE (DebtNumber = @Credno)
	end
--creditor
	else if @cctlFrom >= @ledgerCode and @cctlTo <= @ledgerCode
	begin
		SELECT @provinceidS = isnull(PROVINCEID, -1) FROM CREDITORS WHERE (CredNumber = @Credno)	
	end
--subc
	else if @sctlFrom >= @ledgerCode and @sctlTo <= @ledgerCode
	begin
		SELECT  @provinceidS = isnull(PROVINCEID, -1) FROM SUBCONTRACTORS WHERE (SubNumber = @Credno)
	end
	else 
	begin
		set @provinceids = -1
	end

-- origin
--get provinceID for the organisation or origin/transaction company
	SELECT @provinceidO = isnull(provinceid, -1)
	FROM BORGS 
	INNER JOIN BILLTOADDRESSES
	ON BORGS.BILLTO = BILLTOADDRESSES.BILLTOID
	INNER JOIN COMPADDRESSES
	ON BILLTOADDRESSES.ADDRESSID = COMPADDRESSES.ADDRID
	WHERE BORGID = @borgID

--get provinceID for the Supplier or source 
	SELECT   @provinceidD =  Isnull(PROVINCEID,-1)
	FROM         DELIVERIES INNER JOIN
						  ORDITEMS ON DELIVERIES.ORDID = ORDITEMS.ORDID AND DELIVERIES.ORDITEMLINENO = ORDITEMS.LINENUMBER INNER JOIN
						  SHIPTOADDRESSES ON ORDITEMS.DLVRID = SHIPTOADDRESSES.SHIPTOID INNER JOIN
						  COMPADDRESSES ON SHIPTOADDRESSES.ADDRID = COMPADDRESSES.ADDRID
	WHERE     (DELIVERIES.DLVRID = @DlvrID)


--create temp table
	create table #temp
	(
	 vatgc nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS,  
	 [name] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	 sequence int, 
	 perc numeric(18, 4), 
	 isaccum bit, 
	 isreimb bit, 
	 ledgercode nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	 tax numeric(18, 4), 
	 cumCost numeric(18, 4),
	 cumTax numeric(18, 4),
	 vatType char(2),
	 borgid int, 
	 surchargeApplies bit, 
	 isSurcharge bit
	)

--populate the temp table using stored procedure
	
	select @amount, @vatType, @borgID
	insert into #temp
	EXEC [spPostTransTaxView] @amount, @vatType, @borgID
	

--insert the calculated vats into the TAXTRANS table
	IF @holdError = 0
	BEGIN
		insert into TAXTRANS (
		 TRANSID, VATGC, [name], SEQUENCE, PERC,
		 ISACCUM, ISREIMB, LEDGERCODE, TAX, CUMCOST,
		 CUMTAX, VATTYPE, BORGID,
		 PROVINCEIDS, PROVINCEIDO, PROVINCEIDD,
		 SURCHARGEAPPLIES, ISSURCHARGE
		 )
		select
		 @transid, vatgc, [name], sequence, perc, 
		 isaccum, isreimb, ledgercode, tax, cumCost,
		 cumTax, vatType, borgid,
		 @provinceids, @provinceido, @provinceidd,
		 SURCHARGEAPPLIES, ISSURCHARGE
		from #temp
		where VATTYPE is not null
		SET @holdError = @@ERROR
	END

-- Return Erro code	
	return 	@holdError
--remove the temp table
	drop table #temp
END
		