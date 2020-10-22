/****** Object:  Function [dbo].[getSnapshotAccruals]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-06-2016
-- Description:	returns Snapshot Accruals
-- NOTES:
--  
-- =============================================
create FUNCTION [dbo].[getSnapshotAccruals] (@snapshotId int)
    RETURNS @t TABLE (
	  [Transaction Date] datetime,	
	  [Source] nvarchar(255),	
	  [BatchRef] nvarchar(10),	
	  [TransRef] nvarchar(10),	
	  [Description]	nvarchar(255),
	  [GRNNO] nvarchar(12),
	  [OrderNo] nvarchar(55),	
	  [Unit] nvarchar(25),	
	  [Qty] numeric(23,4),	
	  [RATE] numeric(23,4),	
	  [Amount] money,	
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),	
	  [Ledger Code] nvarchar(10),	
	  [Ledger Name] nvarchar(35),	
	  [Project Number] nvarchar(10),	
	  [Project Name] nvarchar(50),	
	  [Contract Number]	nvarchar(20),
	  [Contract Name] nvarchar(50),	
	  [Currency] nvarchar(3),	
	  [Credno] nvarchar(10),	
	  [Creditor Name] nvarchar(127),	
	  [Debtor Name] nvarchar(127),	
	  [Subcontractor Name] nvarchar(127),	
	  [Year] nvarchar(10),	
	  [Period] int,	
	  [Allocation] nvarchar(50),	
	  [DELNO] nvarchar(55),	
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

	select @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;
	select @currency = CURRENCY from BORGS where BORGID = @borgId;	

    insert into @t
    select accrualSs.PDATE, accrualSs.ACCRUAL, accrualSs.BATCHREF, accrualSs.TRANSREF, 
	accrualSs.DESCRIPTION, accrualSs.GRNNO, accrualSs.ORDERNO, accrualSs.UNIT, 
	accrualSs.QUANTITY, accrualSs.RATE, 
	(
	CASE WHEN accrualSs.CURRENCY = @currency
		THEN ISNULL(accrualSs.DEBIT - accrualSs.CREDIT, 0)
	ELSE 
		CASE WHEN accrualSs.DEBIT - accrualSs.CREDIT > 0
			THEN ISNULL(accrualSs.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(accrualSs.HOMECURRAMOUNT, 0)
			END
	END
	) AS [Amount],
	accrualSs.ACTNUMBER, accrualSs.ACTNAME, lc.LEDGERCODE, lc.LEDGERNAME, 
	accrualSs.PROJNUMBER, accrualSs.PROJNAME, accrualSs.CONTRACT, accrualSs.CONTRNAME, 
    accrualSs.CURRENCY, accrualSs.CREDNO, accrualSs.CREDREC, accrualSs.DEBTREC, 
	accrualSs.SUBBREC, accrualSs.YEAR, accrualSs.PERIOD, accrualSs.ALLOCATION, 
	accrualSs.DELNO, lc.CONTROLTYPE
     from ACCRUALSSNAPSHOT accrualSs
    left outer join LEDGERCODES lc on lc.LedgerCode = accrualSs.LEDGERCODE
    where SNAPSHOTSID = @snapshotId
	and(
	CASE WHEN accrualSs.CURRENCY = @currency
		THEN ISNULL(accrualSs.DEBIT - accrualSs.CREDIT, 0)
	ELSE 
		CASE WHEN accrualSs.DEBIT - accrualSs.CREDIT > 0
			THEN ISNULL(accrualSs.HOMECURRAMOUNT, 0)
			ELSE - 1 * ISNULL(accrualSs.HOMECURRAMOUNT, 0)
			END
	END
	) <> 0
	order by accrualSs.ACTNUMBER, accrualSs.LEDGERCODE;

	RETURN
END
		
		