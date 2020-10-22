/****** Object:  Function [dbo].[getSnapshotSubbyOutstandingCommitments]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 05-11-2019
-- Description:	returns Snapshot Subby Outstanding Commitments
-- NOTES:
--  23-06-2020 RiaanE - Added RevBudget
-- =============================================
CREATE FUNCTION [dbo].[getSnapshotSubbyOutstandingCommitments] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),
	  [Ledger Code] nvarchar(10),	
	  [Ledger Name] nvarchar(35),
	  [Contract Number]	nvarchar(20),
	  [Contract Name] nvarchar(50),		  
	  [Project Number] nvarchar(10),	
	  [Project Name] nvarchar(50),	
	  [SUPPCODE] nvarchar(10),
	  [SupName] nvarchar(127),
	  [Certno] numeric(18,0),
	  [ContValue] decimal(18,4),
	  [OrderValue] decimal(18,4),
	  [WorkDoneTot] decimal(18,4),
	  [EscalationTot] decimal(18,4),
	  [MOSTot] decimal(18,4),
	  [AdditionalTot] decimal(18,4),
	  [VATTot] decimal(18,4),
	  [DiscountTot] decimal(18,4),
	  [AdvanceTot] decimal(18,4),
	  [RetentionTot] decimal(18,4),
	  [ContraTot] decimal(18,4),
	  [AmountDue] decimal(18,4),
	  [TotDue] decimal(18,4),
	  [Paid] decimal(18,4),
	  [Orderno] nvarchar(55),
	  [Posted] bit,
	  [CONTROLTYPE] nvarchar(55),
    [Revised Budget] decimal(18,4)
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
	declare @borgId int;
	declare @contrid int;

	select @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo, @borgId = OrgID from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME, @contrid = CONTRID from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;	

    insert into @t
    select act.ACTNUMBER as [Activity Number], act.ACTNAME as [Activity Name], lc.LEDGERCODE as [Ledger Code], lc.LEDGERNAME as [Ledger Name],
		@contrno as [Contract Number], @contrName as [Contract Name], @projNumber as [Project Number], @projName as [Project Name], 
		SUPPLIERS.SUPPCODE, SupName, Certno, ContValue, ISNULL(SUBCORDERS.AMOUNT, 0) as [OrderValue], WorkDoneTot, EscalationTot, MOSTot, AdditionalTot, VATTot, DiscountTot, AdvanceTot, 
		RetentionTot, ContraTot, AmountDue, TotDue, Paid, Orderno, Posted, lc.CONTROLTYPE, SUBCRECONS.RevBudget 
		from SUBCRECONS 
    left outer join (
			SELECT ORD.ORDNUMBER, ORD.SUPPID
			,sum((OI.QTY * OI.PRICE * (1 - (OI.DISCOUNT / 100))) + (OI.VATAMOUNT)) AS AMOUNT
			FROM ORDITEMS OI
			INNER JOIN ORD ON ORD.ORDID = OI.ORDID
			WHERE (
					(
						ORD.RECTYPE = 'SC'
						AND ORD.BORGID = @borgId
						AND ORD.ORDSTATUSID = 41
						)
					)
			GROUP BY ORD.ORDNUMBER, ORD.SUPPID
		) SUBCORDERS on SUBCORDERS.ORDNUMBER = SUBCRECONS.Orderno
		left outer join SUPPLIERS ON SUBCORDERS.SUPPID = SUPPLIERS.SUPPID
		left outer join ACTIVITIES act on act.ActID = cast(SUBCRECONS.Activity as int)
		left outer join LEDGERCODES lc on lc.LedgerCode = SUBCRECONS.Ledger
		where [Contract] = @contrid
    and LPOSTED = 0;
	
	RETURN
END
		
		