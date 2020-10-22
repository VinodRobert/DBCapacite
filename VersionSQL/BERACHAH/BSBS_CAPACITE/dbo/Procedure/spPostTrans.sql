/****** Object:  Procedure [dbo].[spPostTrans]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker Botes
-- Create date: 2009/06/05
-- Description:	Balance checks the temporary transaction table 
--		Remove all WIP, RI and VAT lines then recalculates them on the fly. Need to do this to make the non reimbursable tax work 
--		Do the tax calculation and inserts to TaxTrans Tabel		
--		Then submits it to the live Transactions table
-- 2009-07-08 OAB Recalculate the vatDebit and VatCredit
--	The SP will now recalculate the VatDebt and VatCredit Values for the costable transactions   
-- 2009-07-08 oab Add @DoPrint  
--	Use this when you de-buck in SQL Management Studio the write out the contended of @TempTrans and #tempTax.
-- 2009-08-14 OAB If more than one reimbursable line was in taxTemp then vat debits and credits was calculated on the first line only.
--	 Fix this by adding the sum(tax) and group by on tempTransID 
-- 2009-08-25 OAB fix retiand Income posting
--	Split the Retained Income legs for Plant and Overheads into two separate insert statements. 
--	This is to ensure that if there are two cost legs send, one to Overheads  and one to Plant, that the posting will send two line items to the Balance sheet retained income accounts 
-- 2009-10-06 OAB replace table varialbe with Temp table.
--	to fix sql2000 error "EXECUTE cannot be used as a source when inserting into a table variable."
-- test
--2010-01-18 Matthew
--  Added check that the ledgercode and allocation that are inserted into the transactions table, match the ledgercode, allocation from the ledgercodes table
--2010-03-01 Matthew
--  Added code during the transactions insert to use the same matchref (transid) for all creditor/subbie and debtor controls, this is needed for WHT must match to payment leg
--  Also added variables to hold the control codes for creditors, debtors and sub contrators
--2010-04-26 Matthew
--   Changed balance check to only sum RI and WIP legs that are generated internally, so movement from or to RI ledger from other B/S becomes possible
--2010-09-08 KSN & SS
--changed from @Contracttemp, @Descriptiontemp, @DivIDtemp, @Plantnotemp
--not posting if iscostleg set to 0
--This change has not yet been fully tested.
--2011-08-31 Matthew
--   fix for imbalance issues on home currency when credit and debit values are zero
--2012-09-14 Matthew
--   Added context for log Master
--2013-06-14 Matthew
--   Added TranGrp to TRANSACTIONS insert
-- =============================================
CREATE PROCEDURE [dbo].[spPostTrans] (
	-- Add the parameters for the stored procedure here
	@TIndex as nvarchar(50),
	@_DEBIT money output,
	@_CREDIT money output,
	@_HOMECURR money output,
	@_RI money output,
	@_PO money output,
	@_WP money output,
	@_Cont money output,
	@_THERESULT nvarchar(200) output,
	@DoPrint bit output,
    @insertTaxControl bit = 1 output
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--select 'test'

    if @DoPrint is null
    begin
        set @DoPrint = 0
    end 
    if @insertTaxControl is null
    begin
        set @insertTaxControl = 1
    end

	declare @sql nvarchar(4000)
	declare @amount money
	declare @RIgl char(10)
	declare @WIPgl char(10)
	declare @count int
	declare @DescriptionTemp char(255) 
	declare @ContractTemp char(10)
	declare @PlantnoTemp char(10)
	declare @DivIDTemp int
	declare @VatCFrom char(10)
	declare @VatCTo char(10)
	declare @THERESULT nvarchar(200)
	
  declare @credctlF nvarchar(10)
  declare @credctlT nvarchar(10)
  declare @debtctlF nvarchar(10)
  declare @debtctlT nvarchar(10)
  declare @subctlF nvarchar(10)
  declare @subctlT nvarchar(10)
  declare @lastMatchRef nvarchar(10)
  declare @lastCredno nvarchar(10)

--select @TIndex

-- Declare variables to use with the Transaction table cursor 
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	declare @Debug int
	declare @OrgID int 
	declare @Year char(10) 
	declare @Period int 
	declare @PDate datetime
	declare @BatchRef char(10) 
	declare @TransRef char(10)
	declare @MatchRef char(10)
	declare @TransType char(10)
	declare @Allocation char(25)
	declare @LedgerCode char(10)
	declare @Contract nvarchar(10)
	declare @Activity char(10)
	declare @Description char(255) 
	declare @ForeignDescription char(255)
	declare @Currency nvarchar(3)
	declare @Debit money 
	declare @Credit money 
	declare @VatDebit money 
	declare @VatCredit money
	declare @Credno char(10) 
	declare @Store char(20)
	declare @Plantno char(10)
	declare @Stockno char(20)
	declare @Quantity numeric(23, 4)
	declare @Unit char(10)
	declare @Rate money 
	declare @ReqNo char(55) 
	declare @OrderNo char(55)
	declare @Age int 
	declare @SubConTran char(20) 
	declare @VATType varchar(250)
	declare @HomeCurrAmount money 
	declare @ConversionDate datetime 
	declare @ConversionRate money 
	declare @PaidFor bit
	declare @PaidToDate money
	declare @PaidThisPeriod money
	declare @WhtThisPeriod money
	declare @DiscThisPeriod money
	declare @ReconStatus int
	declare @UserID char(10)
	declare @DivID int
	declare @ForexVal money
	declare @HeadID char(10)
	declare @XGLCODE char(10) 
	declare @XVATA money
	declare @XVATT char(2)
	declare @DOCNUMBER nchar(50) 
	declare @WHTID int 
	declare @FBID int 
	declare @TransID int
	declare @IsCostLeg int
	declare @DlvrID int
  declare @tranGRP int
  declare @loopCntr int
  set @tranGRP = -1
  set @loopCntr = 0

  while @tranGRP <> (select TRANGRP from TRANGROUP) and @loopCntr < 50
  BEGIN
    select @tranGRP = TRANGRP + 1 from TRANGROUP
    update TRANGROUP set TRANGRP = @tranGRP 
    set @loopCntr = @loopCntr + 1
  END 

	if EXISTS (select name from tempdb..sysobjects  where name like N'@TempTrans')
	begin
		exec ('delete @TempTrans')
	end
	declare @TempTrans table
		(
			Debug int,
			OrgID int ,
			Year char(10) COLLATE SQL_Latin1_General_CP1_CI_AS  ,
			Period int,
			PDate datetime ,
			BatchRef char(10) COLLATE SQL_Latin1_General_CP1_CI_AS ,
			TransRef char(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
			MatchRef char(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
			TransType char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Allocation char(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
			LedgerCode char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Contract nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Activity char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Description char(255) COLLATE SQL_Latin1_General_CP1_CI_AS,
			ForeignDescription char(255) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Currency nvarchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Debit money,
			Credit money,
			VatDebit money,
			VatCredit money,
			Credno char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Store char(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Plantno char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Stockno char(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Quantity numeric(23, 4),
			Unit char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Rate money,
			ReqNo char(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
			OrderNo char(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
			Age int,
			TransID int,
			SubConTran char(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
			VATType varchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS,
			HomeCurrAmount money,
			ConversionDate datetime,
			ConversionRate money,
			PaidFor bit,
			PaidToDate money,
			PaidThisPeriod money,
			WhtThisPeriod money,
			DiscThisPeriod money,
			ReconStatus int,
			UserID char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			DivID int,
			ForexVal money,
			HeadID char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			XGLCODE char(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
			XVATA money,
			XVATT char(2) COLLATE SQL_Latin1_General_CP1_CI_AS,
			DOCNUMBER nchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
			WHTID int,
			FBID int,
			IsCostLeg int,
			DlvrID int,
			ISWIPLEG int default (0),
			ISRILEG int default (0)
		)
	--2009-10-06 OAB replace table varialbe with Temp table.
	--	to fix sql2000 error "EXECUTE cannot be used as a source when inserting into a table variable."
	--declare #tempTax table
	create table #TempTax
		(
			vatgc nvarchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS,  
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
			isSurcharge bit,
			TempTransID int
		)



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


	set @RIgl = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Retained Income' )
	set @WIPgl = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Work In Progress' )
	
	set @credctlF = (select top 1 CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Creditors')
    set @credctlT = (select top 1 CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Creditors')
    set @debtctlF = (select top 1 CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Debtors')
    set @debtctlT = (select top 1 CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Debtors')
    set @subctlF = (select top 1 CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Sub Contractors')
    set @subctlT = (select top 1 CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Sub Contractors')
    
    set @lastMatchRef = ''
    set @lastCredno = ''
    
--	select @RIgl as RI, @WIPgl as WIP
	
	set @sql = N'SET @TempTableCursor = CURSOR SCROLL  FOR 
				SELECT 
					Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
					Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
					Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
					ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
					UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID 
				FROM ##Transactions'+ @TIndex +';
				OPEN @TempTableCursor '

--@TempTrans
--##Transactions'+ @TIndex +'
--select @sql

	DECLARE @TempTableCursor CURSOR 
	EXEC sp_executesql
		@sql,
		 N'@TempTableCursor cursor OUTPUT', @TempTableCursor OUTPUT
	
	FETCH NEXT FROM @TempTableCursor
	into @Debug, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
		@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
		@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran, @VATType, @HomeCurrAmount,
		@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
		@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, @WHTID, @FBID, @TransID, @IsCostLeg, @DlvrID


	if 9 = ( select ENTERPRISE from Borgs where borgId = @OrgID ) 
	begin
	--	set @vatctl = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'General Sales Tax' )
		set @VatCFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'General Sales Tax' )
		set @VatCTo = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'General Sales Tax' )
	end
	else
	begin
	--	set @vatctl = ( select top 1  CONTROLTOGL from dbo.CONTROLCODES where CONTROLNAME = 'Value Added Tax' )
		set @VatCFrom = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Value Added Tax' )
		set @VatCTo = ( select top 1  CONTROLFROMGL from dbo.CONTROLCODES where CONTROLNAME = 'Value Added Tax' )
	end
--	select @VatCFrom as VatFrom, @VatCTo as VatTo

	WHILE @@FETCH_STATUS = 0
	begin
		
		
--		SELECT @Debug, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
--			@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
--			@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran, @VATType, @HomeCurrAmount,
--			@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
--			@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, @WHTID, @FBID, @TransID, @IsCostLeg, @DlvrID


-- Do not include RI, WIP and TAX legs legs the procedure will calculate them later 
		if (  @WIPgl <> @LedgerCode and @RIgl <> @LedgerCode) and not( @VatCFrom >= @LedgerCode and @VatCTo <= @LedgerCode)
		begin
			insert into @TempTrans(
					Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
					Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
					Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
					ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
					UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID 
					)
					values(
					@Debug, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
					@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
					@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran, @VATType, @HomeCurrAmount,
					@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
					@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, @WHTID, @FBID, @TransID, @IsCostLeg, @DlvrID
					)

			if @IsCostLeg <> 0
			begin
--2009-10-06 OAB replace table varialbe with Temp table.
--	to fix sql2000 error "EXECUTE cannot be used as a source when inserting into a table variable."
				set @amount = @Debit-@Credit
				insert into #tempTax exec [spPostTransTaxView] @amount, @vatType, @OrgID, @TransID, @Currency
				set @DescriptionTemp = @Description
				set @ContractTemp = @Contract
				set @PlantnoTemp = @Plantno
				set @DivIDTemp = @DivID
--2009-07-08 OAB Recalculate the vatDebit and VatCredit Legs Here
				declare @VatAmount as money
                set @VatAmount = 0

				SELECT @VatAmount = isnull(SUM(tax), 0)
				FROM #tempTax 
				WHERE TempTransID = @TransID --and isreimb = 1 and vatgc = 'ST'
				GROUP BY TempTransID

				update @TempTrans 
				set	 VatDebit = Case when @VatAmount > 0  then abs(@VatAmount)	else 0					end,
					 VatCredit = Case when @VatAmount > 0 then 0				else abs(@VatAmount)	end 
				where TransID = @TransID
			end 		
		end
		fetch next from @TempTableCursor
		into @Debug, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
			@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
			@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran, @VATType, @HomeCurrAmount,
			@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
			@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, @WHTID, @FBID, @TransID, @IsCostLeg, @DlvrID
	end

--	select * into BSBS_Temp.dbo.TempTrans from @TempTrans
--	select * into BSBS_Temp.dbo.tempTax from #tempTax

--select *
--FROM  @TempTrans Tr INNER JOIN
--		#tempTax Tx ON Tr.TransID = Tx.TempTransID AND Tx.isreimb = 0

--select Sum(tax), TempTransID
--from #tempTax
--where isreimb = 0 
--group by tempTransID

--Update the Reimbursable legs
--2009-08-14 OAB If more than one reimbursable line was in taxTemp then vat debits and credits was calculated on the first line only.
--	 Fix this by adding the sum(tax) and group by on tempTransID 
	UPDATE    @TempTrans
	SET	Debit = case when Debit > 0 and tax > 0 then Debit + abs(tax) else Debit  end,
		VatDebit = case when VatDebit > 0 and tax > 0 then VatDebit - abs(tax) else VatDebit end,
		Credit = case when Credit > 0 and tax < 0 then Credit + abs(tax) else Credit end,
		VatCredit = case when VatCredit > 0 and tax < 0 then VatCredit - abs(tax) else VatCredit end
	FROM  @TempTrans Tr INNER JOIN
		(select Sum(tax) as tax, TempTransID
			from #tempTax
			where isreimb = 0 
			group by tempTransID) as Tx ON Tr.TransID = Tx.TempTransID 

--Add the retained income and work in process legs 
-- contracts WIP
	set @count = 0
	SELECT	@Debit = case when SUM(Debit) - SUM(Credit) > 0 then  abs(SUM(Debit) - SUM(Credit)) else 0 end,
			@Credit = case when  SUM(Debit) - SUM(Credit) > 0 then 0 else  abs(SUM(Debit) - SUM(Credit)) end,
			@HomeCurrAmount = sum(HomeCurrAmount),
			@ForexVal = sum(ForexVal),
			@XVATA = sum(XVATA),
			@count = count(*) 
	FROM	@TempTrans
	where (Allocation = 'contracts')
	GROUP BY Allocation
--select @count as WIPcount
	if @count > 0
	begin
	insert into @TempTrans(
		Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
		Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
		Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
		ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
		UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID, ISWIPLEG
		)
		SELECT	999, @OrgID, @Year, @Period, @PDate, BATCHREF, TRANSREF, @MatchRef, @TransType, 'Balance Sheet', @WIPgl,
		@Contract, '', Rtrim(@Description)+ ' Work In Progress', RTrim(@Description)+ ' Work In Progress', @Currency, 
        case when SUM(Debit) - SUM(Credit) > 0 then abs(SUM(Debit) - SUM(Credit)) else 0 end, 
        case when SUM(Debit) - SUM(Credit) > 0 then 0 else abs(SUM(Debit) - SUM(Credit)) end, 
        0, 0, '',
		'', @Plantno, '', 0, '', 0, '', @OrderNo, 0, '', 'Z', sum(HomeCurrAmount),
		@ConversionDate, @ConversionRate, 0, 0, 0, 0, 0, 0,
		@UserID, @DivID, sum(ForexVal), NULL, @XGLCODE, sum(XVATA), @XVATT, @DOCNUMBER, -1, -1, @TransID, @IsCostLeg, @DlvrID, 1
	    FROM @TempTrans
	    where (Allocation = 'contracts')
        GROUP BY TRANSREF, BATCHREF
        --values(
		----2010-09-08 KSN & SS
		----changed from @Contracttemp, @Descriptiontemp, @DivIDtemp, @Plantnotemp
		--999, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, 'Balance Sheet', @WIPgl,
		--@Contract, '', Rtrim(@Description)+ ' Work In Progress', RTrim(@Description)+ ' Work In Progress', @Currency, @Debit, @Credit, 0, 0, '',
		--'', @Plantno, '', 0, '', 0, '', @OrderNo, 0, '', 'Z', @HomeCurrAmount,
		--@ConversionDate, @ConversionRate, 0, 0, 0, 0, 0, 0,
		--@UserID, @DivID, @ForexVal, NULL, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, -1, -1, @TransID, @IsCostLeg, @DlvrID, 1
		--)
	end

-- 2009-08-25 OAB fix retiand Income posting
-- Plant RI
	set @count = 0
	select @Debit = case when SUM(Debit) - SUM(Credit) > 0 then  abs(SUM(Debit) - SUM(Credit)) else 0 end,
			@Credit = case when  SUM(Debit) - SUM(Credit) > 0 then 0 else  abs(SUM(Debit) - SUM(Credit)) end,
			@HomeCurrAmount = sum(HomeCurrAmount),
			@ForexVal = sum(ForexVal),
			@XVATA = sum(XVATA),
			@count = count(*) 
	FROM         @TempTrans
	--where (Allocation in ( 'overheads', 'plant' ))
	where (Allocation in ( 'plant' ))
	GROUP BY Allocation
--select @count as Plant RI
	if @count > 0
	begin
	insert into @TempTrans(
		Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
		Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
		Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
		ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
		UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID, ISRILEG
        )
        SELECT	998, @OrgID, @Year, @Period, @PDate, BATCHREF, TRANSREF, @MatchRef, @TransType, 'Balance Sheet', @RIgl,
		'', '', IsNull(Rtrim(@DescriptionTemp),'')+ ' Retained Income on plant', RTrim(@Description)+ ' Retained Income', @Currency, 
        case when SUM(Debit) - SUM(Credit) > 0 then abs(SUM(Debit) - SUM(Credit)) else 0 end, 
        case when SUM(Debit) - SUM(Credit) > 0 then 0 else abs(SUM(Debit) - SUM(Credit)) end, 
        0, 0, '',
		'', '', '', 0, '', 0, '', @OrderNo, 0, '', 'Z', sum(HomeCurrAmount),
		@ConversionDate, @ConversionRate, 0, 0, 0, 0, 0, 0,
		@UserID, @DivID, sum(ForexVal), NULL, @XGLCODE, sum(XVATA), @XVATT, @DOCNUMBER, -1, -1, @TransID, @IsCostLeg, @DlvrID, 1
	    FROM @TempTrans
	    where (Allocation = 'plant')
        GROUP BY TRANSREF, BATCHREF

		--)
		--values(
		--998, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, 'Balance Sheet', @RIgl,
		--'', '', IsNull(Rtrim(@DescriptionTemp),'')+ ' Retained Income on plant', IsNull(RTrim(@DescriptionTemp),'')+ ' Retained Income ', @Currency, @Debit, @Credit, 0, 0, '',
		--'', '', '', 0, '', 0, '', @OrderNo, 0, '', 'Z', @HomeCurrAmount,
		--@ConversionDate, @ConversionRate, 0, 0, 0, 0, 0, 0,
		--@UserID, @DivID, @ForexVal, NULL, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, -1, -1, @TransID, @IsCostLeg, @DlvrID, 1
		--)
	end

-- 2009-08-25 OAB fix retiand Income posting
-- Overheads RI
	set @count = 0
	select @Debit = case when SUM(Debit) - SUM(Credit) > 0 then  abs(SUM(Debit) - SUM(Credit)) else 0 end,
			@Credit = case when  SUM(Debit) - SUM(Credit) > 0 then 0 else  abs(SUM(Debit) - SUM(Credit)) end,
			@HomeCurrAmount = sum(HomeCurrAmount),
			@ForexVal = sum(ForexVal),
			@XVATA = sum(XVATA),
			@count = count(*) 
	FROM         @TempTrans
	--where (Allocation in ( 'overheads', 'plant' ))
	where (Allocation in ( 'overheads' ))
	GROUP BY Allocation
--select @count as OverheadsRI
	if @count > 0
	begin
	insert into @TempTrans(
		Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
		Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
		Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
		ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
		UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID, ISRILEG
		)
		values(
		997, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, 'Balance Sheet', @RIgl,
		'', '', IsNull(Rtrim(@DescriptionTemp),'')+ ' Retained Income on overheads', IsNull(RTrim(@DescriptionTemp),'')+ ' Retained Income ', @Currency, @Debit, @Credit, 0, 0, '',
		'', '', '', 0, '', 0, '', @OrderNo, 0, '', 'Z', @HomeCurrAmount,
		@ConversionDate, @ConversionRate, 0, 0, 0, 0, 0, 0,
		@UserID, @DivID, @ForexVal, NULL, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, -1, -1, @TransID, @IsCostLeg, @DlvrID, 1
		)
	end

    if @insertTaxControl = 1 
    BEGIN
    --Now we add the Vat control legs
	    declare @TaxCursor cursor
	    declare @LgTc char(10), @TaxTc money, @VatGc nvarchar

	    SET @TaxCursor = CURSOR 
	    FOR 
		    SELECT     ledgercode, SUM(tax) AS VerPerLG, vatgc
		    FROM         #tempTax
		    WHERE     (isreimb = 1)
		    GROUP BY ledgercode, vatgc
	    open @TaxCursor

	    FETCH from @TaxCursor
	    into @LgTc, @TaxTc, @VatGc
    --select @LgTc as LgTc, @TaxTc as TaxTc, @VatGc as VatGc
	    WHILE @@FETCH_STATUS = 0 
	    BEGIN
    --	select @LgTc as LgTc, @TaxTc as TaxTc, @VatGc as VatGc
		    if @TaxTc > 0 
		    begin
			    Set @Debit = abs(@TaxTc)
			    set @Credit = 0
			    set @VatDebit = 0
			    set @VatCredit = 0
		    end
		    else
		    begin
			    Set @Debit = 0
			    set @Credit = abs(@TaxTc)
			    set @VatDebit = 0
			    set @VatCredit = 0
		    end

    --Do Vat controll legs here
		    insert into @TempTrans(
			    Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
			    Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
			    Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
			    ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
			    UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID 
			    )
			    values(
			    997, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, 'Balance Sheet', @LgTc,
			    @ContractTemp, '', Rtrim(@DescriptionTemp)+ ' Tax Leg ', RTrim(@DescriptionTemp)+ ' Tax Leg ', @Currency, @Debit, @Credit, 0, 0, '',
			    '', @PlantnoTemp, '', 0, '', 0, '', @OrderNo, 0, '', @VatGc, @ConversionRate * @TaxTc,
			    @ConversionDate, @ConversionRate, 0, 0, 0, 0, 0, 0,
			    @UserID, @DivIDTemp, @ForexVal, NULL, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, -1, -1, @TransID, @IsCostLeg, @DlvrID
			    )

		    FETCH NEXT FROM @TaxCursor
		    into @LgTc, @TaxTc, @VatGc

	    END
    END

	if @DoPrint = 1
	begin
		select * from @TempTrans
		select * from #tempTax
	end


--Now we have the temporary table back and we can do the balance check and posting as we have done before.
--	select * from @TempTrans


--START WITH THE BALANCE CHECK 
--===================================================================================================================================
--Setup Variables for the balance check
declare @dbt decimal(18,4), @crdt decimal(18,4), @homeCurr decimal(18,4)
set @dbt = 0
set @crdt = 0
set @homeCurr = 0

--PVC July Add back the difference to the first row to make input balance
--OAB 06/08/2007
--	Add the check for credit = 0, 
--	If the first transaction is a credit value the value of the HomeCurr is negative.
--	If we now subtract the rounding error from the non negative value we will double the error. 
--	The solution is to find the first debit transaction and subtract from this. 
--2010-03-29 Matthew
--  Change balance check to round to 4, for multi-decimal
--
-- =============================================

declare @HoldTransID int
declare @invalidLC bit
declare @missingLC nvarchar(55)

set @invalidLC = 0
set @missingLC = ''

select @homeCurr = Sum(case when credit <> 0 then -1 * HOMECURRAMOUNT else HOMECURRAMOUNT end)
from @TempTrans
where ALLOCATION = 'Balance Sheet' 
AND (DEBIT - CREDIT) <> 0

if @homeCurr <> 0
BEGIN
	SELECT Top 1 @HoldTransID = [TRANSID] from @TempTrans
	where ALLOCATION = 'Balance Sheet' and credit = 0
    AND (DEBIT - CREDIT) <> 0

	if @homeCurr > 0
	BEGIN
		UPDATE @TempTrans SET HomeCurrAmount = HomeCurrAmount - abs(@homeCurr)
		WHERE TRANSID = @HoldTransID
	END 
	ELSE 
	BEGIN
		UPDATE @TempTrans SET HomeCurrAmount = HomeCurrAmount + abs(@homeCurr)
		WHERE TRANSID = @HoldTransID
	END 
END 


--2011-01-18 Matthew ledgerCode check
if exists( 
 SELECT isnull(T.LEDGERCODE, '') 
 FROM @TempTrans T 
 LEFT OUTER JOIN LEDGERCODES L ON T.ALLOCATION = L.LedgerAlloc  
 AND T.LEDGERCODE = L.LEDGERCODE  
 WHERE isnull(L.LEDGERCODE, '-1') = '-1' 
) 
BEGIN 
 set @invalidLC = 1 

 SELECT @missingLC = isnull(T.LEDGERCODE, '') + ' - ' + isnull(T.ALLOCATION, '') 
 FROM @TempTrans T 
 LEFT OUTER JOIN LEDGERCODES L ON T.ALLOCATION = L.LedgerAlloc  
 AND T.LEDGERCODE = L.LEDGERCODE  
 WHERE isnull(L.LEDGERCODE, '-1') = '-1' 

 DELETE FROM T 
 FROM @TempTrans T 
 LEFT OUTER JOIN LEDGERCODES L ON T.ALLOCATION = L.LedgerAlloc  
 AND T.LEDGERCODE = L.LEDGERCODE  
 WHERE isnull(L.LEDGERCODE, '-1') = '-1' 
END 

--GET VALUES FOR
-- SUM OF DEBIT
-- SUM OF CREDIT
select @dbt = sum(DEBIT), @crdt = sum(CREDIT),
@homeCurr = Sum(case when credit <> 0 then -1 * HOMECURRAMOUNT else HOMECURRAMOUNT end)
from @TempTrans
where ALLOCATION = 'Balance Sheet' 


--Note Look at adding the intercompanny loan accounts to the B-check
--GET VALUES FOR 
--	RETAINED INCOME
--	WORK IN PROGRESS TRANSACTIONS
--	PLATNT AND OVERHEADS
--	CONTRACTS
DECLARE @RetainedIncome money, @PlantAndOver money, @WorkInProgress money, @Contracts money

SELECT  @RetainedIncome = (SUM(IsNull(Debit,0))- SUM(IsNull(Credit,0)) )
FROM @TempTrans
WHERE (LedgerCode = @RIgl)
AND ISRILEG = 1
set @RetainedIncome = IsNull(@RetainedIncome,0)

SELECT @PlantAndOver = (SUM(IsNull(Debit,0))- SUM(IsNull(Credit,0)))
FROM @TempTrans
WHERE (Allocation in ('Plant', 'Overheads') )
set @PlantAndOver = IsNull(@PlantAndOver,0)

SELECT @WorkInProgress = ( SUM(IsNull(Debit,0))- SUM(IsNull(Credit,0)) )
FROM @TempTrans
WHERE (LedgerCode = @WIPgl)
AND ISWIPLEG = 1
set @WorkInProgress = IsNull(@WorkInProgress,0)

SELECT @Contracts = (SUM(IsNull(Debit,0)) - SUM(IsNull(Credit,0)))
FROM @TempTrans
WHERE Allocation = 'Contracts' 
set @Contracts = IsNull(@Contracts,0)

-- Check to see if the Retain Income and Work in Progress accounts are the same. 
--	If they are, do this check, Plant + Overheads + Contacts = RI+WIP
--2010-05-11 Matthew - removed, no longer needed since isRILeg and isWIPLeg used
--if @WIPgl = @RIgl
--begin
--	set @PlantAndOver = @PlantAndOver + @Contracts --Plant + Overheads + Contacts
--	set @Contracts = @PlantAndOver	-- RI+WIP
--end

--NOW DO THE BALANCE CHECK 

if @invalidLC = 1 
begin 
    delete @TempTrans
	delete #tempTax
	set @THERESULT = 'Invalid, missing or miss-allocated Ledger Code found ['+ @missingLC +'].'
	select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
end
else if Round(@dbt, 4) <> Round(@crdt, 4) 
begin
	delete @TempTrans
	delete #tempTax
	set @THERESULT = 'Balance Sheet allocations are out of balance. Please check your input and recalculate.'
	select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
end
else if  Round(@homeCurr, 4) <> 0  
begin
	delete @TempTrans
	delete #tempTax
	set @THERESULT = 'There is a problem with the Foreign Currency calculation. Please check your input and recalculate.'
	select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
--	select @dbt as DEBIT, @crdt as CREDIT, @homeCurr as HOMECURR, @RetainedIncome as RI, @PlantAndOver as PO, @WorkInProgress as WP, @Contracts as Cont, 'There is a problem with the Foreign Currency calculation. Please check your input and recalculate. ' as THERESULT
end
else if  Round(@RetainedIncome, 4) <> Round(@PlantAndOver, 4) 
begin
	delete @TempTrans
	delete #tempTax
	set @THERESULT = 'The allocation to Retained Income is not balancing with the Sum of allocation to Plant and Overheads. Please check your input and recalculate.'
	select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
--	select @dbt as DEBIT, @crdt as CREDIT, @homeCurr as HOMECURR, @RetainedIncome as RI, @PlantAndOver as PO, @WorkInProgress as WP, @Contracts as Cont, 'The allocation to Retained Income is not balancing with the Sum of allocation to Plant and Overheads. Please check your input and recalculate.' as THERESULT
end
else if  Round(@WorkInProgress, 4) <> Round(@Contracts, 4)
begin
	delete @TempTrans
	delete #tempTax
	set @THERESULT = 'The allocation to Work In Progress is not balancing with the Sum of allocation to Contracts. Please check your input and recalculate.'
	select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
--	select @dbt as DEBIT, @crdt as CREDIT, @homeCurr as HOMECURR, @RetainedIncome as RI, @PlantAndOver as PO, @WorkInProgress as WP, @Contracts as Cont, 'The allocation to Work In Progress is not balancing with the Sum of allocation to Contracts. Please check your input and recalculate.' as THERESULT
end

--2010-01-18 Matthew
else if exists (select T.ledgercode from @TempTrans T left outer join LEDGERCODES L on upper(rtrim(T.LEDGERCODE)) = upper(rtrim(L.LEDGERCODE)) where upper(rtrim(T.ALLOCATION)) <> upper(rtrim(L.LEDGERALLOC)))
begin
	delete @TempTrans
	delete #tempTax
	set @THERESULT = 'The Ledger Code and Allocation are not correct. Please check your control codes, and ledger code inputs.'
	select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
--	select @dbt as DEBIT, @crdt as CREDIT, @homeCurr as HOMECURR, @RetainedIncome as RI, @PlantAndOver as PO, @WorkInProgress as WP, @Contracts as Cont, @THERESULT as THERESULT
end
else
begin

--@_DEBIT money output,
--@_CREDIT money output,
--@_HOMECURR money output,
--@_RI money output,
--@_PO money output,
--@_WP money output,
--@_Cont money output,
--@_THERESULT nvarchar(200) 
--===================================================================================================================================

-- IF THE BALANCE CHECK WAS SUCCESSFUL So DO THE POSTING NOW 
-- ***********************************************************************************************************************************

	BEGIN TRANSACTION

	declare @InsertCursor as cursor
	declare @tempInvId int
	declare @tempAmnt numeric(18, 4)
	declare @tempTaxType nvarchar(250)
	declare @tempBorg int
	declare @holdError int

  declare @ContextInfo varbinary(128) 
  declare @scope_identity varchar(128)
	
	SET @InsertCursor = CURSOR  
	FOR 
		SELECT 
			Debug, OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
			Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
			Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
			ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
			UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER, WHTID, FBID, TransID, IsCostLeg, DlvrID 
		FROM @TempTrans
		
	OPEN @InsertCursor 

	set @holdError = 0

	FETCH from @InsertCursor
	into @Debug, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
		@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
		@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran, @VATType, @HomeCurrAmount,
		@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
		@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, @WHTID, @FBID, @TransID, @IsCostLeg, @DlvrID 

	WHILE @@FETCH_STATUS = 0 and @holdError = 0
	BEGIN
	
		IF @holdError = 0
		BEGIN
			INSERT [TRANSACTIONS]
			(
			OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode,
			Contract, Activity, Description, ForeignDescription, Currency, Debit, Credit, VatDebit, VatCredit, Credno,
			Store, Plantno, Stockno, Quantity, Unit, Rate, ReqNo, OrderNo, Age, SubConTran, VATType, HomeCurrAmount,
			ConversionDate, ConversionRate, PaidFor, PaidToDate, PaidThisPeriod, WhtThisPeriod, DiscThisPeriod, ReconStatus,
			UserID, DivID, ForexVal, HeadID, XGLCODE, XVATA, XVATT, DOCNUMBER  , WHTID, FBID, TRANGRP --, TransID, IsCostLeg, DlvrID
			)
			values(
			@OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
			@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
			@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran,
			case when len(@VATType) <= 2 and replace(replace(@VATType,':',''),',','') = @VATType then @VATType else '*' end, @HomeCurrAmount,
			@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
			@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER , @WHTID, @FBID, @tranGRP --, @TransID, @IsCostLeg, @DlvrID

			)
			
			SET @holdError = @@ERROR
			SET @tempInvId = scope_identity()
		
		END

        --2010-03-01 Matthew
        IF @holdError = 0
		BEGIN
		    if @LedgerCode between @credctlF and @credctlT 
                OR @LedgerCode between @debtctlF and @debtctlT
                OR @LedgerCode between @subctlF and @subctlT
		    BEGIN  
		    
		        if @lastCredno <> @Credno or @lastMatchRef = ''
		        BEGIN
		            set @lastMatchRef = @tempInvId
		            set @lastCredno = @Credno
		        END 
		        
		        if @MatchRef <> ''
		        BEGIN
		            set @lastMatchRef = @MatchRef
		        END
		          /*
              INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @OrgID, 'ACC', 'spPostTrans.xml', '', '')
              set @scope_identity = scope_identity()
              SELECT @ContextInfo = cast(@scope_identity AS varbinary(128))
              SET CONTEXT_INFO @ContextInfo
              */
              
              update TRANSACTIONS set MATCHREF = @lastMatchRef where transid = @tempInvId
     
            END
            
		    SET @holdError = @@ERROR		    
		END 
		
		--set @amount = @Debit-@Credit
		--select @IsCostLeg as IsCostLeg
		if ( @IsCostLeg <> 0 and @holdError = 0 ) 
		BEGIN
			INSERT INTO TAXTRANS
				(TRANSID, VATGC, NAME, SEQUENCE, PERC, ISACCUM, ISREIMB, LEDGERCODE, TAX, CUMCOST, CUMTAX, VATTYPE, BORGID, 
				PROVINCEIDS, PROVINCEIDO, PROVINCEIDD, ISSURCHARGE, SURCHARGEAPPLIES)
			SELECT     @tempInvId, vatgc, name, sequence, perc, isaccum, isreimb, ledgercode, tax, cumCost, cumTax, vatType, borgid,
				-1,-1,-1, isSurcharge, surchargeApplies
			FROM         #tempTax AS TT
			where TT.TempTransID = @TransID and (NOT (VATGC IS NULL))
			SET @holdError = @@ERROR
			--exec @holdError = spPostTransTaxInsert @ledgerCode, @Credno, @OrgID, @DlvrID, @transID, @amount , @VATType
			--exec spInsertTaxTrans @transID, @vatctl, @tempAmnt, @tempTaxType, @tempBorg, @provinceidOrg, @provinceidOrg, @provinceidD

--INSERT INTO TAXTRANS
--          (TRANSID, VATGC, NAME, SEQUENCE, PERC, ISACCUM, ISREIMB, LEDGERCODE, TAX, CUMCOST, CUMTAX, VATTYPE, BORGID, PROVINCEIDS, PROVINCEIDO, 
--          PROVINCEIDD, ISSURCHARGE, SURCHARGEAPPLIES)
--SELECT     TRANSID, VATGC, NAME, SEQUENCE, PERC, ISACCUM, ISREIMB, LEDGERCODE, TAX, CUMCOST, CUMTAX, VATTYPE, BORGID, PROVINCEIDS, PROVINCEIDO, 
--          PROVINCEIDD, ISSURCHARGE, SURCHARGEAPPLIES
--FROM         TAXTRANS AS TAXTRANS_
			
		END
	
		--select @holdError as holdError
		
		fetch next from @InsertCursor
			into @Debug, @OrgID, @Year, @Period, @PDate, @BatchRef, @TransRef, @MatchRef, @TransType, @Allocation, @LedgerCode,
				@Contract, @Activity, @Description, @ForeignDescription, @Currency, @Debit, @Credit, @VatDebit, @VatCredit, @Credno,
				@Store, @Plantno, @Stockno, @Quantity, @Unit, @Rate, @ReqNo, @OrderNo, @Age, @SubConTran, @VATType, @HomeCurrAmount,
				@ConversionDate, @ConversionRate, @PaidFor, @PaidToDate, @PaidThisPeriod, @WhtThisPeriod, @DiscThisPeriod, @ReconStatus,
				@UserID, @DivID, @ForexVal, @HeadID, @XGLCODE, @XVATA, @XVATT, @DOCNUMBER, @WHTID, @FBID, @TransID, @IsCostLeg, @DlvrID 

	END
	delete @TempTrans
-- ***********************************************************************************************************************************


	CLOSE @TempTableCursor
	DEALLOCATE @TempTableCursor
	CLOSE @InsertCursor
	DEALLOCATE @InsertCursor


	if @holdError = 0 --1
	begin
		COMMIT TRANSACTION
	delete #tempTax
		set @THERESULT = 'OK'
		select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
--		select @dbt as DEBIT, @crdt as CREDIT, @homeCurr as HOMECURR, @RetainedIncome as RI, @PlantAndOver as PO, @WorkInProgress as WP, @Contracts as Cont, 'OK' as THERESULT
	end
	else --1
	begin
		ROLLBACK TRANSACTION
	delete #tempTax
		set @THERESULT = 'Error on Insert to transactions - ' + Cast(@@Error as nvarchar(20))
		select @_DEBIT = @dbt,  @_CREDIT = @crdt, @_HOMECURR = @homeCurr, @_RI = @RetainedIncome, @_PO =  @PlantAndOver, @_WP = @WorkInProgress, @_Cont = @Contracts, @_THERESULT = @THERESULT
--		select @dbt as DEBIT, @crdt as CREDIT, @homeCurr as HOMECURR, @RetainedIncome as RI, @PlantAndOver as PO, @WorkInProgress as WP, @Contracts as Cont, 'Error on Insert to transactions - ' + Cast(@@Error as nvarchar(20)) as THERESULT
	end --1

end

end				