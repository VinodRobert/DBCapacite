/****** Object:  Function [dbo].[getSnapshotLabourHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 14-07-2016
-- Description:	returns Snapshot Labour Hours
-- NOTES:
--  
-- =============================================
CREATE FUNCTION [dbo].[getSnapshotLabourHours] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,
	  [Activity Name] nvarchar(100) collate SQL_Latin1_General_CP1_CI_AS,
	  [Ledger Code] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Ledger Name] nvarchar(35) collate SQL_Latin1_General_CP1_CI_AS,
	  [Contract Number]	nvarchar(20) collate SQL_Latin1_General_CP1_CI_AS,
	  [Contract Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,		  
	  [Project Number] nvarchar(10) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Project Name] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS,	
	  [Total NT] decimal(18,4),
	  [Total OT1] decimal(18,4),
	  [Total OT2] decimal(18,4),
	  [Total OT3] decimal(18,4),
	  [Total OT4] decimal(18,4),
	  [Total OT5] decimal(18,4),
	  [Total Hours] decimal(18,4),
	  [Total Cost] decimal(18,4),
	  [CONTROLTYPE] nvarchar(50) collate SQL_Latin1_General_CP1_CI_AS
  )
AS
BEGIN

	declare @projName as nvarchar(50);
	declare @projNumber as nvarchar(10);
	declare @projId as int;
	declare @contrName as nvarchar(100);
	declare @accrualDate as datetime;
	declare @candyImportDate as datetime;
	declare @contrno as nvarchar(20);

	select @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;	

  insert into @t
  select cc.ACTNUMBER as [Activity Number], act.ACTNAME as [Activity Name], cc.LEDGERCODE as [Ledger Code], lc.LEDGERNAME as [Ledger Name],
	@contrno as [Contract Number], @contrName as [Contract Name], @projNumber as [Project Number], @projName as [Project Name], 
	SUM(
	CASE WHEN e.TYPEPAYMENT = 'Hourly' THEN cc.NT
		 WHEN e.TYPEPAYMENT = 'Salary' THEN (cc.NT / 100) * p.MAXSHIFTSHRSPAYPERIOD 
		 WHEN e.TYPEPAYMENT = 'Shift' THEN cc.NT * p.HOURSPERSHIFT
		 END
	) as [Total NT], SUM(isnull(OT1, 0)) as [Total OT1], 
	SUM(isnull(OT2, 0)) as [Total OT2], SUM(isnull(OT3, 0)) as [Total OT3], SUM(isnull(OT4, 0)) as [Total OT4], SUM(isnull(OT5, 0)) as [Total OT5], 
	SUM(
		(CASE 
			WHEN e.TYPEPAYMENT = 'Hourly' THEN cc.NT
			WHEN e.TYPEPAYMENT = 'Salary' THEN (cc.NT / 100) * p.MAXSHIFTSHRSPAYPERIOD 
			WHEN e.TYPEPAYMENT = 'Shift' THEN cc.NT * p.HOURSPERSHIFT
		 END)
		 + isnull(OT1, 0)
		 + isnull(OT2, 0)
		 + isnull(OT3, 0)
		 + isnull(OT4, 0)
		 + isnull(OT5, 0)
	) as [Total Hours], SUM(isnull(cc.COST, 0)) as [Total Cost], lc.CONTROLTYPE
	from CLOCKCARDS cc
	INNER JOIN PAYROLLS p ON cc.PAYROLLID = p.PAYROLLID
	INNER JOIN EMPLOYEES e ON e.PAYROLLID = p.PAYROLLID AND e.EMPNUMBER collate SQL_Latin1_General_CP1_CI_AS = cc.EMPNUMBER collate SQL_Latin1_General_CP1_CI_AS
	left outer join ACTIVITIES act on act.ActNumber = cast(cc.ACTNUMBER as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(cc.LEDGERCODE as char(10))
	where cc.ALLOCATION = 'Contracts' and cc.CONTRNUMBER = @contrno
	group by cc.LEDGERCODE, lc.LEDGERNAME, cc.ACTNUMBER, act.ACTNAME, lc.CONTROLTYPE

	RETURN
END
		
		