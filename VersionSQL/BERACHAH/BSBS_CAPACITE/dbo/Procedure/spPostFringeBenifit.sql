/****** Object:  Procedure [dbo].[spPostFringeBenifit]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker Botes
-- Create date: 2009/06/18
-- Description:	Posts Fringe benefit tax to a separate account, which is not the same for all FB's.  
--  I added a cost-to LG code to the TaxFB table. (I did not want to add more Control codes )
--	I changed the asp posting to the spPostFringeBenifit stored procedure.  
--  This stored procedure makes use of the spPostTrans SP to do the balance check and commit the transaction to the transaction table. 
-- 2009-08-25 OAB
--	Uncoment select 'NO' after the rollback.
--2010-03-29 Matthew
--  Round decimals from currencies.decimals for multi-decimal changes
--2012-09-14 Matthew
--   Added context for log Master
--
-- =============================================

CREATE PROCEDURE [dbo].[spPostFringeBenifit]
	@borgid as int  = 2,
	@year as int = '2009', 
	@period as int = 1, 
	@Cperiod as int = 1, 
	@username as nvarchar(10) = 'Account Ad', 
	@userid as int = 23
	
AS
	SET NOCOUNT ON 
	BEGIN TRANSACTION		
	declare @fbRate as numeric(18, 4) 
	declare @controlLedgerCode as nvarchar(10) 
	declare @controlAllocation as nvarchar(15)  
	declare @fbAmount as numeric(18, 4) 
	declare @fbLedgerCode as nvarchar(10) 
	declare @fbAllocation as nvarchar(15) 
	declare @fbLedgerCodeTemp as nvarchar(10) 
	declare @fbAllocationTemp as nvarchar(15)
	
	declare @fbid as int 
	declare @fbDescr as nvarchar(250) 
	declare @currency as nvarchar(3) 
	declare @thePeriod as int 
	declare @theYear as nvarchar(10) 
	declare @contract as nvarchar(10) 
	declare @plantno as nvarchar(10) 
	declare @activity as nvarchar(10) 
	declare @divid as int 
	declare @holdError as int

  declare @ContextInfo varbinary(128) 
  declare @scope_identity varchar(128)

	EXEC [dbo].[spPostTransCreatTemp] @TIndex = N'FB', @MakeLocal = 0
	
	set @holdError = 0

	SELECT @fbRate = ROUND(TAXRATEFB / 100,2) 
	FROM BORGS 
	WHERE BORGID = @borgid 

	select @controlLedgerCode = CONTROLCODES.CONTROLFROMGL, @controlAllocation = LEDGERCODES.LEDGERALLOC 
	from CONTROLCODES INNER JOIN LEDGERCODES ON LEDGERCODES.LedgerCode = CONTROLCODES.ControlFromGL 
	where CONTROLCODES.CONTROLNAME = 'Fringe Benefit' 

	DECLARE FB_Cursor CURSOR 
	FOR 
	SELECT round(sum(TRANSACTIONS.Debit - TRANSACTIONS.Credit) * TAXFB.CONSIDER / 100 * @fbRate, isnull(CURRENCIES.DECIMALS, 2)) as FBAMOUNT, TAXFB.LEDGERCODE,
	 TAXFB.FBID, TAXFB.DESCRIPTION, LEDGERCODES.LEDGERALLOC, TRANSACTIONS.PERIOD, TRANSACTIONS.YEAR, TRANSACTIONS.CURRENCY, 
	 case when LEDGERCODES.LEDGERALLOC = 'Contracts' then TRANSACTIONS.CONTRACT else '' end as contract,
	 case when LEDGERCODES.LEDGERALLOC = 'Plant' then TRANSACTIONS.PLANTNO else '' end as plantno,
	 case when LEDGERCODES.LEDGERALLOC = 'Contracts' then TRANSACTIONS.ACTIVITY else '' end as activity,
	 case when LEDGERCODES.LEDGERALLOC = 'Overheads' then TRANSACTIONS.DIVID else -1 end as divid 
	FROM TRANSACTIONS INNER JOIN TAXFB ON TRANSACTIONS.LedgerCode = TAXFB.LEDGERCODE 
	INNER JOIN LEDGERCODES ON LEDGERCODES.LedgerCode = TAXFB.LEDGERCODE 
	LEFT OUTER JOIN CURRENCIES ON TRANSACTIONS.CURRENCY = CURRENCIES.CURRCODE
	WHERE ISNULL(TRANSACTIONS.FBID, -1) = -1 and 
	 ( ( TRANSACTIONS.YEAR = @year and TRANSACTIONS.PERIOD = @Cperiod ) ) 
	 and ORGID = @borgid 
	group by TAXFB.LEDGERCODE, TAXFB.DESCRIPTION, TAXFB.CONSIDER, TAXFB.FBID, LEDGERCODES.LEDGERALLOC, 
	 TRANSACTIONS.PERIOD, TRANSACTIONS.YEAR, TRANSACTIONS.CURRENCY, CURRENCIES.DECIMALS,
	 case when LEDGERCODES.LEDGERALLOC = 'Contracts' then TRANSACTIONS.CONTRACT else '' end,
	 case when LEDGERCODES.LEDGERALLOC = 'Plant' then TRANSACTIONS.PLANTNO else '' end,
	 case when LEDGERCODES.LEDGERALLOC = 'Contracts' then TRANSACTIONS.ACTIVITY else '' end,
	 case when LEDGERCODES.LEDGERALLOC = 'Overheads' then TRANSACTIONS.DIVID else -1 end 

	open FB_Cursor
	 FETCH next FROM FB_Cursor into
		@fbAmount, @fbLedgerCode, @fbid, @fbDescr, @fbAllocation, @thePeriod, @theYear, @currency, 
		@contract, @plantno, @activity, @divid 

	declare @count int
	WHILE @@FETCH_STATUS = 0 
	BEGIN -- Cursore

--select @controlLedgerCode as LgCode, @controlAllocation as Allc, @fbLedgerCode as FbLG
--If no row is returned by the above query then there is no FB to cost GL declared, so send cost to originating GL 
		set @count = 0
		SELECT    @fbLedgerCodeTemp =  TAXFB.LedgerCodeCostTo, @fbAllocationTemp = LEDGERCODES.LedgerAlloc, @count = COUNT(*)
		FROM  LEDGERCODES INNER JOIN 
			TAXFB ON LEDGERCODES.LedgerCode = TAXFB.LedgerCodeCostTo
		WHERE        (TAXFB.LEDGERCODE = @fbLedgerCode)
		GROUP BY TAXFB.LedgerCodeCostTo, LEDGERCODES.LedgerAlloc

	--select @count as count
	--2009-06-18 
		if @count = 0
		begin
	--		select 'test'
			set @fbLedgerCodeTemp = @fbLedgerCode
			set @fbAllocationTemp = @fbAllocation
		end 

	--select @fbLedgerCodeTemp as LgCodeTemp, @fbAllocationTemp as AllcTemp, @fbLedgerCode as FbLG
		
		if @fbAmount <> 0
		BEGIN
			if @holdError = 0 -- testing and 1 = 0
			begin
        /*
        INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @borgid, 'ACC', 'spPostTrans.xml', '', '')
        set @scope_identity = scope_identity()
        SELECT @ContextInfo = cast(@scope_identity AS varbinary(128))
        SET CONTEXT_INFO @ContextInfo
        */

				update transactions set fbid = @fbid 
				where isnull(transactions.fbid, -1) = -1
				and transactions.ledgercode = @fbledgercode
				and transactions.year = @theyear
				and transactions.period = @theperiod
				and transactions.currency = @currency
				and transactions.orgid = @borgid
				set @holderror = @@error
			end

	--Debit the fringe benefits ledger (contract,bs,plant, oh)
			if @holdError = 0
			begin
				insert into ##TRANSACTIONSFB(
				ORGID, YEAR, PERIOD, PDATE, BATCHREF, TRANSREF, TRANSTYPE, ALLOCATION, LEDGERCODE,
				DESCRIPTION, CURRENCY, DEBIT, CREDIT, VATDEBIT, VATCREDIT, USERID,
				QUANTITY, UNIT, RATE, REQNO, ORDERNO, SUBCONTRAN,
				VATTYPE, HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, AGE,		
				CREDNO, STOCKNO,
				PLANTNO, CONTRACT, ACTIVITY, DIVID, FBID
				)
				values(
				@borgid, @year, @period, getDate(), 'FRB' + cast(@userid as nvarchar(10)), 'FRB' + cast(@thePeriod as nvarchar(2)),
				'FRB', @fbAllocationTemp, @fbLedgerCodeTemp, @fbDescr, @currency,
				case when @fbAmount < 0 then 0 else abs(@fbAmount) end, 
				case when @fbAmount < 0 then abs(@fbAmount) else 0 end, 
				0, 0,
				@username,
				0, '', 0, '', '', '',
				'', 0, null, 1, 0,
				'', '',
				@plantno, @contract, @activity, @divid, @fbid
				)
				set @holdError = @@error
			end

--2009-06-18 OAB We do not need the WIP and RI leg the PostTrans SP will do it.
	--Debit the fringe benefits ledger (WIP leg for contracts, RI leg for overheads + plant)
	--		if @fbAllocation <> 'Balance Sheet'
	--		BEGIN
	--		if @holdError = 0
	--		begin
	---			insert into ##TRANSACTIONSFB(
	--			ORGID, YEAR, PERIOD, PDATE, BATCHREF, TRANSREF, TRANSTYPE, ALLOCATION, LEDGERCODE,
	--			DESCRIPTION, CURRENCY, DEBIT, CREDIT, VATDEBIT, VATCREDIT, USERID,
	--			QUANTITY, UNIT, RATE, REQNO, ORDERNO, SUBCONTRAN,
	--			VATTYPE, HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, AGE,
	--			CREDNO, STOCKNO,
	--			PLANTNO, CONTRACT, ACTIVITY, DIVID, FBID
	--			)
	--			values(
	---			@borgid, @year, @period, getDate(), 'FRB' + cast(@userid as nvarchar(10)), 'FRB' + cast(@thePeriod as nvarchar(2)),
	--			'FRB', 'Balance Sheet',
	--			case when @fbAllocation = 'Contract' then @wipLedgerCode else @riLedgerCode end,
	--			@fbDescr + case when @fbAllocation = 'Contract' then ' - WIP' else ' - Retained Income' end,
	--			@currency,
	--			case when @fbAmount < 0 then 0 else abs(@fbAmount) end, 
	--			case when @fbAmount < 0 then abs(@fbAmount) else 0 end, 
	--			0, 0,
	--			@username,
	--			0, '', 0, '', '', '',
	--			'', 0, null, 1, 0,	
	--			'', '',
	--			@plantno, @contract, @activity, @divid, @fbid
	--			)
	--			set @holdError = @@error
	--		end
	--			
	--		END

	--CREDIT the fringe benefit control code
			if @holdError = 0
			begin
				insert into ##TRANSACTIONSFB(
				ORGID, YEAR, PERIOD, PDATE, BATCHREF, TRANSREF, TRANSTYPE, ALLOCATION, LEDGERCODE,
				DESCRIPTION, CURRENCY, DEBIT, CREDIT, VATDEBIT, VATCREDIT, USERID,
				QUANTITY, UNIT, RATE, REQNO, ORDERNO, SUBCONTRAN,
				VATTYPE, HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, AGE,	
				CREDNO, STOCKNO,
				PLANTNO, CONTRACT, ACTIVITY, DIVID, FBID
				)
				values(
				@borgid, @year, @period, getDate(), 'FRB' + cast(@userid as nvarchar(10)), 'FRB' + cast(@thePeriod as nvarchar(2)),
				'FRB', @controlAllocation, @controlLedgerCode, @fbDescr, @currency,
				case when @fbAmount < 0 then abs(@fbAmount) else 0 end, 
				case when @fbAmount < 0 then 0 else abs(@fbAmount) end, 
				0, 0,
				@username,
				0, '', 0, '', '', '',
				'', 0, null, 1, 0,	
				'', '',
				@plantno, @contract, @activity, @divid, @fbid
				)
				set @holdError = @@error
			end
				
		END 

		 FETCH NEXT FROM FB_Cursor into
		 @fbAmount, @fbLedgerCode, @fbid, @fbDescr, @fbAllocation, @thePeriod, @theYear, @currency,
		 @contract, @plantno, @activity, @divid
	END -- Cursor
	close FB_Cursor
	DEALLOCATE FB_Cursor 

-- Now call B-Check and posting
	declare	@DEBIT money,
			@CREDIT money,
			@HOMECURR money,
			@RI money,
			@PO money,
			@WP money,
			@Cont money,
			@THERESULT nvarchar(200)
			
	exec spPostTrans  
		@TIndex = N'FB',
		@_DEBIT = @DEBIT output,
		@_CREDIT = @CREDIT output, 
		@_HOMECURR = @HOMECURR output, 
		@_RI = @RI output, 
		@_PO =  @PO output, 
		@_WP = @WP output, 
		@_Cont = @Cont output, 
		@_THERESULT = @THERESULT output


	if @HoldError = 0 and @THERESULT = 'OK' --1
	begin
		COMMIT TRANSACTION
--		select 'OK'
		select @DEBIT as DEBIT, @CREDIT as CREDIT, @HOMECURR as HOMECURR, @RI as RI, @PO as PO, @WP as WP, @Cont as Cont, @THERESULT as THERESULT
	end
	else --1
	begin
		ROLLBACK TRANSACTION
--		select 'NO'
		select @DEBIT as DEBIT, @CREDIT as CREDIT, @HOMECURR as HOMECURR, @RI as RI, @PO as PO, @WP as WP, @Cont as Cont, @THERESULT as THERESULT
	end --1
	