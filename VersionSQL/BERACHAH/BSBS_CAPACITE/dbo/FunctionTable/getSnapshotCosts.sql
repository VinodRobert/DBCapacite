/****** Object:  Function [dbo].[getSnapshotCosts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-06-2016
-- Description:	returns Snapshot Costs
-- NOTES:
-- 14-08-2020 RiaanE - Performance improvements 
-- =============================================
create FUNCTION [dbo].[getSnapshotCosts] (@snapshotId int)
    RETURNS @t TABLE (
	  [Transaction Date] datetime,
	  [Period] int,	
	  [BatchRef] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [TransRef] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Description]	nvarchar(255) collate SQL_Latin1_General_CP1_CI_AS,	
	  [GRNNO] nvarchar(12) collate SQL_Latin1_General_CP1_CI_AS,
	  [OrderNo] nvarchar(55) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Unit] nvarchar(25) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Qty] numeric(23,4),	
	  [RATE] numeric(23,4),	
	  [Amount] money,	
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),	
	  [Ledger Code] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Ledger Name] nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Project Number] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Project Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Contract Number]	nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,
	  [Contract Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,		
	  [Currency] nvarchar(3) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Credno] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Allocation] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Year] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
	  [TransType] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
	  [CONTROLTYPE] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
	  [BFWDORDER] int	  
  )
AS
BEGIN

	declare @ptControl as nvarchar(10);
	declare @ccControlF as nvarchar(10);
  declare @ccControlT as nvarchar(10);
	declare @projName as nvarchar(50);
	declare @projNumber as nvarchar(10);
	declare @projId as int;
	declare @contrName as nvarchar(100);
	declare @accrualDate as datetime;
	declare @candyImportDate as datetime;
	declare @contrno as nvarchar(20);
	declare @currency nvarchar(3);
	declare @borgId int;
	declare @theDate datetime;
	declare @year char(10);
	declare @period int;
	declare @costsOnly bit;
	
	select @theDate = CreatedDate, @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID, @year = [Year], @period = Period, @costsOnly = CostsOnly from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;
	select @currency = CURRENCY from BORGS where BORGID = @borgId;	

	select @ptControl = CONTROLCODES.ControlFromGL 
    from CONTROLCODES 
    where CONTROLCODES.ControlName = 'Profit Taken'; 
						
    select @ccControlF = CONTROLCODES.ControlFromGL, @ccControlT = CONTROLCODES.ControlToGL
    from CONTROLCODES
    where CONTROLCODES.ControlName = 'Contract Costs';
    
  declare @TRANSNAPSHOTTEMP table (
	[OrgID] [int] NOT NULL,
	[Year] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Period] [int] NOT NULL,
	[PDate] [datetime] NULL,
	[BatchRef] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TransRef] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MatchRef] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TransType] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LedgerCode] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Contract] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Activity] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [nvarchar](255) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Currency] [nvarchar](3) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Debit] [money] NOT NULL,
	[Credit] [money] NOT NULL,
	[VatDebit] [money] NOT NULL,
	[VatCredit] [money] NOT NULL,
	[Credno] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Store] [nvarchar](20) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Plantno] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Stockno] [nvarchar](20) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Quantity] [numeric](23, 4) NOT NULL,
	[Rate] [money] NOT NULL,
	[Age] [int] NOT NULL,
	[TransID] [int] NOT NULL,
	[VATType] [char](2) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HomeCurrAmount] [money] NULL,
	[ConversionDate] [datetime] NULL,
	[ConversionRate] [money] NOT NULL,
	[PaidFor] [bit] NOT NULL,
	[PaidToDate] [money] NOT NULL,
	[PaidThisPeriod] [money] NOT NULL,
	[WhtThisPeriod] [money] NOT NULL,
	[DiscThisPeriod] [money] NOT NULL,
	[ReconStatus] [int] NOT NULL,
	[UserID] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NULL,
	[DivID] [int] NOT NULL,
	[ForexVal] [money] NOT NULL,
	[HeadID] [char](10) NULL,
	[WHTID] [int] NULL,
	[FBID] [int] NULL,
	[TERM] [int] NULL,
	[SYSDATE] [datetime] NULL,
	[RECEIVEDDATE] [datetime] NULL,
	[ORIGTRANSID] [int] NULL,
	[HCTODATE] [numeric](18, 4) NULL,
	[TRANGRP] [int] NULL,
	[REQNO] [varchar](55) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ORDERNO] [varchar](55) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FOREIGNDESCRIPTION] [varchar](255) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ALLOCATION] [varchar](15) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DOCNUMBER] [varchar](50) collate SQL_Latin1_General_CP1_CI_AS NULL,
	[UNIT] [varchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SUBCONTRAN] [varchar](20) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[XGLCODE] [nvarchar](10) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[XVATA] [money] NOT NULL,
	[XVATT] [char](2) collate SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ROLLEDFWD] [int] NULL,
	[ROWNUM] bigint identity(1, 1),
	UNIQUE NONCLUSTERED ([OrgID],[Year],[Period],[Contract],[ALLOCATION],[PDate],[LedgerCode], [BatchRef],[TransRef],[TransType],[Activity],[Currency],[Debit],[Credit],[Credno], [ROWNUM])
	)

	insert into @TRANSNAPSHOTTEMP
	SELECT T.OrgID, T.Year, T.Period, T.PDate, T.BatchRef, T.TransRef, T.MatchRef, T.TransType, T.LedgerCode, T.Contract, T.Activity, T.Description, T.Currency, T.Debit, T.Credit, T.VatDebit, T.VatCredit, 
    T.Credno, T.Store, T.Plantno, T.Stockno, T.Quantity, T.Rate, T.Age, T.TransID, T.VATType, T.HomeCurrAmount, T.ConversionDate, T.ConversionRate, 
    isnull(TS.PaidFor, T.PaidFor) PaidFor, isnull(TS.PaidToDate, T.PaidToDate) PaidToDate, isnull(TS.PaidThisPeriod, T.PaidThisPeriod) PaidThisPeriod, T.WhtThisPeriod, T.DiscThisPeriod, 
    isnull(TS.ReconStatus, T.ReconStatus) ReconStatus, T.UserID, T.DivID, T.ForexVal, T.HeadID, T.WHTID, T.FBID, T.TERM,
    T.SYSDATE, T.RECEIVEDDATE, T.ORIGTRANSID, T.HCTODATE, T.TRANGRP, T.REQNO, T.ORDERNO, T.FOREIGNDESCRIPTION, T.ALLOCATION, 
    T.DOCNUMBER, T.UNIT, T.SUBCONTRAN, T.XGLCODE, T.XVATA, T.XVATT, T.ROLLEDFWD
    FROM TRANSACTIONS AS T
    OUTER APPLY (SELECT MIN(TS.SYSDATE) SYSDATE, TS.TRANSID FROM TRANSACTIONSSNAPSHOT TS WHERE TS.SYSDATE > @theDate AND TS.TRANSID = T.TRANSID GROUP BY TS.TRANSID) TSD
    LEFT OUTER JOIN TRANSACTIONSSNAPSHOT TS ON T.TRANSID = TS.TRANSID AND TS.SYSDATE = TSD.SYSDATE
    WHERE T.SYSDATE <= @theDate 
    AND T.OrgID = @borgId
	AND T.[Year] = cast(@year as char(10))
	AND T.Allocation = 'Contracts'
	AND T.[Contract] = @contrno
	AND T.Pdate <= @accrualDate
	AND T.LedgerCode <> @ptControl;
	
	IF(@costsOnly = 0)
	BEGIN

  insert into @t
  select actuals.PDate as [Transaction Date], actuals.Period, actuals.BatchRef, actuals.TransRef, 
	actuals.Description, '' as [GRNNO], actuals.ORDERNO as [OrderNo], actuals.UNIT as [Unit], 
	actuals.Quantity as [Qty], actuals.Rate as [RATE], 
	ROUND( CASE WHEN actuals.CURRENCY = @currency
		THEN ISNULL(DEBIT - CREDIT, 0)
	ELSE CASE 
			WHEN DEBIT - CREDIT > 0
				THEN ISNULL(actuals.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(actuals.HOMECURRAMOUNT, 0)
			END
	END, isnull(CURRENCIES.DECIMALS, 2)) AS [Amount]
	, act.ACTNUMBER as [Activity Number], act.ACTNAME as [Activity Name], lc.LEDGERCODE as [Ledger Code], lc.LEDGERNAME as [Ledger Name],
	@projNumber as [Project Number], @projName as [Project Name], actuals.Contract as [Contract Number], @contrName as [Contract Name], 
	actuals.CURRENCY as [Currency], actuals.Credno as [Credno], actuals.ALLOCATION as [Allocation], actuals.Year as [Year], actuals.TransType, lc.CONTROLTYPE, 1 as [BFWDORDER]
    from @TRANSNAPSHOTTEMP actuals 
    left outer join ACTIVITIES act on act.ActNumber = cast(actuals.Activity as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(actuals.LEDGERCODE as char(10))
    left outer join CURRENCIES on actuals.CURRENCY = CURRENCIES.CURRCODE
    where actuals.Contract = @contrno
    and ((actuals.DEBIT - actuals.CREDIT) <> 0)
    and actuals.ORGID = @borgId  
	  and actuals.YEAR = cast(@year as nvarchar(10))  
	  and actuals.PERIOD = @period  
    and actuals.Pdate <= @accrualDate
	  and actuals.ALLOCATION = 'Contracts' 
	  and actuals.LedgerCode <> @ptControl;

	insert into @t
	select NULL as [Transaction Date], NULL as [Period], '' as BatchRef, '' as TransRef, 
	'b fwd' as [Description], '' as [GRNNO], '' as [OrderNo], '' as [Unit], 
	NULL as [Qty], NULL as [RATE], 
	ROUND( SUM(CASE WHEN actuals.CURRENCY = @currency
		THEN ISNULL(DEBIT - CREDIT, 0)
	ELSE CASE 
			WHEN DEBIT - CREDIT > 0
				THEN ISNULL(actuals.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(actuals.HOMECURRAMOUNT, 0)
			END
	END), isnull(CURRENCIES.DECIMALS, 2)) AS [Amount]
	, actuals.Activity as [Activity Number], act.ACTNAME as [Activity Name], actuals.LedgerCode as [Ledger Code], lc.LEDGERNAME as [Ledger Name],
	@projNumber as [Project Number], @projName as [Project Name], actuals.Contract as [Contract Number], @contrName as [Contract Name], 
	NULL as [Currency], NULL as [Credno], NULL as [Allocation], NULL as [Year], NULL as [TransType], NULL as [CONTROLTYPE], 1 as [BFWDORDER]
    from @TRANSNAPSHOTTEMP actuals 
    left outer join ACTIVITIES act on act.ActNumber = cast(actuals.Activity as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(actuals.LEDGERCODE as char(10))
    left outer join CURRENCIES on actuals.CURRENCY = CURRENCIES.CURRCODE
    where actuals.Contract = @contrno
    and ((actuals.DEBIT - actuals.CREDIT) <> 0)
    and actuals.ORGID = @borgId  
	  and actuals.YEAR = cast(@year as nvarchar(10))  
	  and actuals.PERIOD < @period 
    and actuals.Pdate <= @accrualDate 
	  and actuals.ALLOCATION = 'Contracts' 
	  and actuals.LedgerCode <> @ptControl
	GROUP BY actuals.Contract, actuals.LedgerCode, lc.LEDGERNAME, actuals.Activity, act.ACTNAME, lc.CONTROLTYPE, CURRENCIES.DECIMALS;
	
	END
	ELSE
	BEGIN

	insert into @t
    select actuals.PDate as [Transaction Date], actuals.Period, actuals.BatchRef, actuals.TransRef, 
	actuals.Description, '' as [GRNNO], actuals.ORDERNO as [OrderNo], actuals.UNIT as [Unit], 
	actuals.Quantity as [Qty], actuals.Rate as [RATE], 
	ROUND( CASE WHEN actuals.CURRENCY = @currency
		THEN ISNULL(DEBIT - CREDIT, 0)
	ELSE CASE 
			WHEN DEBIT - CREDIT > 0
				THEN ISNULL(actuals.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(actuals.HOMECURRAMOUNT, 0)
			END
	END, isnull(CURRENCIES.DECIMALS, 2)) AS [Amount]
	, act.ACTNUMBER as [Activity Number], act.ACTNAME as [Activity Name], lc.LEDGERCODE as [Ledger Code], lc.LEDGERNAME as [Ledger Name],
	@projNumber as [Project Number], @projName as [Project Name], actuals.Contract as [Contract Number], @contrName as [Contract Name], 
	actuals.CURRENCY as [Currency], actuals.Credno as [Credno], actuals.ALLOCATION as [Allocation], actuals.Year as [Year], actuals.TransType, lc.CONTROLTYPE, 1 as [BFWDORDER]
	from @TRANSNAPSHOTTEMP actuals 
    left outer join ACTIVITIES act on act.ActNumber = cast(actuals.Activity as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(actuals.LEDGERCODE as char(10))
    left outer join CURRENCIES on actuals.CURRENCY = CURRENCIES.CURRCODE
    where actuals.Contract = @contrno
    and ((actuals.DEBIT - actuals.CREDIT) <> 0)
    and actuals.ORGID = @borgId  
	  and actuals.YEAR = cast(@year as nvarchar(10))  
	  and actuals.PERIOD = @period  
    and actuals.Pdate <= @accrualDate
	  and actuals.ALLOCATION = 'Contracts' 
	  and actuals.LedgerCode <> @ptControl
	  and actuals.LedgerCode between @ccControlF and @ccControlT;

	insert into @t
	select NULL as [Transaction Date], NULL as [Period], '' as BatchRef, '' as TransRef, 
	'b fwd' as [Description], '' as [GRNNO], '' as [OrderNo], '' as [Unit], 
	NULL as [Qty], NULL as [RATE], 
	ROUND( SUM(CASE WHEN actuals.CURRENCY = @currency
		THEN ISNULL(DEBIT - CREDIT, 0)
	ELSE CASE 
			WHEN DEBIT - CREDIT > 0
				THEN ISNULL(actuals.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(actuals.HOMECURRAMOUNT, 0)
			END
	END), isnull(CURRENCIES.DECIMALS, 2)) AS [Amount]
	, actuals.Activity as [Activity Number], act.ACTNAME as [Activity Name], actuals.LedgerCode as [Ledger Code], lc.LEDGERNAME as [Ledger Name],
	@projNumber as [Project Number], @projName as [Project Name], actuals.Contract as [Contract Number], @contrName as [Contract Name], 
	NULL as [Currency], NULL as [Credno], NULL as [Allocation], NULL as [Year], NULL as [TransType], NULL as [CONTROLTYPE], 1 as [BFWDORDER]
    from @TRANSNAPSHOTTEMP actuals 
    left outer join ACTIVITIES act on act.ActNumber = cast(actuals.Activity as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(actuals.LEDGERCODE as char(10))
    left outer join CURRENCIES on actuals.CURRENCY = CURRENCIES.CURRCODE
    where actuals.Contract = @contrno
    and ((actuals.DEBIT - actuals.CREDIT) <> 0)
    and actuals.ORGID = @borgId  
	  and actuals.YEAR = cast(@year as nvarchar(10))  
	  and actuals.PERIOD < @period 
    and actuals.Pdate <= @accrualDate 
	  and actuals.ALLOCATION = 'Contracts' 
	  and actuals.LedgerCode <> @ptControl
	  and actuals.LedgerCode between @ccControlF and @ccControlT
	GROUP BY actuals.Contract, actuals.LedgerCode, lc.LEDGERNAME, actuals.Activity, act.ACTNAME, lc.CONTROLTYPE, CURRENCIES.DECIMALS;

	END

	RETURN
END
		
		