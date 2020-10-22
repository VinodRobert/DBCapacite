/****** Object:  Function [dbo].[getSnapshotBudgets]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-06-2016
-- Description:	returns Snapshot Budgets
-- NOTES:
--  
-- =============================================
create FUNCTION [dbo].[getSnapshotBudgets] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),	
	  [Ledger Code] nvarchar(10),	
	  [Ledger Name] nvarchar(35),	
	  [Project Number] nvarchar(10),	
	  [Project Name] nvarchar(50),	
	  [Contract Number]	nvarchar(20),
	  [Contract Name] nvarchar(50),	
	  [Year] int,
	  [Period] int,
	  [Budget] money,
	  [Qty] numeric(23,4),
	  [Final Estimate] money,	
	  [Qty Final Estimate] numeric(23,4),
	  [Billed] money,
	  [Qty Billed] numeric(23,4),
	  [Total Progressive] money,	
	  [Qty Total Progressive] numeric(23,4),	
	  [CONTROLTYPE] nvarchar(50)
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
	declare @currency nvarchar(3);
	declare @borgId int;
	declare @createdDate datetime;
	declare @year char(10);
	declare @period int;
	declare @costsOnly bit;
	
	select @createdDate = CreatedDate, @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID, @year = [Year], @period = Period, @costsOnly = CostsOnly from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;
	select @currency = CURRENCY from BORGS where BORGID = @borgId;

	insert into @t
	select candyresources.ACTNUMBER as [Activity Number], act.ACTNAME as [Activity Name],
	candyresources.LEDGERCODE as [Ledger Code], lc.LEDGERNAME as [Ledger Name], 
	contr.CONTRNUMBER as [Contract Number], @contrName as [Contract Name], 
	@projNumber as PROJNUMBER,  @projName as PROJNAME, @year as YearNo, @period as Period, 
	(ISNULL(candyresources.QTY, 0) * ISNULL(candyresources.RATE, 0)) as [Budget],
	ISNULL(candyresources.QTY, 0) as [Qty], 
    (ISNULL(candyresources.FINALUSAGE, 0) * ISNULL(candyresources.RATE, 0)) as [Final Estimate],
    ISNULL(candyresources.FINALUSAGE, 0) as [Qty Final Estimate],
    (ISNULL(candyresources.BILLUSAGE, 0) * ISNULL(candyresources.RATE, 0)) as [Billed],
    ISNULL(candyresources.BILLUSAGE, 0) as [Qty Billed],
    (ISNULL(candyresources.ACTUALUSAGE, 0) * ISNULL(candyresources.RATE, 0)) as [Total Progressive],
    ISNULL(candyresources.ACTUALUSAGE, 0) as [Qty Total Progressive], lc.CONTROLTYPE
    from CANDY_RESOURCES candyresources
    left outer join ACTIVITIES act on act.ActNumber = cast(candyresources.ACTNUMBER as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(candyresources.LEDGERCODE as char(10))
    left outer join CONTRACTS contr on contr.CONTRID = candyresources.CONTRACT
    where candyresources.SYSDATE = @candyImportDate
    and contr.CONTRNUMBER = @contrno;	

	RETURN
END
		
		