/****** Object:  Function [dbo].[getSnapshotAdjustments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-06-2016
-- Description:	returns Snapshot Adjustments
-- NOTES:
--  
-- =============================================
create FUNCTION [dbo].[getSnapshotAdjustments] (@snapshotId int)
    RETURNS @t TABLE (
		[Type] nvarchar(20),
		[Realloc Activity Number] nvarchar(10),
		[Realloc Ledger Code] nvarchar(10),	
		[Description] nvarchar(255),
		[Resource Code] nvarchar(50),
		[Unit] nvarchar(15),	
		[Qty] decimal(23,4),		
		[Rate] decimal(23,4),		
		[Amount] decimal(23,4),
		[Realloc Activity Name] nvarchar(100),
		[Realloc Ledger Name]	nvarchar(35),
		[Activity Number]	nvarchar(10),
		[Activity Name] nvarchar(100),	
		[Ledger Code] nvarchar(10),	
		[Ledger Name] nvarchar(35),	
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
	select adjDetail.AdjustmentType as [Type], 
    case when adjDetail.AdjustmentType = 'Reallocation' 
	    then adj.ActNumber
    else
	    ''
    end as [Realloc Activity Number],
	case when adjDetail.AdjustmentType = 'Reallocation'
	    then adj.LedgerCode
    else
	    ''
    end as [Realloc Ledger Code],
	adjDetail.AdjustmentDesc as [Description],
    adjDetail.ResourceCode as [Resource Code],
	adjDetail.Unit as [Unit],
    adjDetail.Quantity as [Qty],
    adjDetail.Rate as [Rate],
    adjDetail.Amount as [Amount],
    case when adjDetail.AdjustmentType = 'Reallocation'
	    then actadj.ActName
    else
	    ''
    end as [Realloc Activity Name],
    
    case when adjDetail.AdjustmentType = 'Reallocation'
	    then lcadj.LedgerName
    else
	    ''
    end as [Realloc Ledger Name],    
    adjDetail.ActNumber as [Activity Number],
    act.ActName as [Activity Name],
    adjDetail.LedgerCode as [Ledger Code],
    lc.LedgerName as [Ledger Name],
    lc.CONTROLTYPE
        from SNAPSHOTADJUSTMENTDETAILS adjDetail
    inner join SNAPSHOTADJUSTMENTS adj on adj.ID = adjDetail.SnapshotAdjustmentID
    left outer join ACTIVITIES act on act.ActNumber = cast(adjDetail.ActNumber as char(10))
    left outer join LEDGERCODES lc on lc.LedgerCode = cast(adjDetail.LedgerCode as char(10))
    left outer join ACTIVITIES actadj on actadj.ActNumber = cast(adj.ActNumber as char(10))
    left outer join LEDGERCODES lcadj on lcadj.LedgerCode = cast(adj.LedgerCode as char(10))
    where adjDetail.SnapshotsID = @snapshotId 
	and adjDetail.IsDeleted = 0 
	--order by adjDetail.ActNumber, adjDetail.LedgerCode;

	RETURN
END
		
		