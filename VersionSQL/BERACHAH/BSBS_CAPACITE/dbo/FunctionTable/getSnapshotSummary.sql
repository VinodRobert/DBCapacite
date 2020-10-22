/****** Object:  Function [dbo].[getSnapshotSummary]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-09-2016
-- Description:	returns Snapshot Summary
-- NOTES:
-- 14-08-2020 RiaanE - Performance improvements 
-- =============================================
CREATE FUNCTION [dbo].[getSnapshotSummary] (@snapshotId int)
    RETURNS @t TABLE (
		[Activity Number]	nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		[Activity Name] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,	
		[Ledger Code] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
		[Ledger Name] nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,		
		[Actual] decimal(23,4),	
		[Accrual] decimal(23,4),	
		[Adj Reallocation] decimal(23,4),	
		[Adj Accruals] decimal(23,4),	
		[Adj SC Liability] decimal(23,4),	
		[Adj Materials] decimal(23,4),	
		[Adj Contras] decimal(23,4),	
		[Adj Residual] decimal(23,4),	
		[Adj Others] decimal(23,4),	
		[Total Adjustments] decimal(23,4),	
		[Total Cost] decimal(23,4),
		[Actual Allowable] decimal(23,4),	
		[Variance] decimal(23,4),	
		[To Completion Allowable] decimal(23,4),	
		[Final Allowable] decimal(23,4),	
		[Billed Allowable] decimal(23,4),	
		[CONTROLTYPE] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
		[Actual Qty] decimal(23,4),
		[Final Qty] decimal(23,4),
		[Billed Qty] decimal(23,4),
    FILEUPLOADDATE datetime
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
	declare @createdDate datetime;
	declare @year char(10);
	declare @period int;
	declare @costsOnly bit;
  declare @fileUploadDate datetime;
	declare @tmpAccruals table
	(
		LEDGERCODE nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		LEDGERNAME nvarchar(80) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNUMBER nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNAME nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,
		ACCRUALTOTAL money,
		ACTUALTOTAL money,
		TOTCOST money
	);
	declare @tmpAccrualsRollup table
	(
		LEDGERCODE nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		LEDGERNAME nvarchar(80) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNUMBER nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNAME nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,
		ACCRUALTOTAL money,
		ACTUALTOTAL money,
		TOTCOST money
	);
	declare @tmpAccruals_nobudgets table
	(
		LEDGERCODE nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		LEDGERNAME nvarchar(80) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNUMBER nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNAME nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,
		CONTROLTYPE nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
		ACCRUALTOTAL money,
		ACTUALTOTAL money,
		TOTCOST money,
		TOTREALLOCATION money, 
		TOTACCRUALS money, 
		TOTSCLIABILITY money, 
		TOTMATERIALS money, 
		TOTCONTRAS money, 
		TOTRESIDUAL money, 
		TOTOTHERS money,
		TOTALADJUSTMENTS money
	);
	declare @tmpBudgetsFromRes table
	(
		YearNo int,
		Period int,		
		LEDGERCODE nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		LEDGERNAME nvarchar(80) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNUMBER nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNAME nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,
		CONTROLTYPE nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
		BUDGETFE decimal(23,4),
		QTYFE decimal(23,4),
		BUDGETBILLED decimal(23,4),
		QTYBILLED decimal(23,4),
		BUDGETTP decimal(23,4),
		QTYTP decimal(23,4),
		Budget decimal(23,4),
		QTY decimal(23,4),		
		PROJNUMBER nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		PROJNAME nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
		CONTRNUMBER nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,
		CONTRNAME nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS
	);
	declare @tmpBudgets table
	(		
		LEDGERCODE nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		LEDGERNAME nvarchar(80) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNUMBER nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
		ACTNAME nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,
		CONTROLTYPE nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,
		BUDGETFE decimal(23,4),
		QTYFE decimal(23,4),
		BUDGETBILLED decimal(23,4),
		QTYBILLED decimal(23,4),
		BUDGETTP decimal(23,4),
		QTYTP decimal(23,4)
	);
	
  select @fileUploadDate = FILEUPLOADDATE from SNAPSHOTS where ID = @snapshotId;
  
	select @createdDate = CreatedDate, @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID, @year = [Year], @period = Period, @costsOnly = CostsOnly from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
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
	[VATType] [char](2) NOT NULL,
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
	[XVATT] [char](2) NOT NULL,
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
    OUTER APPLY (SELECT MIN(TS.SYSDATE) SYSDATE, TS.TRANSID FROM TRANSACTIONSSNAPSHOT TS WHERE TS.SYSDATE > @createdDate AND TS.TRANSID = T.TRANSID GROUP BY TS.TRANSID) TSD
    LEFT OUTER JOIN TRANSACTIONSSNAPSHOT TS ON T.TRANSID = TS.TRANSID AND TS.SYSDATE = TSD.SYSDATE
    WHERE T.SYSDATE <= @createdDate 
    AND T.OrgID = @borgId
	AND T.[Year] = cast(@year as char(10))
	AND T.Allocation = 'Contracts'
	AND T.[Contract] = @contrno
	AND T.Pdate <= @accrualDate
	AND T.LedgerCode <> @ptControl;

	insert into @tmpAccruals (LEDGERCODE, LEDGERNAME, ACTNUMBER, ACTNAME, ACCRUALTOTAL, ACTUALTOTAL, TOTCOST)
	select LEDGERCODE, LEDGERNAME, ACTNUMBER, ACTNAME, 
    SUM( CASE WHEN ACCRUALSSNAPSHOT.CURRENCY = @currency
		    THEN ISNULL(DEBIT - CREDIT, 0)
	    ELSE CASE 
			    WHEN DEBIT - CREDIT > 0
				    THEN ISNULL(ACCRUALSSNAPSHOT.HOMECURRAMOUNT, 0)
			    ELSE - 1 * ISNULL(ACCRUALSSNAPSHOT.HOMECURRAMOUNT, 0)
			    END
	    END) AS ACCRUALTOTAL, CONVERT(money, 0) as ACTUALTOTAL, CONVERT(money, 0) as TOTCOST from ACCRUALSSNAPSHOT where SNAPSHOTSID = @snapshotId
    group by LEDGERNAME, LEDGERCODE, ACTNUMBER, ACTNAME
    order by LEDGERCODE, ACTNUMBER;

    insert into @tmpAccruals (LEDGERCODE, LEDGERNAME, ACTNUMBER, ACTNAME, ACCRUALTOTAL, ACTUALTOTAL, TOTCOST)
    select actuals.LEDGERCODE, lc.LEDGERNAME, actuals.Activity as ACTNUMBER, act.ACTNAME, 0 as ACCRUALTOTAL,
    SUM( CASE WHEN actuals.CURRENCY = @currency
		THEN ISNULL(DEBIT - CREDIT, 0)
	ELSE CASE 
			WHEN DEBIT - CREDIT > 0
				THEN ISNULL(actuals.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(actuals.HOMECURRAMOUNT, 0)
			END
	END) AS ACTUALTOTAL, 0 as TOTCOST FROM @TRANSNAPSHOTTEMP actuals
    inner join SNAPSHOTS on SNAPSHOTS.ID = @snapshotId
    left outer join ACTIVITIES act on act.ActNumber = actuals.Activity
    left outer join LEDGERCODES lc on lc.LedgerCode = actuals.LEDGERCODE
	where actuals.[Contract] = SNAPSHOTS.ContractNo
    and actuals.ORGID = @borgId  
	  and actuals.YEAR = cast(@year as nvarchar(10))  
	  and actuals.PERIOD = @period 
    and actuals.Pdate <= @accrualDate
    and actuals.ALLOCATION = 'Contracts'
    and actuals.LedgerCode <> @ptControl
	  and(@costsOnly = 1 and actuals.LedgerCode between @ccControlF and @ccControlT)
	group by actuals.LEDGERCODE, lc.LEDGERNAME, actuals.Activity, act.ACTNAME
  order by actuals.LEDGERCODE, actuals.Activity;



	/* Get B fwd balances */
    insert into @tmpAccruals (LEDGERCODE, LEDGERNAME, ACTNUMBER, ACTNAME, ACCRUALTOTAL, ACTUALTOTAL, TOTCOST)
    select actuals.LEDGERCODE, lc.LEDGERNAME, actuals.Activity as ACTNUMBER, act.ACTNAME, 0 as ACCRUALTOTAL,
    SUM( CASE WHEN actuals.CURRENCY = @currency
		THEN ISNULL(DEBIT - CREDIT, 0)
	ELSE CASE 
			WHEN DEBIT - CREDIT > 0
				THEN ISNULL(actuals.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(actuals.HOMECURRAMOUNT, 0)
			END
	END) AS ACTUALTOTAL, 0 as TOTCOST FROM @TRANSNAPSHOTTEMP actuals 
    left outer join ACTIVITIES act on act.ActNumber = actuals.Activity
    left outer join LEDGERCODES lc on lc.LedgerCode = actuals.LEDGERCODE
    where actuals.Contract = @contrno
    and ((actuals.DEBIT - actuals.CREDIT) <> 0/* or actuals.QUANTITY <> 0*/)
    and actuals.ORGID = @borgId  
	  and actuals.YEAR = cast(@year as nvarchar(10))  
	  and actuals.PERIOD < @period  
    and actuals.Pdate <= @accrualDate 
	  and actuals.ALLOCATION = 'Contracts' 
	  and actuals.LedgerCode <> @ptControl
	  and(@costsOnly = 1 and actuals.LedgerCode between @ccControlF and @ccControlT)
	group by actuals.LEDGERCODE, lc.LEDGERNAME, actuals.Activity, act.ACTNAME
  order by actuals.LEDGERCODE, actuals.Activity;

	insert into @tmpAccrualsRollup (LEDGERCODE, LEDGERNAME, ACTNUMBER, ACTNAME, ACCRUALTOTAL, ACTUALTOTAL, TOTCOST)
	select Ledgercode, LedgerName, ACTNUMBER, ACTNAME, SUM(ACCRUALTOTAL) as ACCRUALTOTAL, SUM(ACTUALTOTAL) as ACTUALTOTAL, SUM(TOTCOST) as TOTCOST from @tmpAccruals
	group by Ledgercode, LedgerName, ACTNUMBER, ACTNAME;

  select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;

	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;
	
	insert into @t
	select RTRIM(LTRIM(ISNULL(tmp.ACTNUMBER, tmpBudget.ACTNUMBER))) as [Activity Number], 
	RTRIM(LTRIM(ISNULL(act.ACTNAME, tmpBudget.ACTNAME))) as [Activity Name],  
	ISNULL(tmp.LEDGERCODE, tmpBudget.LEDGERCODE) as [Ledger Code], 
	ISNULL(lc.LEDGERNAME, tmpBudget.LEDGERNAME) as [Ledger Name], 	
	ISNULL(tmp.ACTUALTOTAL, 0) AS [Actual], 
	ISNULL(tmp.ACCRUALTOTAL, 0) AS [Accrual], 
  ISNULL(tmp.TOTREALLOCATION, 0) as [Adj Reallocation], 
	ISNULL(tmp.TOTACCRUALS, 0) as [Adj Accruals], 
	ISNULL(tmp.TOTSCLIABILITY, 0) as [Adj SC Liability], 
	ISNULL(tmp.TOTMATERIALS, 0) as [Adj Materials], 
	ISNULL(tmp.TOTCONTRAS, 0) as [Adj Contras], 
	ISNULL(tmp.TOTRESIDUAL, 0) as [Adj Residual], 
	ISNULL(tmp.TOTOTHERS, 0) as [Adj Others],
	ISNULL(tmp.TOTALADJUSTMENTS, 0) AS [Total Adjustments],
	ISNULL(tmp.TOTCOST, 0) AS [Total Cost], 
	ISNULL(tmpBudget.BUDGETTP, 0) as [Actual Allowable], 
	ISNULL(tmpBudget.BUDGETTP, 0) - (
		ISNULL(tmp.ACCRUALTOTAL, 0) + ISNULL(tmp.ACTUALTOTAL, 0) + ISNULL(tmp.TOTREALLOCATION, 0) + ISNULL(tmp.TOTACCRUALS, 0) + ISNULL(tmp.TOTSCLIABILITY, 0) + ISNULL(tmp.TOTMATERIALS, 0) + ISNULL(tmp.TOTCONTRAS, 0) + ISNULL(tmp.TOTRESIDUAL, 0) + ISNULL(tmp.TOTOTHERS, 0)
    ) AS [Variance],
	(ISNULL(tmpBudget.BUDGETFE, 0) - ISNULL(tmpBudget.BUDGETTP, 0)) as [To Completion Allowable], /*BUDGETFE1*/
    ISNULL(tmpBudget.BUDGETFE, 0) as [Final Allowable], 
    ISNULL(tmpBudget.BUDGETBILLED, 0) as [Billed Allowable],   
	ISNULL(lc.CONTROLTYPE, tmpBudget.CONTROLTYPE) as CONTROLTYPE,
	ISNULL(tmpBudget.QTYTP, 0) as [Actual Qty],
	ISNULL(tmpBudget.QTYFE, 0) as [Final Qty],
	ISNULL(tmpBudget.QTYBILLED, 0) as [Billed Qty], @fileUploadDate as FILEUPLOADDATE
    from (
		select ISNULL(tmp.ACTNUMBER, tmpSadj.ACTNUMBER) ACTNUMBER, 
		act.ACTNAME, 
		ISNULL(tmp.LEDGERCODE, tmpSadj.LEDGERCODE) LEDGERCODE, 
		lc.LEDGERNAME, 
		SUM(ISNULL(tmp.ACTUALTOTAL, 0)) AS ACTUALTOTAL, 
		SUM(ISNULL(tmp.ACCRUALTOTAL, 0)) AS ACCRUALTOTAL, 
		SUM(ISNULL(tmpSadj.TotalReallocation, 0)) as TOTREALLOCATION, 
		SUM(ISNULL(tmpSadj.TotalAccruals, 0)) as TOTACCRUALS, 
		SUM(ISNULL(tmpSadj.TotalSCLiability, 0)) as TOTSCLIABILITY, 
		SUM(ISNULL(tmpSadj.TotalMaterials, 0)) as TOTMATERIALS, 
		SUM(ISNULL(tmpSadj.TotalContras, 0)) as TOTCONTRAS, 
		SUM(ISNULL(tmpSadj.TotalResidual, 0)) as TOTRESIDUAL, 
		SUM(ISNULL(tmpSadj.TotalOthers, 0)) as TOTOTHERS,
		SUM(
        ISNULL(tmpSadj.TotalReallocation, 0) + ISNULL(tmpSadj.TotalAccruals, 0) + ISNULL(tmpSadj.TotalSCLiability, 0) + ISNULL(tmpSadj.TotalMaterials, 0) + ISNULL(tmpSadj.TotalContras, 0) + ISNULL(tmpSadj.TotalResidual, 0) + ISNULL(tmpSadj.TotalOthers, 0)
    ) AS TOTALADJUSTMENTS,
		
    SUM(
        ISNULL(tmp.ACCRUALTOTAL, 0) + ISNULL(tmp.ACTUALTOTAL, 0) + ISNULL(tmpSadj.TotalReallocation, 0) + ISNULL(tmpSadj.TotalAccruals, 0) + ISNULL(tmpSadj.TotalSCLiability, 0) + ISNULL(tmpSadj.TotalMaterials, 0) + ISNULL(tmpSadj.TotalContras, 0) + ISNULL(tmpSadj.TotalResidual, 0) + ISNULL(tmpSadj.TotalOthers, 0)
    ) AS TOTCOST,
	ISNULL(lc.CONTROLTYPE, '') as CONTROLTYPE 
    from @tmpAccrualsRollup tmp 
    inner join ACTIVITIES act on ltrim(rtrim(act.ActNumber)) = ltrim(rtrim(tmp.ACTNUMBER))
    inner join LEDGERCODES lc on ltrim(rtrim(lc.LedgerCode)) = ltrim(rtrim(tmp.LEDGERCODE))
	left outer join (
		select * from SNAPSHOTADJUSTMENTS where SnapshotsID = @snapshotId
	) tmpSadj on ltrim(rtrim(tmp.LEDGERCODE)) = ltrim(rtrim(tmpSadj.LEDGERCODE)) and ltrim(rtrim(tmp.ACTNUMBER)) = ltrim(rtrim(tmpSadj.ACTNUMBER))
	group by ISNULL(tmp.LEDGERCODE, tmpSadj.LEDGERCODE), lc.LEDGERNAME, ISNULL(tmp.ACTNUMBER, tmpSadj.ACTNUMBER), act.ACTNAME, lc.CONTROLTYPE
	union
	select ISNULL(tmp.ACTNUMBER, tmpSadj.ACTNUMBER) as ACTNUMBER, 
	act.ACTNAME, 
	ISNULL(tmp.LEDGERCODE, tmpSadj.LEDGERCODE) as LEDGERCODE, 
	lc.LEDGERNAME, 
	SUM(ISNULL(tmp.ACTUALTOTAL, 0)) AS ACTUALTOTAL,
	SUM(ISNULL(tmp.ACCRUALTOTAL, 0)) AS ACCRUALTOTAL,
	SUM(ISNULL(tmpSadj.TotalReallocation, 0)) as TOTREALLOCATION, 
	SUM(ISNULL(tmpSadj.TotalAccruals, 0)) as TOTACCRUALS, 
	SUM(ISNULL(tmpSadj.TotalSCLiability, 0)) as TOTSCLIABILITY, 
	SUM(ISNULL(tmpSadj.TotalMaterials, 0)) as TOTMATERIALS, 
	SUM(ISNULL(tmpSadj.TotalContras, 0)) as TOTCONTRAS, 
	SUM(ISNULL(tmpSadj.TotalResidual, 0)) as TOTRESIDUAL, 
	SUM(ISNULL(tmpSadj.TotalOthers, 0)) as TOTOTHERS,
	SUM(
        ISNULL(tmpSadj.TotalReallocation, 0) + ISNULL(tmpSadj.TotalAccruals, 0) + ISNULL(tmpSadj.TotalSCLiability, 0) + ISNULL(tmpSadj.TotalMaterials, 0) + ISNULL(tmpSadj.TotalContras, 0) + ISNULL(tmpSadj.TotalResidual, 0) + ISNULL(tmpSadj.TotalOthers, 0)
    ) AS TOTALADJUSTMENTS,
	SUM(
        ISNULL(tmp.ACCRUALTOTAL, 0) + ISNULL(tmp.ACTUALTOTAL, 0) + ISNULL(tmpSadj.TotalReallocation, 0) + ISNULL(tmpSadj.TotalAccruals, 0) + ISNULL(tmpSadj.TotalSCLiability, 0) + ISNULL(tmpSadj.TotalMaterials, 0) + ISNULL(tmpSadj.TotalContras, 0) + ISNULL(tmpSadj.TotalResidual, 0) + ISNULL(tmpSadj.TotalOthers, 0)
    ) AS TOTCOST, 
	ISNULL(lc.CONTROLTYPE, '') as CONTROLTYPE    
    from  (
		select * from SNAPSHOTADJUSTMENTS where SnapshotsID = @snapshotId
	) tmpSadj
	left outer join @tmpAccrualsRollup tmp on ltrim(rtrim(tmp.LEDGERCODE)) = ltrim(rtrim(tmpSadj.LEDGERCODE)) and ltrim(rtrim(tmp.ACTNUMBER)) = ltrim(rtrim(tmpSadj.ACTNUMBER))
	left outer join ACTIVITIES act on act.ActNumber = cast(tmp.ACTNUMBER as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(tmp.LEDGERCODE as char(10))
	where tmp.LEDGERCODE IS NULL
    /*outer apply (select * from SNAPSHOTADJUSTMENTS sadj where ltrim(rtrim(tmp.LEDGERCODE)) = ltrim(rtrim(sadj.LEDGERCODE)) and ltrim(rtrim(tmp.ACTNUMBER)) = ltrim(rtrim(sadj.ACTNUMBER)) and sadj.SnapshotsID = @snapshotId) tmpSadj*/
	group by ISNULL(tmp.LEDGERCODE, tmpSadj.LEDGERCODE), lc.LEDGERNAME, ISNULL(tmp.ACTNUMBER, tmpSadj.ACTNUMBER), act.ACTNAME, lc.CONTROLTYPE
	) tmp 
    inner join ACTIVITIES act on act.ActNumber = cast(tmp.ACTNUMBER as char(10))
    inner join LEDGERCODES lc on lc.LedgerCode = cast(tmp.LEDGERCODE as char(10))
    full outer join (
		select budgets.LEDGERCODE as LEDGERCODE, budgets.LEDGERNAME, budgets.ACTNUMBER as ACTNUMBER, budgets.ACTNAME, budgets.CONTROLTYPE, 
	SUM(ISNULL(budgets.BUDGETFE, 0)) as BUDGETFE, 
	SUM(ISNULL(budgets.QTYFE, 0)) as QTYFE, 
	SUM(ISNULL(budgets.BUDGETBILLED, 0)) as BUDGETBILLED, 
	SUM(ISNULL(budgets.QTYBILLED, 0)) as QTYBILLED, 
	SUM(ISNULL(budgets.BUDGETTP, 0)) as BUDGETTP, 
	SUM(ISNULL(budgets.QTYTP, 0)) as QTYTP
	from (
		select @year as YearNo, @period as Period, candyresources.LEDGERCODE, lc.LEDGERNAME, 
	candyresources.ACTNUMBER, act.ACTNAME, lc.CONTROLTYPE, 
    (ISNULL(candyresources.FINALUSAGE, 0) * ISNULL(candyresources.RATE, 0)) as BUDGETFE,
    ISNULL(candyresources.FINALUSAGE, 0) as QTYFE,
    (ISNULL(candyresources.BILLUSAGE, 0) * ISNULL(candyresources.RATE, 0)) as BUDGETBILLED,
    ISNULL(candyresources.BILLUSAGE, 0) as QTYBILLED,
    (ISNULL(candyresources.ACTUALUSAGE, 0) * ISNULL(candyresources.RATE, 0)) as BUDGETTP,
    ISNULL(candyresources.ACTUALUSAGE, 0) as QTYTP,
    (ISNULL(candyresources.QTY, 0) * ISNULL(candyresources.RATE, 0)) as Budget,
    ISNULL(candyresources.QTY, 0) as QTY, @projNumber as PROJNUMBER, @projName as PROJNAME, contr.CONTRNUMBER, @contrName as CONTRNAME
    from CANDY_RESOURCES candyresources
    left outer join ACTIVITIES act on act.ActNumber = cast(candyresources.ACTNUMBER as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(candyresources.LEDGERCODE as char(10))
    inner join CONTRACTS contr on contr.CONTRID = candyresources.CONTRACT
    where candyresources.SYSDATE = @candyImportDate
    and contr.CONTRNUMBER = @contrno
	) budgets
		group by budgets.LEDGERCODE, budgets.LEDGERNAME, budgets.CONTROLTYPE, budgets.ACTNUMBER, budgets.ACTNAME
	) tmpBudget
    on ltrim(rtrim(tmp.LEDGERCODE)) = ltrim(rtrim(tmpBudget.LEDGERCODE)) and ltrim(rtrim(tmp.ACTNUMBER)) = ltrim(rtrim(tmpBudget.ACTNUMBER)) 

	RETURN
END
		
		