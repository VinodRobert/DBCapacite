/****** Object:  Procedure [dbo].[spPlantHirePB_PostToLedger]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- NOTES
--2009-05-24 OAB Matthew change the collumn name. So I hand to update the qwery (2009-04-08 Matthew log 1814)
--	Changed the Column transactions.DiscToDate which isn't being used to the column transactions.WhtThisPeriod to store the withholding tax amount
--2010-02-18 OAB Remove WhtThisPeriod from the insert statement to prevent the "spPlantHirePB_PostToLedger.xml Invalid column name 'WhtThisPeriod'" error. 
--2010-04-26 Matthew
--   Changed balance check to only sum RI and WIP legs that are generated internally, so movement from or to RI ledger from other B/S becomes possible
--2010-10-28 Matthew
--   Changed MATCHREF to be blank, this is so matching can happen against the transid
--2013-12-05 RS 
--  Add round inside sum  
-- =============================================
CREATE PROCEDURE [dbo].[spPlantHirePB_PostToLedger]
/* NOTES
OAB 21-04-2007
 Add Overheads 
OAB 2-09-2007
	Fix problem with balance check on overheads postings 
OAB 14-10-2007
	Add the plant number to description 
OAB 29/09/2008
	Fix the Currence in External Contracts to InterCompany Account (Our Side) it was defualting to ZAR
OAB 15/10/2008 
	Add the "AND (PlantHirePBHeader.BorgID = @OrgID)" to the intercompany journals.  
	The Problem was that if there where Plant Batches in company B with intercompany posting and we posted
	batches in company A it generated intercompany journals in company A from the batches in company B
2010-11-29 Matthew
    Added "and DIVISIONS.BORGID = @extOrgID" filter for George in --Overheads External  function
2011-04-19 KSN
    1.) posting of negative values into debit and credit
    2.) Intercompany journals - check sign on amounts for reversing transactions
2011-07-25 Matthew
    Rearrainged posting, added to the balance check, added interCompany checks, enhanced the returned error message, fixed for intercompany legs with homeCurrAmounts
2011-08-31 Matthew
   fix for imbalance issues on home currency when credit and debit values are zero
2011-09-19 KSN
	If intercompany and the currencies are the same, posting not going through - tested at shaft only.
2011-11-22 Matthew 
   Added option on the org parameters (default on), to post intercompany plant hire transactions to journal, else posts directly
2012-09-11 Matthew
   Added context for log Master
2012-09-14 Matthew
   Added context for log Master
2012-11-20 Matthew
   Added checks to preCheckICPosting, for checking the periodSetup table in both orgs is correct, and posting doesn't mix yearends.
2012-12-03 Matthew
   Added check to preCheckICPosting, to insure the TO org in intercompany posting belongs to the FROM org in the BORGSICALLOWED table
2013-05-03 RS
    Fix Rounding
2013-06-14 Matthew
   Added TranGrp to TRANSACTIONS insert
2014-02-21 RS 
  Add Division posting to Plant leg   
 */

	@OrgID as int = 2,
	@Cyear as char(10) = '2006',
	@period as int = 12,
	@Batchno as char(10) = 'PLT230515',
	@transTyp as char(10) = 'IPH Plant',
	@wctl as char(10) = '060103',
	@Ccurr as char(10) = 'ZAR',
	@userID as int = '23',
	@pctl as char(10) = '020102',
	@vatctl as char(10) = '',
    @dec as int,
    @tblName nvarchar(100) = '',
	@holdError as int output,
	@errMsg as nvarchar(250) output,
    @tempSBTran as varchar(8000) output,
    @tempSBTran2 as varchar(8000) output,
    @tempSBTran3 as varchar(8000) output
   
AS

declare @ContextInfo varbinary(128)
declare @scope_identity varchar(128)
declare @sql nvarchar(max)

SET @holdError = 0
SET @errMsg = ''

IF @holdError = 0
BEGIN
	if exists (select * from BSBS_TEMP.dbo.sysobjects where id = object_id(N'BSBS_TEMP.[dbo].[TRANSACTIONS]') )
	drop table BSBS_TEMP.[dbo].[TRANSACTIONS]
	SET @holdError = @@ERROR
END

if not exists (select * from BSBS_TEMP.dbo.sysobjects where id = object_id(N'BSBS_TEMP.[dbo].[TRANSACTIONS]') )
BEGIN
	IF @holdError = 0
	BEGIN
		CREATE TABLE BSBS_TEMP.[dbo].[TRANSACTIONS] (
			[OrgID] [int] NOT NULL, 
			[Year] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('2000'), 
			[Period] [int] NOT NULL DEFAULT (1), 
			[PDate] [datetime] NULL, 
			[BatchRef] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[TransRef] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[MatchRef] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[TransType] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Allocation] [char] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('Balance Sheet'), 
			[LedgerCode] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (9999), 
			[Contract] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Activity] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Description] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[ForeignDescription] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Currency] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('ZAR'), 
			[Debit] [money] NOT NULL DEFAULT (0), 
			[Credit] [money] NOT NULL DEFAULT (0), 
			[VatDebit] [money] NOT NULL DEFAULT (0), 
			[VatCredit] [money] NOT NULL DEFAULT (0), 
			[Credno] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Store] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Plantno] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Stockno] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Quantity] [numeric](23, 4) NOT NULL DEFAULT (0), 
 			[Unit] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Rate] [money] NOT NULL DEFAULT (0), 
			[ReqNo] [char] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[OrderNo] [char] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[Age] [int] NOT NULL DEFAULT (0), 
			[TransID] [int] IDENTITY (1, 1) NOT NULL, 
			[SubConTran] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''), 
			[VATType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('Z'), 
			[HomeCurrAmount] [money] NULL DEFAULT (0), 
			[ConversionDate] [datetime] NULL DEFAULT (0), 
			[ConversionRate] [money] NOT NULL DEFAULT (1), 
			[PaidFor] [bit] NOT NULL DEFAULT (0), 
			[PaidToDate] [money] NOT NULL DEFAULT (0), 
			[PaidThisPeriod] [money] NOT NULL DEFAULT (0), 
			[WhtThisPeriod] [money] NOT NULL DEFAULT (0), 
			[DiscThisPeriod] [money] NOT NULL DEFAULT (0), 
			[ReconStatus] [int] NOT NULL DEFAULT (0), 
			[UserID] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL DEFAULT (''), 
			[DivID] [int] NOT NULL DEFAULT (-1), 
			[ForexVal] [money] NOT NULL DEFAULT (0), 
			[HeadID] [int] NOT NULL DEFAULT (0), 
			[DOCNUMBER] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
			[XGLCODE] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
			[XVATA] [money] NULL, 
			[XVATT] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL, 
			[ISCOSTLEG] [int] NOT NULL DEFAULT (0), 
			[ISWIPLEG] [int] NOT NULL DEFAULT (0), 
			[ISRILEG] [int] NOT NULL DEFAULT (0), 
			[AMOUNT] [money] NOT NULL DEFAULT (0), 
			[WHTID] [int] NOT NULL DEFAULT (0), 
			[TERM] [int] NOT NULL DEFAULT (0), 
			[LINECNTR] [int] NOT NULL DEFAULT (0), 		
			[RECEIVEDDATE] [datetime] NULL, 
			[HOMECURR] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT ('')
		) ON [PRIMARY]
		SET @holdError = @@ERROR
	END

    /*
	IF @holdError = 0
	BEGIN
	ALTER TABLE BSBS_TEMP.[dbo].[TRANSACTIONS] WITH NOCHECK ADD 
		CONSTRAINT [PK_TRANSACTIONS] PRIMARY KEY  CLUSTERED 
		([TransID]) WITH  FILLFACTOR = 90 ON [PRIMARY] 
		SET @holdError = @@ERROR
	END
    
	IF @holdError = 0
	BEGIN
	ALTER TABLE BSBS_TEMP.[dbo].[TRANSACTIONS] WITH NOCHECK ADD 
		CONSTRAINT [DF_TRANSACTIONS_OrgID] DEFAULT (0) FOR [OrgID], 
		CONSTRAINT [DF_TRANSACTIONS_Year] DEFAULT ('2000') FOR [Year], 
		CONSTRAINT [DF_TRANSACTIONS_Period] DEFAULT (1) FOR [Period], 
		CONSTRAINT [DF_TRANSACTIONS_BatchRef] DEFAULT ('') FOR [BatchRef], 
		CONSTRAINT [DF_TRANSACTIONS_TransRef] DEFAULT ('') FOR [TransRef], 
		CONSTRAINT [DF_TRANSACTIONS_MatchRef] DEFAULT ('') FOR [MatchRef], 
		CONSTRAINT [DF_TRANSACTIONS_TransType] DEFAULT ('') FOR [TransType], 
		CONSTRAINT [DF_TRANSACTIONS_Allocation] DEFAULT ('Balance Sheet') FOR [Allocation], 
		CONSTRAINT [DF_TRANSACTIONS_LedgerCode] DEFAULT (9999) FOR [LedgerCode], 
		CONSTRAINT [DF_TRANSACTIONS_Contract] DEFAULT ('') FOR [Contract], 
		CONSTRAINT [DF_TRANSACTIONS_Activity] DEFAULT ('') FOR [Activity], 
		CONSTRAINT [DF_TRANSACTIONS_Description] DEFAULT ('') FOR [Description], 
		CONSTRAINT [DF_TRANSACTIONS_ForeignDescription] DEFAULT ('') FOR [ForeignDescription], 
		CONSTRAINT [DF_TRANSACTIONS_Currency] DEFAULT ('ZAR') FOR [Currency], 
		CONSTRAINT [DF_TRANSACTIONS_Debit] DEFAULT (0.00) FOR [Debit], 
		CONSTRAINT [DF_TRANSACTIONS_Credit] DEFAULT (0.00) FOR [Credit], 
		CONSTRAINT [DF_TRANSACTIONS_VatDebit] DEFAULT (0.00) FOR [VatDebit], 
		CONSTRAINT [DF_TRANSACTIONS_VatCredit] DEFAULT (0.00) FOR [VatCredit], 
		CONSTRAINT [DF_TRANSACTIONS_Credno] DEFAULT ('') FOR [Credno], 
		CONSTRAINT [DF_TRANSACTIONS_Store] DEFAULT ('') FOR [Store], 
		CONSTRAINT [DF_TRANSACTIONS_Plantno] DEFAULT ('') FOR [Plantno], 
		CONSTRAINT [DF_TRANSACTIONS_Stockno] DEFAULT ('') FOR [Stockno], 
		CONSTRAINT [DF_TRANSACTIONS_Quantity] DEFAULT (0) FOR [Quantity], 
		CONSTRAINT [DF_TRANSACTIONS_Unit] DEFAULT ('') FOR [Unit], 
		CONSTRAINT [DF_TRANSACTIONS_Rate] DEFAULT (0) FOR [Rate], 
		CONSTRAINT [DF_TRANSACTIONS_ReqNo] DEFAULT ('') FOR [ReqNo], 
		CONSTRAINT [DF_TRANSACTIONS_OrderNo] DEFAULT ('') FOR [OrderNo], 
		CONSTRAINT [DF_TRANSACTIONS_Age] DEFAULT (0) FOR [Age], 
		CONSTRAINT [DF_TRANSACTIONS_SubConTran] DEFAULT ('') FOR [SubConTran], 
		CONSTRAINT [DF_TRANSACTIONS_VATType] DEFAULT ('Z') FOR [VATType], 
		CONSTRAINT [DF_TRANSACTIONS_HomeCurrAmount] DEFAULT (0) FOR [HomeCurrAmount], 
		CONSTRAINT [DF_TRANSACTIONS_ConversionRate] DEFAULT (1) FOR [ConversionRate], 
		CONSTRAINT [DF_TRANSACTIONS_PaidFor] DEFAULT (0) FOR [PaidFor], 
		CONSTRAINT [DF_TRANSACTIONS_PaidToDate] DEFAULT (0) FOR [PaidToDate], 
		CONSTRAINT [DF_TRANSACTIONS_PaidThisPeriod] DEFAULT (0) FOR [PaidThisPeriod], 
		CONSTRAINT [DF_TRANSACTIONS_DiscToDate] DEFAULT (0) FOR [WhtThisPeriod], 
		CONSTRAINT [DF_TRANSACTIONS_DiscThisPeriod] DEFAULT (0) FOR [DiscThisPeriod], 
		CONSTRAINT [DF_TRANSACTIONS_ReconStatus] DEFAULT (0) FOR [ReconStatus], 
		CONSTRAINT [DF_TRANSACTIONS_UserID] DEFAULT ('Admin') FOR [UserID], 
		CONSTRAINT [DF_TRANSACTIONS_DivID] DEFAULT (3) FOR [DivID], 
		CONSTRAINT [DF_TRANSACTIONS_ForexVal] DEFAULT (0) FOR [ForexVal], 
		CONSTRAINT [DF_TRANSACTIONS_HeadID] DEFAULT (0) FOR [HeadID], 
		CONSTRAINT [DF_TRANSACTIONS_ISCOSTLEG] DEFAULT (0) FOR [ISCOSTLEG], 
		CONSTRAINT [DF_TRANSACTIONS_ISWIPLEG] DEFAULT (0) FOR [ISWIPLEG], 
		CONSTRAINT [DF_TRANSACTIONS_ISRILEG] DEFAULT (0) FOR [ISRILEG], 
		CONSTRAINT [DF_TRANSACTIONS_AMOUNT] DEFAULT (0) FOR [AMOUNT], 
		CONSTRAINT [DF_TRANSACTIONS_WHTID] DEFAULT (-1) FOR [WHTID], 
		CONSTRAINT [DF_TRANSACTIONS_LINECNTR] DEFAULT (-1) FOR [LINECNTR], 
		CONSTRAINT [DF_TRANSACTIONS_TERM] DEFAULT (0) FOR [TERM], 
		CONSTRAINT [DF_TRANSACTIONS_HOMECURR] DEFAULT ('') FOR [HOMECURR]
		SET @holdError = @@ERROR
	END

    */
END

declare @toBorgID int
declare @toOrgCurr nvarchar(3)
declare @toOrgExchrate decimal(18, 4)
declare @toOrgDecimals int
declare @isInterCompany int
declare @cctlFrom nvarchar(10)
declare @cctlTo nvarchar(10)
declare @dctlFrom nvarchar(10)
declare @dctlTo nvarchar(10)
declare @sctlFrom nvarchar(10)
declare @sctlTo nvarchar(10)
declare @valid bit /*true if valid, first part of returned value*/

set @isInterCompany = 0
set @valid = 1 

select @cctlFrom = ControlFromGL, @cctlTo = ControlToGL from CONTROLCODES where ControlName = 'Creditors'
select @dctlFrom = ControlFromGL, @dctlTo = ControlToGL from CONTROLCODES where ControlName = 'Debtors'
select @sctlFrom = ControlFromGL, @sctlTo = ControlToGL from CONTROLCODES where ControlName = 'Sub Contractors'

--List of orgs used in this posting--
--Each org is checked against intercompany rules (period ends, valid IC gls)--
--Each org exchange rate is found and used for HomeCurrAmount conversions--
DECLARE ORGS_Cursor CURSOR FOR
SELECT distinct isnull(PROJECTS.BORGID, isnull(DIVISIONS.BorgID, PlantHirePBHeader.BorgID))
FROM PlantHirePBHeader 
	INNER JOIN PlantHirePBReturnsHead 
	ON PlantHirePBHeader.PBHid = PlantHirePBReturnsHead.PBHid 
	LEFT OUTER JOIN DIVISIONS 
	ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID 
	AND isnull(PlantHirePBReturnsHead.DEBTNUMBER, '') = ''
	LEFT OUTER JOIN CONTRACTS 
	ON CONTRACTS.CONTRNUMBER = PlantHirePBReturnsHead.ContrNumber 
	LEFT OUTER JOIN PROJECTS 
	ON PROJECTS.PROJID = CONTRACTS.PROJID
WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
	AND PlantHirePBHeader.BorgID = @OrgID 
UNION
select @OrgID

OPEN ORGS_Cursor
FETCH NEXT FROM ORGS_Cursor into @toBorgID

WHILE @@FETCH_STATUS = 0
BEGIN
	set @isInterCompany = case when @OrgID = @toBorgID then 0 else 1 end

	if @isInterCompany = 1
	BEGIN
		
		declare @tempInt int /*used for comparing yearendmonth, currenctperiod and currentyear between orgs*/ 

		/*test period for orgB*/ 
		if @valid = 1 
		BEGIN 
			SELECT @valid = case when BORGS.PERIOD <> 0 then @valid else 0 end, 
			@errMsg = case when BORGS.PERIOD <> 0 then @errMsg else 'Invalid Period (Opening Balance) for : ' + BORGS.BORGNAME end 
			FROM BORGS 
			WHERE BORGS.BORGID = @toBorgID 
		END 
    
		/*test loan account on orgA*/ 
		if @valid = 1 
		BEGIN 
    		SELECT @valid = case when isnull(BORGS.ICGLCODE, '-1') = isnull(L.LEDGERCODE, '') then @valid else 0 end, 
    		@errMsg = case when isnull(BORGS.ICGLCODE, '-1') = isnull(L.LEDGERCODE, '') then @errMsg else 'Invalid Inter Company Loan Account for : ' + BORGS.BORGNAME end 
    		FROM BORGS 
    		LEFT OUTER JOIN LEDGERCODES L 
    		ON L.LEDGERCODE = BORGS.ICGLCODE 
    		AND L.LEDGERSUMMARY = 0 
    		WHERE BORGS.BORGID = @OrgID 
		END 
    
		/*test loan account on orgB*/ 
		if @valid = 1 
		BEGIN 
    		SELECT @valid = case when isnull(BORGS.ICGLCODE, '-1') = isnull(L.LEDGERCODE, '') then @valid else 0 end, 
    		@errMsg = case when isnull(BORGS.ICGLCODE, '-1') = isnull(L.LEDGERCODE, '') then @errMsg else 'Invalid Inter Company Loan Account for : ' + BORGS.BORGNAME end 
    		FROM BORGS 
    		LEFT OUTER JOIN LEDGERCODES L 
    		ON L.LEDGERCODE = BORGS.ICGLCODE 
    		AND L.LEDGERSUMMARY = 0 
    		WHERE BORGS.BORGID = @toBorgID 
		END 

		/*test both orgs have the same year end month*/ 
		select @tempInt = BORGS.YEARENDMONTH FROM BORGS WHERE BORGS.BORGID = @OrgID 
		if @valid = 1 
		BEGIN 
    		SELECT @valid = case when @tempInt = BORGS.YEARENDMONTH then @valid else 0 end, 
    		@errMsg = case when @tempInt = BORGS.YEARENDMONTH then @errMsg else 'Invalid Year End Month ('+ cast(BORGS.YEARENDMONTH as nvarchar(2)) +'), needs to be ('+ cast(@tempInt as nvarchar(2)) +') for : ' + BORGS.BORGNAME end 
    		FROM BORGS 
    		WHERE BORGS.BORGID = @toBorgID 
		END 

        /*test org A financial year is at least the year posted to*/
        select @tempInt = @Cyear
        if @valid = 1
        BEGIN
        	SELECT @valid = case when @tempInt >= BORGS.CURRENTYEAR then @valid else 0 end,
        	@errMsg = case when @tempInt >= BORGS.CURRENTYEAR then @errMsg else 'Invalid posting year ('+ cast(@tempInt as nvarchar(4)) +'), Current Financial Year ('+ cast(BORGS.CURRENTYEAR as nvarchar(4)) +'), needs to be same or future year for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	WHERE BORGS.BORGID = @OrgID
        END 

        /*test org B financial year is at least the year posted to*/
        select @tempInt = @Cyear
        if @valid = 1
        BEGIN
        	SELECT @valid = case when @tempInt >= BORGS.CURRENTYEAR then @valid else 0 end,
        	@errMsg = case when @tempInt >= BORGS.CURRENTYEAR then @errMsg else 'Invalid posting year ('+ cast(@tempInt as nvarchar(4)) +'), Current Financial Year ('+ cast(BORGS.CURRENTYEAR as nvarchar(4)) +'), needs to be same or future year for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	WHERE BORGS.BORGID = @toBorgID
        END    

		/*test both orgs are at least in the same or previous period to the period posted to. i.e. can post to current or future period*/
        select @tempInt = BORGS.PERIOD
        FROM BORGS WHERE BORGS.BORGID = @OrgID
        if @valid = 1
        BEGIN
        	SELECT @valid = case when @tempInt <= @period or BORGS.CURRENTYEAR < @Cyear then @valid else 0 end,
        	@errMsg = case when @tempInt <= @period or BORGS.CURRENTYEAR < @Cyear then @errMsg else 'Invalid previous period posting into ('+ cast(@period as nvarchar(2)) +'), current period ('+ cast(@tempInt as nvarchar(2)) +') for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	WHERE BORGS.BORGID = @OrgID
        END
        
        /*test both orgs are at least in the same or previous period to the period posted to. i.e. can post to current or future period*/
        select @tempInt = BORGS.PERIOD
        FROM BORGS WHERE BORGS.BORGID = @toBorgID
        if @valid = 1
        BEGIN
        	SELECT @valid = case when @tempInt <= @period or BORGS.CURRENTYEAR < @Cyear then @valid else 0 end,
        	@errMsg = case when @tempInt <= @period or BORGS.CURRENTYEAR < @Cyear then @errMsg else 'Invalid previous period posting into ('+ cast(@period as nvarchar(2)) +'), current period ('+ cast(@tempInt as nvarchar(2)) +') for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	WHERE BORGS.BORGID = @toBorgID
        END

        /*2012-01-20 Matthew - Changed to allow to post to future periods
        /*test both orgs are in the same period*/ 
		select @tempInt = BORGS.PERIOD FROM BORGS WHERE BORGS.BORGID = @OrgID 
		if @valid = 1 
		BEGIN 
    		SELECT @valid = case when @tempInt = BORGS.PERIOD then @valid else 0 end, 
    		@errMsg = case when @tempInt = BORGS.PERIOD then @errMsg else 'Invalid Current Period ('+ cast(BORGS.PERIOD as nvarchar(2)) +'), needs to be ('+ cast(@tempInt as nvarchar(2)) +') for : ' + BORGS.BORGNAME end 
    		FROM BORGS 
    		WHERE BORGS.BORGID = @toBorgID 
		END 
        */
 

		/*test exchange rate for orgB*/ 
		if @valid = 1 
		BEGIN 
    		if (@Ccurr = (select BORGS.CURRENCY from BORGS where BORGS.BORGID = @toBorgID)) 
    		BEGIN 
                --2011-09-19 KSN
    			set @toOrgCurr = @Ccurr
				set @toOrgExchrate = 1
				set @toOrgDecimals = 4
                
    			SELECT @valid = case when isnull(BORGS.CURRENCY, '-1') = isnull(CURRENCIES.CURRCODE, '') then @valid else 0 end, 
    			@errMsg = case when isnull(BORGS.CURRENCY, '-1') = isnull(CURRENCIES.CURRCODE, '') then @errMsg else 'Invalid Currency for : ' + BORGS.BORGNAME end
    			from BORGS 
    			LEFT OUTER JOIN CURRENCIES 
    			ON BORGS.CURRENCY = CURRENCIES.CURRCODE 
    			WHERE BORGS.BORGID = @toBorgID 
    		END 
    		ELSE 
    		BEGIN 
    			select 
    			RTrim(CURRENCIES.CURRCODE) CURRCODE, 
    			isnull(CURREXCH.RATE, -1) as RATE, 
    			isnull(CURRENCIES.DECIMALS, 2) DECIMALS 
    			into #temp 
    			from CURRENCIES 
    			INNER JOIN ( 
    			 select CURREXCH.FROMCURR, CURREXCH.RATE 
    			 FROM BORGS 
    			 INNER JOIN CURREXCH 
    			 ON CURREXCH.GROUPID = BORGS.CURREXGRP 
    			 AND BORGS.CURRENCY = CURREXCH.TOCURR 
    			 INNER JOIN CURREXCHGRP 
    			 ON CURREXCH.GROUPID = CURREXCHGRP.GROUPID 
    			 INNER JOIN ( 
    			  SELECT GROUPID, FROMCURR, TOCURR, MAX(STARTDATE) AS STARTDATE 
    			  FROM CURREXCH 
    			  GROUP BY GROUPID, FROMCURR, TOCURR) ce 
    			 ON CURREXCH.GROUPID = ce.groupid 
    			 AND CURREXCH.FROMCURR = ce.fromcurr 
    			 AND CURREXCH.TOCURR = ce.tocurr 
    			 AND CURREXCH.STARTDATE = ce.startdate 
    			 WHERE BORGS.BORGID = @toBorgID 
    			 and CURREXCHGRP.DISABLED = 0 
    			) CURREXCH 
    			ON CURREXCH.FROMCURR = CURRENCIES.CURRCODE 
    			WHERE CURRENCIES.CURRCODE = @Ccurr 
	    
    			SELECT @valid = case when isnull(#temp.CURRCODE, '') = @Ccurr then @valid else 0 end, 
    			@errMsg = case when isnull(#temp.CURRCODE, '') = @Ccurr then @errMsg else 'Invalid Currency Exchange setup for : ' + BORGS.BORGNAME end,
				@toOrgCurr = BORGS.CURRENCY,
				@toOrgExchrate = #temp.RATE,
				@toOrgDecimals = #temp.DECIMALS		
    			from BORGS 
    			LEFT OUTER JOIN #temp 
    			ON #temp.CURRCODE = @Ccurr 
    			WHERE BORGS.BORGID = @toBorgID 
     	    
    			drop table #temp 
    		END 
		END 

        /*test ICCREDNO for toBorgID*/
        if @valid = 1
        BEGIN
            SELECT @valid =
            case when BORGS.ICGLCODE between @cctlFrom and @cctlTo and ISNULL(CREDITORS.CREDNUMBER, '') = '' then 0
            when BORGS.ICGLCODE between @dctlFrom and @dctlTo and ISNULL(DEBTORS.DEBTNUMBER, '') = '' then 0
            when BORGS.ICGLCODE between @sctlFrom and @sctlTo and ISNULL(SUBCONTRACTORS.SUBNUMBER, '') = '' then 0
            ELSE @valid
            END,
            @errMsg =
            case when BORGS.ICGLCODE between @cctlFrom and @cctlTo and ISNULL(CREDITORS.CREDNUMBER, '') = '' then 'Intercompany Creditor Number missing or invalid'
            when BORGS.ICGLCODE between @dctlFrom and @dctlTo and ISNULL(DEBTORS.DEBTNUMBER, '') = '' then 'Intercompany Debtor Number missing, invalid or has incorrect control code'
            when BORGS.ICGLCODE between @sctlFrom and @sctlTo and ISNULL(SUBCONTRACTORS.SUBNUMBER, '') = '' then 'Intercompany SubContractor Number missing or invalid'
            ELSE @errMsg
            END
            FROM BORGS
            LEFT OUTER JOIN CREDITORS ON CREDITORS.CREDNUMBER = BORGS.ICCREDNO
            LEFT OUTER JOIN DEBTORS ON DEBTORS.DEBTNUMBER = BORGS.ICCREDNO and BORGS.ICGLCODE = DEBTORS.DEBTCONTROL
            LEFT OUTER JOIN SUBCONTRACTORS ON SUBCONTRACTORS.SUBNUMBER = BORGS.ICCREDNO
            WHERE BORGS.BORGID = @toBorgID
        END
                
        /*test ICCREDNO for OrgID*/
        if @valid = 1
        BEGIN
            SELECT @valid =
            case when BORGS.ICGLCODE between @cctlFrom and @cctlTo and ISNULL(CREDITORS.CREDNUMBER, '') = '' then 0
            when BORGS.ICGLCODE between @dctlFrom and @dctlTo and ISNULL(DEBTORS.DEBTNUMBER, '') = '' then 0
            when BORGS.ICGLCODE between @sctlFrom and @sctlTo and ISNULL(SUBCONTRACTORS.SUBNUMBER, '') = '' then 0
            ELSE @valid
            END,
            @errMsg =
            case when BORGS.ICGLCODE between @cctlFrom and @cctlTo and ISNULL(CREDITORS.CREDNUMBER, '') = '' then 'Intercompany Creditor Number missing or invalid'
            when BORGS.ICGLCODE between @dctlFrom and @dctlTo and ISNULL(DEBTORS.DEBTNUMBER, '') = '' then 'Intercompany Debtor Number missing, invalid or has incorrect control code'
            when BORGS.ICGLCODE between @sctlFrom and @sctlTo and ISNULL(SUBCONTRACTORS.SUBNUMBER, '') = '' then 'Intercompany SubContractor Number missing or invalid'
            ELSE @errMsg
            END
            FROM BORGS
            LEFT OUTER JOIN CREDITORS ON CREDITORS.CREDNUMBER = BORGS.ICCREDNO
            LEFT OUTER JOIN DEBTORS ON DEBTORS.DEBTNUMBER = BORGS.ICCREDNO and BORGS.ICGLCODE = DEBTORS.DEBTCONTROL
            LEFT OUTER JOIN SUBCONTRACTORS ON SUBCONTRACTORS.SUBNUMBER = BORGS.ICCREDNO
            WHERE BORGS.BORGID = @OrgID
        END

        /*test postPeriod and postYear is valid for both orgs*/
        if @valid = 1
        BEGIN
        	SELECT @valid = case when isnull(PERIODSETUP.ORGID, -1) = BORGS.BORGID then @valid else 0 end,
        	@errMsg = case when isnull(PERIODSETUP.ORGID, -1) = BORGS.BORGID then @errMsg else 'Invalid period ('+ cast(@period as nvarchar(2)) +')/ year ('+ cast(@Cyear as nvarchar(4)) +') - Period not setup, for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	LEFT OUTER JOIN PERIODSETUP ON PERIODSETUP.ORGID = BORGS.BORGID and PERIODSETUP.YEAR = @Cyear and PERIODSETUP.PERIOD = @period
        	WHERE BORGS.BORGID = @OrgID
        END
 
        if @valid = 1
        BEGIN
        	SELECT @valid = case when isnull(PERIODSETUP.ORGID, -1) = BORGS.BORGID then @valid else 0 end,
        	@errMsg = case when isnull(PERIODSETUP.ORGID, -1) = BORGS.BORGID then @errMsg else 'Invalid period ('+ cast(@period as nvarchar(2)) +')/ year ('+ cast(@Cyear as nvarchar(4)) +') - Period not setup, for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	LEFT OUTER JOIN PERIODSETUP ON PERIODSETUP.ORGID = BORGS.BORGID and PERIODSETUP.YEAR = @Cyear and PERIODSETUP.PERIOD = @period
        	WHERE BORGS.BORGID = @toBorgID
        END
 
        /*test postPeriod is either a yearEnd in both/neither orgs (i.e. not mixed) */
        select @tempInt = PERIODSETUP.ISYEAREND
        FROM PERIODSETUP WHERE PERIODSETUP.ORGID = @OrgID and PERIODSETUP.YEAR = @Cyear and PERIODSETUP.PERIOD = @period
        if @valid = 1
        BEGIN
        	SELECT @valid = case when @tempInt = PERIODSETUP.ISYEAREND then @valid else 0 end,
        	@errMsg = case when @tempInt = PERIODSETUP.ISYEAREND then @errMsg else 'Invalid '+ case when @tempInt = 1 then 'year end ' else '' end +'post ('+ cast(@period as nvarchar(2)) +')/ year ('+ cast(@Cyear as nvarchar(4)) +') - into a '+ case when @tempInt = 1 then 'normal ' else 'year end ' end +' period, for : ' + BORGS.BORGNAME end
        	FROM BORGS
        	LEFT OUTER JOIN PERIODSETUP ON PERIODSETUP.ORGID = BORGS.BORGID and PERIODSETUP.YEAR = @Cyear and PERIODSETUP.PERIOD = @period
        	WHERE BORGS.BORGID = @toBorgID
        END
        
        /*ignore test if months of both periods differ*/

        /*Check the Allowed Intercompany Borgs include the from and to org for this transaction*/ 
        if @valid = 1 
        BEGIN 
           IF NOT EXISTS (SELECT BORGID FROM BORGSICALLOWED WHERE BORGSICALLOWED.BORGID = @OrgID AND BORGSICALLOWED.BORGIDINC = @toBorgID) 
           BEGIN 
               set @valid = 0 
               set @errMsg = 'Organisation ID ['+ cast(@OrgID as nvarchar(10)) +'], is not setup to post into Organisation ID ['+ cast(@toBorgID as nvarchar(10)) +']' 
           END 
        END 
		
		if @valid <> 1 or @errMsg <> ''
		BEGIN
			set @holdError = -1
		END 
	END
	ELSE
	BEGIN
		set @toOrgCurr = @Ccurr
		set @toOrgExchrate = 1
		set @toOrgDecimals = 4
	END
	
	--Overheads Internal and External 
	 IF @holdError = 0 
	 BEGIN 
		INSERT INTO BSBS_TEMP.dbo.TRANSACTIONS
			(
			OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode, Description, CURRENCY, HOMECURR, VATType, Debit, VatDebit, 
			VatCredit, Credit, HeadID, DivID, 
			HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, Plantno, LINECNTR
			)
		SELECT DIVISIONS.BorgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() AS PDATE, @Batchno AS BATCHREF, PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
			'' AS MATCHREF, @transTyp AS TRANSTYPE, 'Overheads' AS ALLOCATION, PlantHirePBHeader.PBRHOverLG AS ledgercode, 
			'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, @Ccurr AS currency, @toOrgCurr AS HOMECURR, 'Z' AS VATTYPE,
			round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) else 0 end), @dec) AS DEBIT, 
			0 AS Vatdeb, 0 AS Vatcred, 
			round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
			PlantHirePBReturnsHead.PBHid AS HeadID, 
			PlantHirePBReturnsHead.DivToID, 
			CAST(case when @Ccurr = @toOrgCurr then 0 else round(abs(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @toOrgDecimals)) * @toOrgExchrate), @toOrgDecimals) end as money) as [HOMECURRAMOUNT],
			case when @Ccurr = @toOrgCurr then null else GETDATE() end as [CONVERSIONDATE],
			CAST(case when @Ccurr = @toOrgCurr then 1 else @toOrgExchrate end as money) as [HOMECURRAMOUNT], PlantHirePBHeader.PeNumber,
			1
		FROM PlantHirePBHeader 
			INNER JOIN PlantHirePBReturnsHead 
			ON PlantHirePBHeader.PBHid = PlantHirePBReturnsHead.PBHid 
			INNER JOIN PlantHirePBReturnsValues 
			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
			INNER JOIN DIVISIONS 
			ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID
            INNER JOIN BORGS 
            ON BORGS.BORGID = DIVISIONS.BorgID
		WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
			AND DIVISIONS.BorgID = @toBorgID 
			AND PlantHirePBHeader.BorgID = @OrgID 
			AND PlantHirePBReturnsHead.DivToID IS NOT NULL
            AND (BORGS.BORGID = @OrgID OR BORGS.ICPLANTJNL = 0)
		GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, PlantHirePBReturnsHead.DivToID, PlantHirePBHeader.PBRHOverLG, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, DIVISIONS.BorgID
		SET @holdError = @@ERROR 
	 END 

	--Overheads RI Internal and External
	 IF @holdError = 0 
	 BEGIN 
		INSERT INTO BSBS_TEMP.dbo.TRANSACTIONS
			(
			OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode, Description, CURRENCY, HOMECURR, VATType, Debit, VatDebit, 
			VatCredit, Credit, HeadID, DivID, ISRILEG, 
			HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, Plantno, LINECNTR
			)
		SELECT DIVISIONS.BorgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() AS PDATE, @Batchno AS BATCHREF, PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
			'' AS MATCHREF, @transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, @pctl AS ledgercode, 
			'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, @Ccurr AS currency, @toOrgCurr AS HOMECURR, 'Z' AS VATTYPE,
			round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) else 0 end), @dec) AS DEBIT, 
			0 AS Vatdeb, 0 AS Vatcred, 
			round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
			PlantHirePBReturnsHead.PBHid AS HeadID, 
			PlantHirePBReturnsHead.DivToID, 
			1, --ISRILEG
			CAST(case when @Ccurr = @toOrgCurr then 0 else round(abs(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @toOrgDecimals)) * @toOrgExchrate), @toOrgDecimals) end as money) as [HOMECURRAMOUNT],
			case when @Ccurr = @toOrgCurr then null else GETDATE() end as [CONVERSIONDATE],
			CAST(case when @Ccurr = @toOrgCurr then 1 else @toOrgExchrate end as money) as [HOMECURRAMOUNT], PlantHirePBHeader.PeNumber,
			2		
		FROM PlantHirePBHeader 
			INNER JOIN PlantHirePBReturnsHead 
			ON PlantHirePBHeader.PBHid = PlantHirePBReturnsHead.PBHid 
			INNER JOIN PlantHirePBReturnsValues 
			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
			INNER JOIN DIVISIONS 
			ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID 
            INNER JOIN BORGS 
            ON BORGS.BORGID = DIVISIONS.BorgID
		WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
			AND DIVISIONS.BorgID = @toBorgID 
			AND PlantHirePBHeader.BorgID = @OrgID 
			AND PlantHirePBReturnsHead.DivToID IS NOT NULL
            AND (BORGS.BORGID = @OrgID OR BORGS.ICPLANTJNL = 0)
		GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, PlantHirePBReturnsHead.DivToID, PlantHirePBHeader.PlantDCostGl, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, DIVISIONS.BorgID
		SET @holdError = @@ERROR 
	 END 

	if @isInterCompany = 1 
	BEGIN
		--Overhead External to InterCompany Account (Our Side)
		 IF @holdError = 0 
		 BEGIN 
			INSERT INTO BSBS_TEMP.dbo.TRANSACTIONS
				(
				OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode, Description, CREDNO, CURRENCY, HOMECURR, VATType, Debit, VatDebit, 
				VatCredit, Credit, HeadID, DivID, 
				HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
				)
			SELECT @OrgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() AS PDATE, @Batchno AS BATCHREF, PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
				'' AS MATCHREF, @transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, BORGS.ICGLCODE AS ledgercode, 
				'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
                BORGS.ICCREDNO as credno, 
                @Ccurr AS currency, @Ccurr AS HOMECURR, 'Z' AS VATTYPE,
				round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) else 0 end), @dec) AS DEBIT, 
				0 AS Vatdeb, 0 AS Vatcred, 
				round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
				PlantHirePBReturnsHead.PBHid AS HeadID, 
				PlantHirePBReturnsHead.DivToID, 
				CAST(0 as money) as [HOMECURRAMOUNT], 
				NULL as [CONVERSIONDATE], 
				CAST(1 as money) as [CONVERSIONRATE],  
				3
			FROM PlantHirePBHeader 
				INNER JOIN PlantHirePBReturnsHead 
				ON PlantHirePBHeader.PBHid = PlantHirePBReturnsHead.PBHid 
				INNER JOIN PlantHirePBReturnsValues 
				ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
				INNER JOIN DIVISIONS 
				ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID 
				INNER JOIN BORGS 
				ON DIVISIONS.BorgID = BORGS.BORGID 
			WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2
				AND DIVISIONS.BorgID = @toBorgID 
				AND PlantHirePBHeader.BorgID = @OrgID 
				AND PlantHirePBReturnsHead.DivToID IS NOT NULL
			GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, PlantHirePBReturnsHead.DivToID, PlantHirePBHeader.PlantDCostGl, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, 
                BORGS.ICGLCODE, BORGS.ICCREDNO
		
			SET @holdError = @@ERROR 
		END 
		
		IF @holdError = 0 
		BEGIN 
		--Overhead External to InterCompany Account (Other Org Side)	
			INSERT INTO BSBS_TEMP.dbo.TRANSACTIONS
				(
				OrgID, Year, Period, PDate, BatchRef, TransRef, MatchRef, TransType, Allocation, LedgerCode, Description, CREDNO, CURRENCY, HOMECURR, VATType, Debit, VatDebit, 
				VatCredit, Credit, HeadID, DivID, 
				HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
				)
			SELECT @toBorgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() AS PDATE, @Batchno AS BATCHREF, PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
				'' AS MATCHREF, @transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, BORGS.ICGLCODE AS ledgercode, 
				'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
                BORGS.ICCREDNO as credno, 
                @Ccurr AS currency, @toOrgCurr AS HOMECURR, 'Z' AS VATTYPE,
				round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then 0 else ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) end), @dec) AS DEBIT, 
				0 AS Vatdeb, 0 AS Vatcred, 
				round((case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then 0 else ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) end), @dec) AS CREDIT, 
				PlantHirePBReturnsHead.PBHid AS HeadID, 
				PlantHirePBReturnsHead.DivToID,
				CAST(case when @Ccurr = @toOrgCurr then 0 else round(abs(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @toOrgDecimals)) * @toOrgExchrate), @toOrgDecimals) end as money) as [HOMECURRAMOUNT],
				case when @Ccurr = @toOrgCurr then null else GETDATE() end as [CONVERSIONDATE],
				CAST(case when @Ccurr = @toOrgCurr then 1 else @toOrgExchrate end as money) as [HOMECURRAMOUNT],
				4
			FROM PlantHirePBHeader 
				INNER JOIN PlantHirePBReturnsHead 
				ON PlantHirePBHeader.PBHid = PlantHirePBReturnsHead.PBHid 
				INNER JOIN PlantHirePBReturnsValues 
				ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
				INNER JOIN DIVISIONS 
				ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID 
				INNER JOIN BORGS 
				ON PlantHirePBHeader.BorgID = BORGS.BORGID 
                INNER JOIN BORGS ICBORG
                ON ICBORG.BORGID = DIVISIONS.BorgID
			WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
				AND DIVISIONS.BorgID = @toBorgID 
				AND PlantHirePBHeader.BorgID = @OrgID 
				AND PlantHirePBReturnsHead.DivToID IS NOT NULL
                AND (ICBORG.BORGID = @OrgID OR ICBORG.ICPLANTJNL = 0)
			GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, PlantHirePBReturnsHead.DivToID, PlantHirePBHeader.PlantDCostGl, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, 
                BORGS.ICGLCODE, BORGS.ICCREDNO
		 
			SET @holdError = @@ERROR 
		END 
	END --isInterCompany

	--Contracts Internal and External to Contracts
	if @holdError = 0
	BEGIN
		INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
			(
			ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], 
			CONTRACT, ACTIVITY, CURRENCY, HOMECURR, VATTYPE, DEBIT, VATDEBIT, VATCREDIT, CREDIT, HeadID, 
			HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, Plantno, LINECNTR
			)
		SELECT Projects.BorgID AS ORGID, 
			@Cyear AS TheYEAR, 
			@period AS PERIOD, 
			GETDATE() AS PDATE, 
			@Batchno AS BATCHREF, 
			PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
			'' AS MATCHREF, 
			@transTyp AS TRANSTYPE, 
			'Contracts' AS ALLOCATION, 
			PlantHirePBHeader.PlantDCostGl AS ledgercode, 
			'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
			PlantHirePBReturnsHead.ContrNumber AS Contract, 
			PlantHirePBReturnsHead.ActNumber AS Activity, 
			@Ccurr AS currency, 
			@toOrgCurr AS HOMECURR, 
			'Z' AS VATTYPE,
			round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) else 0 end), @dec) AS DEBIT, 
			0 AS Vatdeb, 0 AS Vatcred, 
			round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
			PlantHirePBReturnsHead.PBHid as HeadID, 
			CAST(case when @Ccurr = @toOrgCurr then 0 else round(abs(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @toOrgDecimals)) * @toOrgExchrate), @toOrgDecimals) end as money) as [HOMECURRAMOUNT],
			case when @Ccurr = @toOrgCurr then null else GETDATE() end as [CONVERSIONDATE],
			CAST(case when @Ccurr = @toOrgCurr then 1 else @toOrgExchrate end as money) as [HOMECURRAMOUNT], PlantHirePBHeader.PeNumber,
			5
		FROM PROJECTS 
			INNER JOIN CONTRACTS 
			ON PROJECTS.PROJID = CONTRACTS.PROJID 
			INNER JOIN PlantHirePBReturnsHead 
			ON CONTRACTS.CONTRNUMBER = PlantHirePBReturnsHead.ContrNumber 
			INNER JOIN PlantHirePBHeader 
			ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
			INNER JOIN PlantHirePBReturnsValues 
			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid
            INNER JOIN BORGS 
            ON BORGS.BORGID = Projects.BorgID
		WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2
			AND Projects.BorgID = @toBorgID
			AND PlantHirePBReturnsHead.ContrNumber IS NOT NULL
			AND PlantHirePBHeader.BorgID = @OrgID
            AND (BORGS.BORGID = @OrgID OR BORGS.ICPLANTJNL = 0)
		GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, 
			PlantHirePBReturnsHead.ContrNumber, PlantHirePBReturnsHead.ActNumber, 
			PlantHirePBHeader.PlantDCostGl, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, Projects.BorgID
		SET @holdError  = @@ERROR
	END
	   
	--Contracts Internal and External to WIP
	IF @holdError = 0
	BEGIN
		INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
			(
			ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], 
			CONTRACT, ACTIVITY, CURRENCY, HOMECURR, VATTYPE, DEBIT, VATDEBIT, VATCREDIT, CREDIT, HeadID, ISWIPLEG, 
			HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
			)
		SELECT Projects.BorgID AS ORGID, 
			@Cyear AS TheYEAR, 
			@period AS PERIOD, 
			GETDATE() AS PDATE, 
			@Batchno AS BATCHREF, 
			PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
			'' AS MATCHREF, 
			@transTyp AS TRANSTYPE, 
			'Balance Sheet' AS ALLOCATION, 
			@wctl AS ledgercode, 
			'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
			PlantHirePBReturnsHead.ContrNumber AS Contract, 
			PlantHirePBReturnsHead.ActNumber AS Activity, 
			@Ccurr AS currency, 
			@toOrgCurr AS HOMECURR, 
			'Z' AS VATTYPE,
			round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) else 0 end), @dec) AS DEBIT, 
			0 AS Vatdeb, 0 AS Vatcred, 
			round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
			PlantHirePBReturnsHead.PBHid as HeadID, 
			1, --ISWIPLEG 
			CAST(case when @Ccurr = @toOrgCurr then 0 else round(abs(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @toOrgDecimals)) * @toOrgExchrate), @toOrgDecimals) end as money) as [HOMECURRAMOUNT],
			case when @Ccurr = @toOrgCurr then null else GETDATE() end as [CONVERSIONDATE],
			CAST(case when @Ccurr = @toOrgCurr then 1 else @toOrgExchrate end as money) as [HOMECURRAMOUNT],
			6
		FROM PROJECTS 
			INNER JOIN CONTRACTS 
			ON PROJECTS.PROJID = CONTRACTS.PROJID 
			INNER JOIN PlantHirePBReturnsHead 
			ON CONTRACTS.CONTRNUMBER = PlantHirePBReturnsHead.ContrNumber 
			INNER JOIN PlantHirePBHeader 
			ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
			INNER JOIN PlantHirePBReturnsValues 
			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid
            INNER JOIN BORGS 
            ON BORGS.BORGID = Projects.BorgID
		WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2
			AND Projects.BorgID = @toBorgID
			AND PlantHirePBReturnsHead.ContrNumber IS NOT NULL
			AND PlantHirePBHeader.PlantDCostGl IS NOT NULL 
			AND PlantHirePBHeader.BorgID = @OrgID 
            AND (BORGS.BORGID = @OrgID OR BORGS.ICPLANTJNL = 0)
		GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, 
			PlantHirePBReturnsHead.ContrNumber, PlantHirePBReturnsHead.ActNumber, 
			PlantHirePBHeader.PlantDCostGl, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, Projects.BorgID
		SET @holdError = @@ERROR
	END


	if @isInterCompany = 1 
	BEGIN
		-- External Contracts to InterCompany Account (Our Side)
		IF @holdError = 0
		BEGIN
			INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
				(
				ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], CREDNO, 
				CONTRACT, ACTIVITY, CURRENCY, HOMECURR, VATTYPE, DEBIT, VATDEBIT, VATCREDIT, CREDIT, HeadID, Plantno, 
				HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
				)
			SELECT @OrgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() 
				AS PDATE, @Batchno AS BATCHREF, 
				PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
				'' AS MATCHREF, 
				@transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, 
				BORGS.ICGLCODE AS ledgercode, 'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
                BORGS.ICCREDNO as credno, 
				'' AS Contract, '' AS Activity, @Ccurr AS currency, @Ccurr AS HOMECURR, 'Z' AS VATTYPE,
				round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) else 0 end), @dec) AS DEBIT, 
				0 AS Vatdeb, 
				0 AS Vatcred, 
				round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
				PlantHirePBReturnsHead.PBHid AS HeadID, 
				PlantHirePBHeader.PeNumber, 
				CAST(0 as money) as [HOMECURRAMOUNT], 
				NULL as [CONVERSIONDATE], 
				CAST(1 as money) as [CONVERSIONRATE], 
				7	
			FROM PlantHirePBReturnsHead 
				INNER JOIN PlantHirePBHeader 
				ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
				INNER JOIN CONTRACTS 
				ON PlantHirePBReturnsHead.ContrNumber = CONTRACTS.CONTRNUMBER 
				INNER JOIN PROJECTS 
				ON CONTRACTS.PROJID = PROJECTS.PROJID 
				INNER JOIN PlantHirePBReturnsValues 
				ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
				INNER JOIN BORGS 
				ON PROJECTS.BORGID = BORGS.BORGID
			WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
				AND Projects.BorgID = @toBorgID
				AND PlantHirePBReturnsHead.ContrNumber IS NOT NULL
				AND PlantHirePBHeader.PlantDCostGl IS NOT NULL 
				AND PlantHirePBHeader.BorgID = @OrgID 
			GROUP BY PlantHirePBHeader.PlantDCostGl, 
				PlantHirePBReturnsHead.PBRHInvoiceNum, 
				PlantHirePBReturnsHead.ContrNumber, PlantHirePBReturnsHead.ActNumber, 
				BORGS.ICGLCODE, PlantHirePBReturnsHead.PBHid, 
				PlantHirePBHeader.PeNumber, BORGS.ICCREDNO
			SET @holdError = @@ERROR
		END
		
		-- External Contracts to InterCompany Account (Other Side)
		IF @holdError = 0
		BEGIN
			INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
				(
				ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], CREDNO, 
				CONTRACT, ACTIVITY, CURRENCY, HOMECURR, VATTYPE, DEBIT, VATDEBIT, VATCREDIT, CREDIT, HeadID, Plantno, 
				HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
				)
			SELECT @toBorgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() 
				AS PDATE, @Batchno AS BATCHREF, 
				PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
				'' AS MATCHREF, 
				@transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, 
				BORGS.ICGLCODE AS ledgercode, 'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
                BORGS.ICCREDNO as credno, 
				'' AS Contract, '' AS Activity, @Ccurr AS currency, @toOrgCurr AS HOMECURR, 'Z' AS VATTYPE,
				round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then 0 else ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) end), @dec) AS DEBIT, 
				0 AS Vatdeb, 
				0 AS Vatcred, 
				round((Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then 0 else ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) end), @dec) AS CREDIT, 
				PlantHirePBReturnsHead.PBHid AS HeadID, 
				PlantHirePBHeader.PeNumber,  
				CAST(case when @Ccurr = @toOrgCurr then 0 else round(abs(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @toOrgDecimals)) * @toOrgExchrate), @toOrgDecimals) end as money) as [HOMECURRAMOUNT],
				case when @Ccurr = @toOrgCurr then null else GETDATE() end as [CONVERSIONDATE],
				CAST(case when @Ccurr = @toOrgCurr then 1 else @toOrgExchrate end as money) as [HOMECURRAMOUNT],
				8		
			FROM PlantHirePBReturnsHead 
				INNER JOIN PlantHirePBHeader 
				ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
				INNER JOIN CONTRACTS 
				ON PlantHirePBReturnsHead.ContrNumber = CONTRACTS.CONTRNUMBER 
				INNER JOIN PROJECTS 
				ON CONTRACTS.PROJID = PROJECTS.PROJID 
				INNER JOIN PlantHirePBReturnsValues 
				ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
				INNER JOIN BORGS 
				ON PlantHirePBHeader.BorgID = BORGS.BORGID 
                INNER JOIN BORGS ICBORG
                ON ICBORG.BORGID = PROJECTS.BorgID
			WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
				AND Projects.BorgID = @toBorgID
				AND PlantHirePBReturnsHead.ContrNumber IS NOT NULL
				AND PlantHirePBHeader.PlantDCostGl IS NOT NULL 
				AND PlantHirePBHeader.BorgID = @OrgID 
                AND (ICBORG.BORGID = @OrgID OR ICBORG.ICPLANTJNL = 0)
			GROUP BY PlantHirePBHeader.PlantDCostGl, 
				PlantHirePBReturnsHead.PBRHInvoiceNum, 
				PlantHirePBReturnsHead.ContrNumber, PlantHirePBReturnsHead.ActNumber, 
				BORGS.ICGLCODE, PlantHirePBReturnsHead.PBHid, 
				PlantHirePBHeader.PeNumber, BORGS.ICCREDNO
			SET @holdError = @@ERROR
		END
	END --isInterCompany
FETCH NEXT FROM ORGS_Cursor into @toBorgID
END --orgs cursor
CLOSE ORGS_Cursor
DEALLOCATE ORGS_Cursor


-- Plant Side 
IF @holdError = 0
BEGIN
	INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
		(
		ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], CREDNO, 
		CURRENCY, HOMECURR, VATTYPE, DEBIT, CREDIT, VATDEBIT, VATCREDIT, PlantNo, HeadID, 
		HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, DivID, LINECNTR
		)
	SELECT @OrgID AS ORGID, 
		@Cyear AS TheYEAR, 
		@period AS PERIOD, 
		GETDATE() AS PDATE, 
		@Batchno AS BATCHREF, 
		PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
		'' AS MATCHREF, 
		@transTyp AS TRANSTYPE, 'Plant' AS ALLOCATION, 
		PlantHirePBReturnsValues.GlCode AS ledgercode, 
		'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, isnull(PlantHirePBReturnsHead.DebtNumber, '') AS CREDNO,
		@Ccurr AS currency, @Ccurr AS HOMECURR, 
        PlantHirePBReturnsValues.PBRDVatType AS VATTYPE, 
--2013-12-05 RS Add round inside sum        
		round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS DEBIT, 
		round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
		round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS Vatdeb, 
		round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS Vatcred,  	
		PlantHirePBHeader.PeNumber AS PeNumber, 
		PlantHirePBReturnsHead.PBHid as HeadID, 
		CAST(0 as money) as [HOMECURRAMOUNT], 
		NULL as [CONVERSIONDATE], 
		CAST(1 as money) as [CONVERSIONRATE], 
--2014-02-21 RS Add Division posting to Plant leg
		CASE WHEN PLANTANDEQ.DIVID > 0 then PLANTANDEQ.DIVID else BORGS.DEFDIV end as DIVID,
		9
	FROM PlantHirePBReturnsHead 
		INNER JOIN PlantHirePBHeader 
		ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
		INNER JOIN PlantHirePBReturnsValues 
		ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid		
		Left OUTER JOIN PLANTANDEQ 
		ON PLANTANDEQ.PENUMBER = PlantHirePBHeader.PeNumber 
		INNER JOIN BORGS 
		ON BORGS.BORGID = PLANTANDEQ.BORGID 
	WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2  
		AND PlantHirePBHeader.BorgID = @OrgID
	GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, 
		PlantHirePBReturnsValues.GlCode, PlantHirePBHeader.PeNumber, PlantHirePBReturnsHead.PBHid, PlantHirePBReturnsHead.DebtNumber, PlantHirePBHeader.PeNumber, PlantHirePBReturnsValues.PBRDVatType, PLANTANDEQ.DIVID, BORGS.DEFDIV
	SET @holdError = @@ERROR
END



--Same for RI
IF @holdError = 0
BEGIN
	INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
		(
		ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], 
		CURRENCY, HOMECURR, VATTYPE, DEBIT, CREDIT, VATDEBIT, VATCREDIT, PlantNo, HeadID, ISRILEG, 
		HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
		)
	SELECT @OrgID AS ORGID, 
		@Cyear AS TheYEAR, 
		@period AS PERIOD, 
		GETDATE() AS PDATE, 
		@Batchno AS BATCHREF, 
		PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
		'' AS MATCHREF, 
		@transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, 
		@pctl AS ledgercode, 
		'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
		@Ccurr AS currency, @Ccurr AS HOMECURR, 
        PLANTHIREPBRETURNSVALUES.PBRDVATTYPE AS VATTYPE,  
--2013-12-05 RS Add round inside sum
    round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 Then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS DEBIT, 
		round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 Then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec))) else 0 end), @dec) AS CREDIT, 
    round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS Vatdeb, 
		round((Case when Sum(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then ABS(Sum(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS Vatcred, 			
		PlantHirePBHeader.PeNumber AS PeNumber, 
		PlantHirePBReturnsHead.PBHid as HeadID, 
		1, --ISRILEG 
		CAST(0 as money) as [HOMECURRAMOUNT], 
		NULL as [CONVERSIONDATE], 
		CAST(1 as money) as [CONVERSIONRATE], 
		10
	FROM PlantHirePBReturnsHead 
		INNER JOIN PlantHirePBHeader 
		ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
		INNER JOIN PlantHirePBReturnsValues 
		ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid
	WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2
		AND PlantHirePBHeader.BorgID = @OrgID
	GROUP BY PlantHirePBReturnsHead.PBRHInvoiceNum, 
		PlantHirePBHeader.PeNumber, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, PLANTHIREPBRETURNSVALUES.PBRDVATTYPE
	SET @holdError = @@ERROR
END


-- Debtors Posting 
IF @holdError = 0 
BEGIN
	INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
		(
		ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], 
		CREDNO, CURRENCY, HOMECURR, VATTYPE, DEBIT, CREDIT, VATDEBIT, VATCREDIT, HeadID, 
		HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
		)
	SELECT @OrgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() AS PDATE, 
		@Batchno AS BATCHREF, 
		PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
		'' AS MATCHREF, 
		@transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, 
		DEBTORS.DebtControl AS ledgercode, 'Plant Hire Plant Based' AS DESCRIPTION, -- + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
		DEBTORS.DebtNumber AS CREDNO, @Ccurr AS currency, @Ccurr AS HOMECURR, 
        'Z' AS VATTYPE,  
		round((Case when (SUM(PlantHirePBReturnsValues.PBRDTotalAmount) + SUM(PlantHirePBReturnsValues.PBRDVatAmount)) > 0 then 
			(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) + SUM(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS DEBIT, 
		round((Case when (SUM(PlantHirePBReturnsValues.PBRDTotalAmount) + SUM(PlantHirePBReturnsValues.PBRDVatAmount)) < 0 then 
			ABS(SUM(Round(PlantHirePBReturnsValues.PBRDTotalAmount, @dec)) + SUM(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS CREDIT, 
		0 AS Vatdeb, 
		0 AS Vatcred, 	
		--PlantHirePBReturnsHead.PBHid as HeadID, 
    0  AS HeadID,
		CAST(0 as money) as [HOMECURRAMOUNT], 
		NULL as [CONVERSIONDATE], 
		CAST(1 as money) as [CONVERSIONRATE], 
		11
	FROM PlantHirePBReturnsHead 
		INNER JOIN PlantHirePBHeader 
		ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
		INNER JOIN PlantHirePBReturnsValues 
		ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
		INNER JOIN DEBTORS 
		ON PlantHirePBReturnsHead.DebtNumber = DEBTORS.DebtNumber
	WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
		AND PlantHirePBHeader.BorgID = @OrgID 
		AND DEBTORS.DebtNumber IS NOT NULL
		GROUP BY DEBTORS.DebtNumber, DEBTORS.DebtControl, 
-- 2017-05-25 Remove grouping by Penumber, PBHid, PBRDVatAmount. This will sum posting for plant items. 
		PlantHirePBReturnsHead.PBRHInvoiceNum   --, PlantHirePBReturnsHead.PBHid, --PlantHirePBHeader.PeNumber, PlantHirePBReturnsValues.PBRDVatAmount
	SET @holdError = @@ERROR
END

--VAT control
IF @holdError = 0 
BEGIN
	INSERT BSBS_TEMP.[dbo].[TRANSACTIONS] 
		(
		ORGID, [YEAR], PERIOD, PDATE, BATCHREF, TRANSREF, MATCHREF, TRANSTYPE, ALLOCATION, LEDGERCODE, [DESCRIPTION], 
		CREDNO, CURRENCY, HOMECURR, VATTYPE, DEBIT, CREDIT, VATDEBIT, VATCREDIT, HEADID, 
		HOMECURRAMOUNT, CONVERSIONDATE, CONVERSIONRATE, LINECNTR
		)
	SELECT @OrgID AS ORGID, @Cyear AS TheYEAR, @period AS PERIOD, GETDATE() AS PDATE, 
		@Batchno AS BATCHREF, 
		PlantHirePBReturnsHead.PBRHInvoiceNum AS TRANSREF, 
		'' AS MATCHREF, 
		@transTyp AS TRANSTYPE, 'Balance Sheet' AS ALLOCATION, 
		@vatctl AS ledgercode, 'Plant Hire Plant Based ' + PlantHirePBHeader.PeNumber AS DESCRIPTION, 
		'' AS CREDNO, @Ccurr AS currency, @Ccurr AS HOMECURR, 
        'Z' AS VATTYPE, 
		round((Case when SUM(PlantHirePBReturnsValues.PBRDVatAmount) < 0 then ABS(SUM(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec))) else 0 end), @dec) AS DEBIT, 
		round((Case when SUM(PlantHirePBReturnsValues.PBRDVatAmount) > 0 then SUM(Round(PlantHirePBReturnsValues.PBRDVatAmount, @dec)) else 0 end), @dec) AS CREDIT, 
		0 AS Vatdeb, 0 AS Vatcred, 
		PlantHirePBReturnsHead.PBHid as HeadID, 
		CAST(0 as money) as [HOMECURRAMOUNT], 
		NULL as [CONVERSIONDATE], 
		CAST(1 as money) as [CONVERSIONRATE], 
		12
	FROM PlantHirePBReturnsHead 
		INNER JOIN PlantHirePBHeader 
		ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid 
		INNER JOIN PlantHirePBReturnsValues 
		ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid 
		INNER JOIN DEBTORS 
		ON PlantHirePBReturnsHead.DebtNumber = DEBTORS.DebtNumber
	WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 
		AND PlantHirePBHeader.BorgID = @OrgID 
		AND DEBTORS.DebtNumber IS NOT NULL
	GROUP BY DEBTORS.DebtNumber, DEBTORS.DebtControl, 
	   PlantHirePBReturnsHead.PBRHInvoiceNum, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber
	SET @holdError = @@ERROR   
END	

set @sql = ''
set @sql = @Sql + 'INSERT INTO BSBS_TEMP.dbo.'+ @tblName +' ( '
set @sql = @Sql + '[OrgID], [Year], [Period], [PDate], [BatchRef], [TransRef], [MatchRef], '
set @sql = @Sql + '[TransType], [Allocation], [LedgerCode], [Contract], [Activity], [Description], ' 
set @sql = @Sql + '[ForeignDescription], [Currency], [Debit], [Credit], [VatDebit], [VatCredit], '
set @sql = @Sql + '[Credno], [Store], [Plantno], [Stockno], [Quantity], [Unit], [Rate], [ReqNo], '
set @sql = @Sql + '[OrderNo], [Age], [SubConTran], [VATType], [HomeCurrAmount], [ConversionDate], '
set @sql = @Sql + '[ConversionRate], [PaidFor], [PaidToDate], [PaidThisPeriod], [WhtThisPeriod], '
set @sql = @Sql + '[DiscThisPeriod], [ReconStatus], [UserID], [DivID], [ForexVal], [HEADID], [DOCNUMBER], '
set @sql = @Sql + '[WHTID], ' 
set @sql = @Sql + '[AMOUNT], [HOMECURR], [ISCOSTLEG], [ISRILEG], [ISWIPLEG], [LINECNTR], [RECEIVEDDATE], [TERM], [XGLCODE], [XVATA], [XVATT] '
set @sql = @Sql + ') ' 
set @sql = @Sql + 'SELECT '
set @sql = @Sql + '[OrgID], [Year], [Period], [PDate], [BatchRef], [TransRef], [MatchRef], '
set @sql = @Sql + '[TransType], [Allocation], [LedgerCode], [Contract], [Activity], [Description], '
set @sql = @Sql + '[ForeignDescription], [Currency], [Debit], [Credit], [VatDebit], [VatCredit], '
set @sql = @Sql + '[Credno], [Store], [Plantno], [Stockno], [Quantity], [Unit], [Rate], [ReqNo], '
set @sql = @Sql + '[OrderNo], [Age], [SubConTran], '
set @sql = @Sql + 'case when len(VATTYPE) <= 2 and replace(replace(VATTYPE, '':'', ''''), '', '', '''') = VATTYPE then VATTYPE else ''*'' end, '
set @sql = @Sql + '[HomeCurrAmount], [ConversionDate], '
set @sql = @Sql + '[ConversionRate], [PaidFor], [PaidToDate], [PaidThisPeriod], [WhtThisPeriod], '
set @sql = @Sql + '[DiscThisPeriod], [ReconStatus], [UserID], [DivID], [ForexVal], [HEADID], [DOCNUMBER], '
set @sql = @Sql + '[WHTID], '
set @sql = @Sql + '[AMOUNT], [HOMECURR], [ISCOSTLEG], [ISRILEG], [ISWIPLEG], [LINECNTR], [RECEIVEDDATE], [TERM], [XGLCODE], [XVATA], [XVATT] '
set @sql = @Sql + 'FROM BSBS_TEMP.[dbo].TRANSACTIONS '

EXEC (@sql)


-- Intercompany Journals - Overheads

set @tempSBTran = ''
set @tempSBTran2 = ''
set @tempSBTran3 = ''

set @tempSBTran = @tempSBTran + 'declare @OrgID int '
set @tempSBTran = @tempSBTran + 'declare @Ccurr as char(10) '
set @tempSBTran = @tempSBTran + 'DECLARE @Batchno as char(10) '
set @tempSBTran = @tempSBTran + 'DECLARE @period as int '
set @tempSBTran = @tempSBTran + 'DECLARE @userID as int '

set @tempSBTran = @tempSBTran + 'set @OrgID = ' + cast(@OrgID as nvarchar(10)) + ' '
set @tempSBTran = @tempSBTran + 'set @Ccurr = ''' + @Ccurr + ''' '
set @tempSBTran = @tempSBTran + 'set @Batchno = ''' + @Batchno + ''' '
set @tempSBTran = @tempSBTran + 'set @period = ' + cast(@period as nvarchar(10)) + ' '
set @tempSBTran = @tempSBTran + 'set @userID = ' + cast(@userID as nvarchar(10)) + ' '

set @tempSBTran = @tempSBTran + 'DECLARE @jhID int '
set @tempSBTran = @tempSBTran + 'DECLARE @extOrgID char(10) '
set @tempSBTran = @tempSBTran + 'DECLARE @jnlNumber int '

set @tempSBTran = @tempSBTran + 'DECLARE jnlOverCrsr CURSOR FOR '
set @tempSBTran = @tempSBTran + 'SELECT DISTINCT DIVISIONS.BorgID '
set @tempSBTran = @tempSBTran + 'FROM PlantHirePBReturnsHead '
set @tempSBTran = @tempSBTran + 'INNER JOIN PlantHirePBHeader '
set @tempSBTran = @tempSBTran + 'ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran = @tempSBTran + 'INNER JOIN DIVISIONS '
set @tempSBTran = @tempSBTran + 'ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID '
set @tempSBTran = @tempSBTran + 'INNER JOIN BORGS '
set @tempSBTran = @tempSBTran + 'ON PlantHirePBHeader.BorgID = BORGS.BORGID '
set @tempSBTran = @tempSBTran + 'AND DIVISIONS.BorgID <> BORGS.BORGID '
set @tempSBTran = @tempSBTran + 'INNER JOIN BORGS ICBORGS '
set @tempSBTran = @tempSBTran + 'ON ICBORGS.BORGID = DIVISIONS.BorgID '
set @tempSBTran = @tempSBTran + 'WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran = @tempSBTran + 'AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran = @tempSBTran + 'AND ICBORGS.ICPLANTJNL = 1 '

set @tempSBTran = @tempSBTran + 'if @@error <> 0 BEGIN set @isOK = 1 END '

set @tempSBTran = @tempSBTran + 'OPEN jnlOverCrsr '
set @tempSBTran = @tempSBTran + 'FETCH NEXT FROM jnlOverCrsr INTO @extOrgID '

set @tempSBTran = @tempSBTran + 'WHILE @@FETCH_STATUS = 0 AND @isOK = 0 '
set @tempSBTran = @tempSBTran + 'begin '
set @tempSBTran = @tempSBTran + '	IF @isOK = 0 '
set @tempSBTran = @tempSBTran + '	BEGIN '
set @tempSBTran = @tempSBTran + '		SELECT @jnlNumber = (BORGJNLNO + 1) from BORGS where [BORGID] = @extOrgID '
set @tempSBTran = @tempSBTran + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran = @tempSBTran + '	END '

set @tempSBTran = @tempSBTran + 'IF @isOK = 0 '
set @tempSBTran = @tempSBTran + '	BEGIN '
set @tempSBTran = @tempSBTran + '  INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @OrgID, ''ACC'', ''spPlantHirePB_PostToLedger.xml'', '''', '''') '
set @tempSBTran = @tempSBTran + '  set @scope_identity = scope_identity() '
set @tempSBTran = @tempSBTran + '  SELECT @ContextInfo = cast(@scope_identity AS varbinary(128)) '
set @tempSBTran = @tempSBTran + '  SET CONTEXT_INFO @ContextInfo '

set @tempSBTran = @tempSBTran + '		UPDATE BORGS SET BORGJNLNO = @jnlNumber WHERE [BORGID] = @extOrgID '
set @tempSBTran = @tempSBTran + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran = @tempSBTran + '	END '

set @tempSBTran = @tempSBTran + 'IF @isOK = 0 '
set @tempSBTran = @tempSBTran + '	BEGIN '
set @tempSBTran = @tempSBTran + '		INSERT JOURNALHEADER(JnlHeadBatch, JnlHeadTransRef, JnlHeadDate, '
set @tempSBTran = @tempSBTran + '			JnlHeadCurrency, JnlHeadDescription, JnlUserID, BorgID, JnlUserName, '
set @tempSBTran = @tempSBTran + '			JnlPeriod, JnlHeadExchRate, JnlIsAutoIC) '
set @tempSBTran = @tempSBTran + '		VALUES (@Batchno, CAST(@jnlNumber AS VARCHAR(10)), getdate(), @Ccurr, ''Plant Hire Posting Overheads'', @userID, '
set @tempSBTran = @tempSBTran + '			@extOrgID, ''Administrator'', @period, 1, 1) '
set @tempSBTran = @tempSBTran + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran = @tempSBTran + '	END '


set @tempSBTran = @tempSBTran + '	IF @isOK = 0 '
set @tempSBTran = @tempSBTran + '	BEGIN		 '
set @tempSBTran = @tempSBTran + '		SET @jhID = SCOPE_IDENTITY() '
set @tempSBTran = @tempSBTran + '		/*Overheads External*/ '
set @tempSBTran = @tempSBTran + '		INSERT INTO JOURNALS '
set @tempSBTran = @tempSBTran + '			(JnlLedgerCode, JnlDescription, JnlDivision, JnlDebit, JnlCredit, JnlOrg, JNLTOORG, JnlVatDebit, JnlVatCredit, JnlHomeCurrency, JnlCredno, JnlHeadID, JnlAlloc, JnlVATType, '
set @tempSBTran = @tempSBTran + '			JnlExchRate, JnlContExchRate, JnlPlant, JnlPlantHeadID) '
set @tempSBTran = @tempSBTran + '		SELECT PlantHirePBHeader.PBRHOverLG AS JnlLedgerCode, ''Plant Hire Plant Based '' + PlantHirePBHeader.PeNumber AS JnlDescription, PlantHirePBReturnsHead.DivToID AS JnlContract, '
set @tempSBTran = @tempSBTran + '			(Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(PlantHirePBReturnsValues.PBRDTotalAmount) else 0 end) AS JnlDebit, '
set @tempSBTran = @tempSBTran + '			(Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(PlantHirePBReturnsValues.PBRDTotalAmount)) else 0 end) AS JnlCredit, '
set @tempSBTran = @tempSBTran + '			@extOrgID AS JnlOrg, @extOrgID AS JNLTOORG, 0 AS JnlVatDebit, 0 AS JnlVatCredit, '
set @tempSBTran = @tempSBTran + '			0 AS jnlHomeCurrency, '''' AS JnlCredno, @jhID AS JnlHeadID, ''Overheas'' AS JnlAlloc, ''Z'' AS JnlVATType, 1 AS JnlExchRate, 1 AS JnlContExchRate, '
set @tempSBTran = @tempSBTran + '			PlantHirePBHeader.PeNumber AS JnlPltPlantNum, PlantHirePBReturnsHead.PBHid AS JnlPlantHeadID '
set @tempSBTran = @tempSBTran + '			FROM PlantHirePBReturnsHead '
set @tempSBTran = @tempSBTran + '			INNER JOIN PlantHirePBHeader '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran = @tempSBTran + '			INNER JOIN PlantHirePBReturnsValues '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid '
set @tempSBTran = @tempSBTran + '			INNER JOIN DIVISIONS '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID '
set @tempSBTran = @tempSBTran + '			INNER JOIN BORGS '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBHeader.BorgID = BORGS.BORGID '
set @tempSBTran = @tempSBTran + '			AND DIVISIONS.BorgID <> BORGS.BORGID '
set @tempSBTran = @tempSBTran + '			WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran = @tempSBTran + '			AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran = @tempSBTran + '			AND PlantHirePBReturnsHead.DivToID IS NOT NULL '
set @tempSBTran = @tempSBTran + '			AND DIVISIONS.BORGID = @extOrgID '
set @tempSBTran = @tempSBTran + '			GROUP BY PlantHirePBHeader.PBRHOverLG, PlantHirePBReturnsHead.DivToID, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, PlantHirePBHeader.PeNumber '
set @tempSBTran = @tempSBTran + '			having SUM(PlantHirePBReturnsValues.PBRDTotalAmount) <> 0 '
set @tempSBTran = @tempSBTran + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran = @tempSBTran + '	END '
set @tempSBTran = @tempSBTran + '		 '
set @tempSBTran = @tempSBTran + '	IF @isOK = 0 '
set @tempSBTran = @tempSBTran + '	BEGIN '
set @tempSBTran = @tempSBTran + '		INSERT INTO JOURNALS '
set @tempSBTran = @tempSBTran + '			(JnlLedgerCode, JnlDescription, JnlDivision, JnlDebit, JnlCredit, JnlOrg, JNLTOORG, JnlVatDebit, JnlVatCredit, JnlHomeCurrency, JnlCredno, JnlHeadID, JnlAlloc, JnlVATType, '
set @tempSBTran = @tempSBTran + '			JnlExchRate, JnlContExchRate, JnlPlant, JnlPlantHeadID) '
set @tempSBTran = @tempSBTran + '		SELECT BORGS.ICGLCODE AS JnlLedgerCode, ''Plant Hire Plant Based '' + PlantHirePBHeader.PeNumber AS JnlDescription, PlantHirePBReturnsHead.DivToID AS JnlDivision, '
set @tempSBTran = @tempSBTran + '			(Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) < 0 then ABS(SUM(PlantHirePBReturnsValues.PBRDTotalAmount)) else 0 end) AS JnlDebit, '
set @tempSBTran = @tempSBTran + '			(Case when SUM(PlantHirePBReturnsValues.PBRDTotalAmount) > 0 then SUM(PlantHirePBReturnsValues.PBRDTotalAmount) else 0 end)  AS JnlCredit, '
set @tempSBTran = @tempSBTran + '			@extOrgID AS JnlOrg, @extOrgID AS JNLTOORG, 0 AS JnlVatDebit, 0 AS JnlVatCredit, 0 AS jnlHomeCurrency, '
set @tempSBTran = @tempSBTran + '			'''' AS JnlCredno, @jhID AS JnlHeadID, ''Balance Sheet'' AS JnlAlloc, ''Z'' AS JnlVATType, 1 AS JnlExchRate, 1 AS JnlContExchRate, '
set @tempSBTran = @tempSBTran + '			PlantHirePBHeader.PeNumber AS JnlPltPlantNum, PlantHirePBReturnsHead.PBHid AS JnlPlantHeadID '
set @tempSBTran = @tempSBTran + '			FROM PlantHirePBReturnsHead '
set @tempSBTran = @tempSBTran + '			INNER JOIN PlantHirePBHeader '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran = @tempSBTran + '			INNER JOIN PlantHirePBReturnsValues '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid '
set @tempSBTran = @tempSBTran + '			INNER JOIN BORGS '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBHeader.BorgID = BORGS.BORGID '
set @tempSBTran = @tempSBTran + '			INNER JOIN DIVISIONS '
set @tempSBTran = @tempSBTran + '			ON PlantHirePBReturnsHead.DivToID = DIVISIONS.DivID '
set @tempSBTran = @tempSBTran + '			AND BORGS.BORGID <> DIVISIONS.BorgID '
set @tempSBTran = @tempSBTran + '			WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran = @tempSBTran + '			AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran = @tempSBTran + '			AND PlantHirePBReturnsHead.DivToID IS NOT NULL '
set @tempSBTran = @tempSBTran + '			AND DIVISIONS.BORGID = @extOrgID '
set @tempSBTran = @tempSBTran + '			GROUP BY PlantHirePBHeader.PlantDCostGl, PlantHirePBReturnsHead.DivToID, BORGS.ICGLCODE, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber, PlantHirePBHeader.PeNumber '
set @tempSBTran = @tempSBTran + '			having SUM(PlantHirePBReturnsValues.PBRDTotalAmount) <> 0 '
set @tempSBTran = @tempSBTran + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran = @tempSBTran + '	END '

set @tempSBTran = @tempSBTran + '	FETCH NEXT FROM jnlOverCrsr INTO @extOrgID '
set @tempSBTran = @tempSBTran + 'END '
set @tempSBTran = @tempSBTran + 'CLOSE jnlOverCrsr '
set @tempSBTran = @tempSBTran + 'DEALLOCATE jnlOverCrsr '

set @tempSBTran2 = @tempSBTran2 + '/*Intercompany Journals - Contracts*/ ' 
set @tempSBTran2 = @tempSBTran2 + 'DECLARE jnlBorgsCrsr CURSOR FOR '
set @tempSBTran2 = @tempSBTran2 + 'SELECT DISTINCT PROJECTS.BORGID '
set @tempSBTran2 = @tempSBTran2 + 'FROM PlantHirePBReturnsHead '
set @tempSBTran2 = @tempSBTran2 + 'INNER JOIN PlantHirePBHeader '
set @tempSBTran2 = @tempSBTran2 + 'ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran2 = @tempSBTran2 + 'INNER JOIN CONTRACTS '
set @tempSBTran2 = @tempSBTran2 + 'ON PlantHirePBReturnsHead.ContrNumber = CONTRACTS.CONTRNUMBER '
set @tempSBTran2 = @tempSBTran2 + 'INNER JOIN PROJECTS '
set @tempSBTran2 = @tempSBTran2 + 'ON CONTRACTS.PROJID = PROJECTS.PROJID '
set @tempSBTran2 = @tempSBTran2 + 'AND PlantHirePBHeader.BorgID <> PROJECTS.BORGID '
set @tempSBTran2 = @tempSBTran2 + 'INNER JOIN BORGS ICBORGS '
set @tempSBTran2 = @tempSBTran2 + 'ON ICBORGS.BORGID = PROJECTS.BorgID '
set @tempSBTran2 = @tempSBTran2 + 'WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran2 = @tempSBTran2 + 'AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran2 = @tempSBTran2 + 'AND ICBORGS.ICPLANTJNL = 1 '

set @tempSBTran2 = @tempSBTran2 + 'if @@error <> 0 BEGIN set @isOK = 1 END '

set @tempSBTran2 = @tempSBTran2 + 'OPEN jnlBorgsCrsr '
set @tempSBTran2 = @tempSBTran2 + 'FETCH NEXT FROM jnlBorgsCrsr INTO @extOrgID '

set @tempSBTran2 = @tempSBTran2 + 'WHILE @@FETCH_STATUS = 0 AND @isOK = 0 '
set @tempSBTran2 = @tempSBTran2 + 'begin '
set @tempSBTran2 = @tempSBTran2 + '	IF @isOK = 0 '
set @tempSBTran2 = @tempSBTran2 + '	BEGIN '
set @tempSBTran2 = @tempSBTran2 + '		SELECT @jnlNumber = (BORGJNLNO + 1) from BORGS where [BORGID] = @extOrgID '
set @tempSBTran2 = @tempSBTran2 + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran2 = @tempSBTran2 + '	END '

set @tempSBTran2 = @tempSBTran2 + 'IF @isOK = 0 '
set @tempSBTran2 = @tempSBTran2 + '	BEGIN '
set @tempSBTran2 = @tempSBTran2 + '		INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @OrgID, ''ACC'', ''spPlantHirePB_PostToLedger.xml'', '''', '''') '
set @tempSBTran2 = @tempSBTran2 + '  set @scope_identity = scope_identity() '
set @tempSBTran2 = @tempSBTran2 + '  SELECT @ContextInfo = cast(@scope_identity AS varbinary(128)) '
set @tempSBTran2 = @tempSBTran2 + '  SET CONTEXT_INFO @ContextInfo '

set @tempSBTran2 = @tempSBTran2 + '  UPDATE BORGS SET BORGJNLNO = @jnlNumber WHERE [BORGID]= @extOrgID '
set @tempSBTran2 = @tempSBTran2 + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran2 = @tempSBTran2 + '	END '

set @tempSBTran2 = @tempSBTran2 + '	IF @isOK = 0 '
set @tempSBTran2 = @tempSBTran2 + '	BEGIN '
set @tempSBTran2 = @tempSBTran2 + '		INSERT JOURNALHEADER(JnlHeadBatch, JnlHeadTransRef, JnlHeadDate, '
set @tempSBTran2 = @tempSBTran2 + '			JnlHeadCurrency, JnlHeadDescription, JnlUserID, BorgID, JnlUserName, '
set @tempSBTran2 = @tempSBTran2 + '			JnlPeriod, JnlHeadExchRate, JnlIsAutoIC) '
set @tempSBTran2 = @tempSBTran2 + '		VALUES (@Batchno, CAST(@jnlNumber AS VARCHAR(10)), getdate(), @Ccurr, ''Plant Hire Posting Contracts'', @userID, '
set @tempSBTran2 = @tempSBTran2 + '			@extOrgID, ''Administrator'', @period, 1, 1) '
set @tempSBTran2 = @tempSBTran2 + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran2 = @tempSBTran2 + '	END '
set @tempSBTran2 = @tempSBTran2 + '			 '
set @tempSBTran2 = @tempSBTran2 + '	IF @isOK = 0 '
set @tempSBTran2 = @tempSBTran2 + '	BEGIN		 '
set @tempSBTran2 = @tempSBTran2 + '		SET @jhID = SCOPE_IDENTITY() '

set @tempSBTran2 = @tempSBTran2 + '		INSERT JOURNALS(JnlLedgerCode, JnlDescription, JnlContract, JnlActivity, '
set @tempSBTran2 = @tempSBTran2 + '			JnlDebit, JnlCredit, JnlOrg, JNLTOORG, JnlVatDebit, '
set @tempSBTran2 = @tempSBTran2 + '			JnlVatCredit, JnlHomeCurrency, JnlCredno, JnlHeadID, JnlAlloc, '
set @tempSBTran2 = @tempSBTran2 + '			JnlVATType, JnlExchRate, JnlContExchRate, JnlPlant, JnlPlantHeadID) '
set @tempSBTran2 = @tempSBTran2 + '		SELECT PlantHirePBHeader.PlantDCostGl, '
set @tempSBTran2 = @tempSBTran2 + '			''Plant Hire Plant Based '' + PlantHirePBHeader.PeNumber AS JnlDescription, '
set @tempSBTran2 = @tempSBTran2 + '			PlantHirePBReturnsHead.contrNumber AS JnlContract, '
set @tempSBTran2 = @tempSBTran2 + '			actNumber AS JnlActivity, '
set @tempSBTran2 = @tempSBTran2 + '			(case when SUM(PBRDTotalAmount)> 0 then SUM(PBRDTotalAmount) else 0 end) AS JnlDebit, '
set @tempSBTran2 = @tempSBTran2 + '			(case when SUM(PBRDTotalAmount)< 0 then ABS(SUM(PBRDTotalAmount)) else 0 end) AS JnlCredit, '
set @tempSBTran2 = @tempSBTran2 + '			@extOrgID as JnlOrg, '
set @tempSBTran2 = @tempSBTran2 + '			@extOrgID as JNLTOORG, 0, 0, 0 AS jnlHomeCurrency, '
set @tempSBTran2 = @tempSBTran2 + '			'''' AS JnlCredno, @jhID AS JnlHeadID, ''Contracts'' AS JnlAlloc, '
set @tempSBTran2 = @tempSBTran2 + '			''Z'' AS JnlVATType, 1 AS JnlExchRate, 1 AS JnlContExchRate, PlantHirePBHeader.PeNumber as JnlPltPlantNum, PlantHirePBReturnsHead.PBHid as JnlPlantHeadID '
set @tempSBTran2 = @tempSBTran2 + '		FROM PlantHirePBReturnsHead '
set @tempSBTran2 = @tempSBTran2 + '			INNER JOIN PlantHirePBHeader '
set @tempSBTran2 = @tempSBTran2 + '			ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran2 = @tempSBTran2 + '			INNER JOIN CONTRACTS '
set @tempSBTran2 = @tempSBTran2 + '			ON PlantHirePBReturnsHead.ContrNumber = CONTRACTS.CONTRNUMBER '
set @tempSBTran2 = @tempSBTran2 + '			INNER JOIN PROJECTS '
set @tempSBTran2 = @tempSBTran2 + '			ON CONTRACTS.PROJID = PROJECTS.PROJID '
set @tempSBTran2 = @tempSBTran2 + '			AND PlantHirePBHeader.BorgID <> PROJECTS.BORGID '
set @tempSBTran2 = @tempSBTran2 + '			INNER JOIN PlantHirePBReturnsValues '
set @tempSBTran2 = @tempSBTran2 + '			ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid '
set @tempSBTran2 = @tempSBTran2 + '		WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran2 = @tempSBTran2 + '			AND PlantHirePBReturnsHead.ContrNumber IS NOT NULL '
set @tempSBTran2 = @tempSBTran2 + '			AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran2 = @tempSBTran2 + '			AND PROJECTS.BORGID = @extOrgID '
set @tempSBTran2 = @tempSBTran2 + '		GROUP BY PlantHirePBHeader.PlantDCostGl, '
set @tempSBTran2 = @tempSBTran2 + '			PlantHirePBReturnsHead.ContrNumber, PlantHirePBReturnsHead.ActNumber, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber '
set @tempSBTran2 = @tempSBTran2 + '		having SUM(PlantHirePBReturnsValues.PBRDTotalAmount) <> 0 '
set @tempSBTran2 = @tempSBTran2 + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran2 = @tempSBTran2 + '	END '
set @tempSBTran2 = @tempSBTran2 + '		 '
set @tempSBTran2 = @tempSBTran2 + '	IF @isOK = 0 '
set @tempSBTran2 = @tempSBTran2 + '	BEGIN '
set @tempSBTran2 = @tempSBTran2 + '		INSERT JOURNALS(JnlLedgerCode, '
set @tempSBTran2 = @tempSBTran2 + '			JnlDescription, JnlContract, JnlActivity, JnlDebit, JnlCredit, JnlOrg, JNLTOORG, '
set @tempSBTran2 = @tempSBTran2 + '			JnlVatDebit, JnlVatCredit, JnlHomeCurrency, JnlCredno, '
set @tempSBTran2 = @tempSBTran2 + '			JnlHeadID, JnlAlloc, JnlVATType, JnlExchRate, JnlContExchRate, JnlPlant, JnlPlantHeadID) '
set @tempSBTran2 = @tempSBTran2 + '		SELECT Borgs.ICGlCode, ''Plant Hire Plant Based '' + PlantHirePBHeader.PeNumber AS JnlDescription, '
set @tempSBTran2 = @tempSBTran2 + '			'''' AS JnlContract, '
set @tempSBTran2 = @tempSBTran2 + '			'''' AS JnlActivity, '
set @tempSBTran2 = @tempSBTran2 + '			(case when SUM(PBRDTotalAmount)< 0 then ABS(SUM(PBRDTotalAmount)) else 0 end) AS JnlDebit, '
set @tempSBTran2 = @tempSBTran2 + '			(case when SUM(PBRDTotalAmount)> 0 then SUM(PBRDTotalAmount) else 0 end) AS JnlCredit, '
set @tempSBTran2 = @tempSBTran2 + '			@extOrgID, @extOrgID, 0, 0, '
set @tempSBTran2 = @tempSBTran2 + '			0 AS jnlHomeCurrency, '''' AS JnlCredno, '
set @tempSBTran2 = @tempSBTran2 + '			@jhID AS JnlHeadID, ''Balance Sheet'' AS JnlAlloc, '
set @tempSBTran2 = @tempSBTran2 + '			''Z'' AS JnlVATType, 1 AS JnlExchRate, '
set @tempSBTran2 = @tempSBTran2 + '			1 AS JnlContExchRate, PlantHirePBHeader.PeNumber as JnlPltPlantNum, PlantHirePBReturnsHead.PBHid as JnlPlantHeadID '
set @tempSBTran2 = @tempSBTran2 + '		FROM PlantHirePBReturnsHead '
set @tempSBTran2 = @tempSBTran2 + '		INNER JOIN PlantHirePBHeader '
set @tempSBTran2 = @tempSBTran2 + '		ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran2 = @tempSBTran2 + '		INNER JOIN CONTRACTS '
set @tempSBTran2 = @tempSBTran2 + '		ON PlantHirePBReturnsHead.ContrNumber = CONTRACTS.CONTRNUMBER '
set @tempSBTran2 = @tempSBTran2 + '		INNER JOIN PROJECTS '
set @tempSBTran2 = @tempSBTran2 + '		ON CONTRACTS.PROJID = PROJECTS.PROJID '
set @tempSBTran2 = @tempSBTran2 + '		AND PlantHirePBHeader.BorgID <> PROJECTS.BORGID '
set @tempSBTran2 = @tempSBTran2 + '		INNER JOIN PlantHirePBReturnsValues '
set @tempSBTran2 = @tempSBTran2 + '		ON PlantHirePBReturnsHead.PBRHid = PlantHirePBReturnsValues.PBRHid '
set @tempSBTran2 = @tempSBTran2 + '		INNER JOIN BORGS '
set @tempSBTran2 = @tempSBTran2 + '		ON PlantHirePBHeader.BorgID = BORGS.BORGID '
set @tempSBTran2 = @tempSBTran2 + '		WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran2 = @tempSBTran2 + '			AND PlantHirePBReturnsHead.ContrNumber IS NOT NULL '
set @tempSBTran2 = @tempSBTran2 + '			AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran2 = @tempSBTran2 + '			AND PROJECTS.BORGID = @extOrgID '
set @tempSBTran2 = @tempSBTran2 + '		GROUP BY PlantHirePBHeader.PlantDCostGl, '
set @tempSBTran2 = @tempSBTran2 + '			PlantHirePBReturnsHead.ContrNumber, PlantHirePBReturnsHead.ActNumber, '
set @tempSBTran2 = @tempSBTran2 + '			BORGS.ICGLCODE, PlantHirePBReturnsHead.PBHid, PlantHirePBHeader.PeNumber '
set @tempSBTran2 = @tempSBTran2 + '		having SUM(PlantHirePBReturnsValues.PBRDTotalAmount) <> 0	 '
set @tempSBTran2 = @tempSBTran2 + '		if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran2 = @tempSBTran2 + '	END '

set @tempSBTran2 = @tempSBTran2 + '	FETCH NEXT FROM jnlBorgsCrsr INTO @extOrgID '
set @tempSBTran2 = @tempSBTran2 + 'END '

set @tempSBTran2 = @tempSBTran2 + 'CLOSE jnlBorgsCrsr '
set @tempSBTran2 = @tempSBTran2 + 'DEALLOCATE jnlBorgsCrsr '

set @tempSBTran3 = @tempSBTran3 + 'IF @isOK = 0 '
set @tempSBTran3 = @tempSBTran3 + 'BEGIN '
set @tempSBTran3 = @tempSBTran3 + '	update PlantHirePBHeader '
set @tempSBTran3 = @tempSBTran3 + '	set PlantHirePBHeader.PBHClosed = 1 '
set @tempSBTran3 = @tempSBTran3 + '	FROM PlantHirePBReturnsHead '
set @tempSBTran3 = @tempSBTran3 + '	INNER JOIN PlantHirePBHeader '
set @tempSBTran3 = @tempSBTran3 + '	ON  PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran3 = @tempSBTran3 + '	where PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran3 = @tempSBTran3 + '	AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran3 = @tempSBTran3 + '	if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran3 = @tempSBTran3 + 'END	 '

set @tempSBTran3 = @tempSBTran3 + '/*2012-03-05 Matthew - Update Assets.Usage to 1 when qty for that asset plant return post is used*/ '
set @tempSBTran3 = @tempSBTran3 + 'IF @isOK = 0 '
set @tempSBTran3 = @tempSBTran3 + 'BEGIN '
set @tempSBTran3 = @tempSBTran3 + '    INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @OrgID, ''ACC'', ''spPlantHirePB_PostToLedger.xml'', '''', '''') '
set @tempSBTran3 = @tempSBTran3 + '    set @scope_identity = scope_identity() '
set @tempSBTran3 = @tempSBTran3 + '    SELECT @ContextInfo = cast(@scope_identity AS varbinary(128)) '
set @tempSBTran3 = @tempSBTran3 + '    SET CONTEXT_INFO @ContextInfo '

set @tempSBTran3 = @tempSBTran3 + '    update ASSETS '
set @tempSBTran3 = @tempSBTran3 + '    set USAGE = 1 '
set @tempSBTran3 = @tempSBTran3 + '    from ASSETS '
set @tempSBTran3 = @tempSBTran3 + '    INNER JOIN '
set @tempSBTran3 = @tempSBTran3 + '    ( '
set @tempSBTran3 = @tempSBTran3 + '     SELECT DISTINCT ASSETID '
set @tempSBTran3 = @tempSBTran3 + '     FROM PlantHirePBReturnsHead '
set @tempSBTran3 = @tempSBTran3 + '     inner join PlantHirePBHeader on PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran3 = @tempSBTran3 + '     INNER JOIN PLANTANDEQ on PLANTANDEQ.PeNumber = PlantHirePBHeader.PeNumber '
set @tempSBTran3 = @tempSBTran3 + '     and PLANTANDEQ.BorgID = PlantHirePBHeader.BorgID '
set @tempSBTran3 = @tempSBTran3 + '     inner join ASSETS '
set @tempSBTran3 = @tempSBTran3 + '     on left(ASSETS.ASSETNUMBER, charindex(''.'',ASSETS.ASSETNUMBER+''.'')-1) = PlantHirePBHeader.PeNumber '
set @tempSBTran3 = @tempSBTran3 + '     and ASSETS.BorgID = PlantHirePBHeader.BorgID '
set @tempSBTran3 = @tempSBTran3 + '     WHERE (abs(PBRHq1) + abs(PBRHq2) + abs(PBRHq3) + abs(PBRHq4) + abs(PBRHq5)) > 0 '
set @tempSBTran3 = @tempSBTran3 + '     and PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran3 = @tempSBTran3 + '     AND PlantHirePBHeader.BORGID = @OrgID '
set @tempSBTran3 = @tempSBTran3 + '    ) A1 on ASSETS.ASSETID = A1.ASSETID '
set @tempSBTran3 = @tempSBTran3 + 'end '

set @tempSBTran3 = @tempSBTran3 + '/*2012-03-14 Matthew - Update Assets.AssetHrsToDate*/ '
set @tempSBTran3 = @tempSBTran3 + 'IF @isOK = 0 '
set @tempSBTran3 = @tempSBTran3 + 'BEGIN '

set @tempSBTran3 = @tempSBTran3 + '    declare @hrsPerDay decimal(18, 4) '
set @tempSBTran3 = @tempSBTran3 + '    declare @hrsPerWeek decimal(18, 4) '
set @tempSBTran3 = @tempSBTran3 + '    declare @hrsPerMonth decimal(18, 4) '

set @tempSBTran3 = @tempSBTran3 + '    set @hrsPerDay = 0 '
set @tempSBTran3 = @tempSBTran3 + '    set @hrsPerWeek = 0 '
set @tempSBTran3 = @tempSBTran3 + '    set @hrsPerMonth = 0 '

set @tempSBTran3 = @tempSBTran3 + '    select top 1 @hrsPerDay = isnull(HireVHrPerDay, 0), '
set @tempSBTran3 = @tempSBTran3 + '    @hrsPerWeek = isnull(HireVDayPerWeek, 0) * isnull(HireVHrPerDay, 0), '
set @tempSBTran3 = @tempSBTran3 + '    @hrsPerMonth = isnull(HireVDayPerMonth, 0) * isnull(HireVHrPerDay, 0) '
set @tempSBTran3 = @tempSBTran3 + '    from PLANTHIREVARIABLES where borgid in (-1, @orgid) '
set @tempSBTran3 = @tempSBTran3 + '    order by borgid desc '

set @tempSBTran3 = @tempSBTran3 + '    INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @OrgID, ''ACC'', ''spPlantHirePB_PostToLedger.xml'', '''', '''') '
set @tempSBTran3 = @tempSBTran3 + '    set @scope_identity = scope_identity() '
set @tempSBTran3 = @tempSBTran3 + '    SELECT @ContextInfo = cast(@scope_identity AS varbinary(128)) '
set @tempSBTran3 = @tempSBTran3 + '    SET CONTEXT_INFO @ContextInfo '

set @tempSBTran3 = @tempSBTran3 + '    update ASSETS '
set @tempSBTran3 = @tempSBTran3 + '    set AssetHrsToDate = AssetHrsToDate + A1.AssetHrsToDateSUM '
set @tempSBTran3 = @tempSBTran3 + '    from ASSETS '
set @tempSBTran3 = @tempSBTran3 + '    INNER JOIN '
set @tempSBTran3 = @tempSBTran3 + '    ( '
set @tempSBTran3 = @tempSBTran3 + '     SELECT ASSETID, '
set @tempSBTran3 = @tempSBTran3 + '     sum( '
set @tempSBTran3 = @tempSBTran3 + '     	case when PLANTCATEGORIES.CatActWorkHr1 = 1 then PlantHirePBReturnsHead.PBRHq1 * (case CatUnit1 when ''Day'' then @hrsPerDay when ''PartMount'' then @hrsPerDay when ''Week'' then @hrsPerWeek when ''Month'' then @hrsPerMonth when ''Hr'' then 1 else 0 end) else 0 end '
set @tempSBTran3 = @tempSBTran3 + '     	+ case when PLANTCATEGORIES.CatActWorkHr2 = 1 then PlantHirePBReturnsHead.PBRHq2 * (case CatUnit2 when ''Day'' then @hrsPerDay when ''PartMount'' then @hrsPerDay when ''Week'' then @hrsPerWeek when ''Month'' then @hrsPerMonth when ''Hr'' then 1 else 0 end) else 0 end '
set @tempSBTran3 = @tempSBTran3 + '     	+ case when PLANTCATEGORIES.CatActWorkHr3 = 1 then PlantHirePBReturnsHead.PBRHq3 * (case CatUnit3 when ''Day'' then @hrsPerDay when ''PartMount'' then @hrsPerDay when ''Week'' then @hrsPerWeek when ''Month'' then @hrsPerMonth when ''Hr'' then 1 else 0 end) else 0 end '
set @tempSBTran3 = @tempSBTran3 + '     	+ case when PLANTCATEGORIES.CatActWorkHr4 = 1 then PlantHirePBReturnsHead.PBRHq4 * (case CatUnit4 when ''Day'' then @hrsPerDay when ''PartMount'' then @hrsPerDay when ''Week'' then @hrsPerWeek when ''Month'' then @hrsPerMonth when ''Hr'' then 1 else 0 end) else 0 end '
set @tempSBTran3 = @tempSBTran3 + '     	+ case when PLANTCATEGORIES.CatActWorkHr5 = 1 then PlantHirePBReturnsHead.PBRHq5 * (case CatUnit5 when ''Day'' then @hrsPerDay when ''PartMount'' then @hrsPerDay when ''Week'' then @hrsPerWeek when ''Month'' then @hrsPerMonth when ''Hr'' then 1 else 0 end) else 0 end '
set @tempSBTran3 = @tempSBTran3 + '     ) as AssetHrsToDateSUM '
set @tempSBTran3 = @tempSBTran3 + '     FROM PlantHirePBReturnsHead '
set @tempSBTran3 = @tempSBTran3 + '     inner join PlantHirePBHeader on PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran3 = @tempSBTran3 + '     INNER JOIN PLANTANDEQ on PLANTANDEQ.PeNumber = PlantHirePBHeader.PeNumber '
set @tempSBTran3 = @tempSBTran3 + '     and PLANTANDEQ.BorgID = PlantHirePBHeader.BorgID '
set @tempSBTran3 = @tempSBTran3 + '     inner join ASSETS '
set @tempSBTran3 = @tempSBTran3 + '     on left(ASSETS.ASSETNUMBER, charindex(''.'',ASSETS.ASSETNUMBER+''.'')-1) = PlantHirePBHeader.PeNumber '
set @tempSBTran3 = @tempSBTran3 + '     and ASSETS.BorgID = PlantHirePBHeader.BorgID '
set @tempSBTran3 = @tempSBTran3 + '     INNER JOIN PLANTCATEGORIES ON PLANTANDEQ.CATID = PLANTCATEGORIES.CATID '
set @tempSBTran3 = @tempSBTran3 + '     WHERE PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran3 = @tempSBTran3 + '     AND PlantHirePBHeader.BORGID = @OrgID '
set @tempSBTran3 = @tempSBTran3 + '     GROUP BY ASSETS.ASSETID '
set @tempSBTran3 = @tempSBTran3 + '    ) A1 on ASSETS.ASSETID = A1.ASSETID '
set @tempSBTran3 = @tempSBTran3 + 'end '

set @tempSBTran3 = @tempSBTran3 + 'IF @isOK = 0 '
set @tempSBTran3 = @tempSBTran3 + 'begin '
set @tempSBTran3 = @tempSBTran3 + '	update PlantHirePBReturnsHead '
set @tempSBTran3 = @tempSBTran3 + '	set PlantHirePBReturnsHead.PBRHPostFlag = 3, '
set @tempSBTran3 = @tempSBTran3 + '	PBRHPostUserID= @userID, PBRHPostTheDate = getDATE() '
set @tempSBTran3 = @tempSBTran3 + '	FROM PlantHirePBReturnsHead '
set @tempSBTran3 = @tempSBTran3 + '	INNER JOIN PlantHirePBHeader '
set @tempSBTran3 = @tempSBTran3 + '	ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid '
set @tempSBTran3 = @tempSBTran3 + '	where PlantHirePBReturnsHead.PBRHPostFlag = 2 '
set @tempSBTran3 = @tempSBTran3 + '	AND PlantHirePBHeader.BorgID = @OrgID '
set @tempSBTran3 = @tempSBTran3 + '	if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran3 = @tempSBTran3 + 'end	 '

set @tempSBTran3 = @tempSBTran3 + 'DECLARE @invPref as char(5), @invNum int '

set @tempSBTran3 = @tempSBTran3 + 'set @invPref = (SELECT PlantHirePBInvoicePref FROM BORGS WHERE (BORGID = @OrgID))		 '

set @tempSBTran3 = @tempSBTran3 + 'set @invNum = isnull((SELECT MAX(CONVERT(int, REPLACE(TransRef, rtrim(@invPref), ''''))) AS LastInvNum '
set @tempSBTran3 = @tempSBTran3 + '	FROM BSBS_TEMP.dbo.TRANSACTIONS '
set @tempSBTran3 = @tempSBTran3 + '	WHERE OrgID = @OrgID), '''') '

set @tempSBTran3 = @tempSBTran3 + 'IF @isOK = 0 '
set @tempSBTran3 = @tempSBTran3 + 'begin '

set @tempSBTran3 = @tempSBTran3 + '  INSERT INTO LOGCONTEXT (USERID, BORGID, APPLICATION, PAGE, INFO, VERSION) VALUES (-1, @OrgID, ''ACC'', ''spPlantHirePB_PostToLedger.xml'', '''', '''') '
set @tempSBTran3 = @tempSBTran3 + '  set @scope_identity = scope_identity() '
set @tempSBTran3 = @tempSBTran3 + '  SELECT @ContextInfo = cast(@scope_identity AS varbinary(128)) '
set @tempSBTran3 = @tempSBTran3 + '  SET CONTEXT_INFO @ContextInfo '

set @tempSBTran3 = @tempSBTran3 + '  UPDATE BORGS '
set @tempSBTran3 = @tempSBTran3 + '	SET PlantHirePBInvoiceNum = @invNum '
set @tempSBTran3 = @tempSBTran3 + '	WHERE (BORGID = @OrgID) '
set @tempSBTran3 = @tempSBTran3 + '	if @@error <> 0 BEGIN set @isOK = 1 END '
set @tempSBTran3 = @tempSBTran3 + 'end '
 
		