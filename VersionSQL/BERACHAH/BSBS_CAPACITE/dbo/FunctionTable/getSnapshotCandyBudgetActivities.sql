/****** Object:  Function [dbo].[getSnapshotCandyBudgetActivities]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 24-01-2017
-- Description:	returns Snapshot Candy Budget Activities
-- NOTES:
--  
-- =============================================
create FUNCTION [dbo].[getSnapshotCandyBudgetActivities] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),
	  [Contract Number]	nvarchar(20),
	  [Contract Name] nvarchar(50),		  
	  [Project Number] nvarchar(10),	
	  [Project Name] nvarchar(50),	
	  [Unit] nvarchar(15),	
	  [Actual Net] money,	
	  [Bill Selling] money,
	  [Final Selling] money,	
	  [Claim Selling] money,	
	  [Approved Claimed VO Selling] money,	
	  [Approved Claimed VO Net] money,	
	  [Unapproved Claimed VO Selling] money,	
	  [Unapproved Claimed VO Net] money,	
	  [Approved VO Final Selling] money,	
	  [Approved VO Final Net] money,	
	  [Unapproved VO Final Selling] money,	
	  [Unapproved VO Final Net] money,	
	  [Final Net] money,	
	  [Remaining Cost] money,	
	  [Paid Selling] money,	
	  [Actual Selling] money,	
	  [Next Month Selling] money,	
	  [User Selling] money,
    [Approved Actual VO Selling] money,
    [Unapproved Actual VO Selling] money
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
    select budgets.TASKCODE as [Activity Number], budgets.TASKNAME as [Activity Name], budgets.CONTRACT as [Contract Number], @contrName as [Contract Name], 
	@projNumber as [Project Number], @projName as [Project Name], budgets.UNIT as [Unit], budgets.ActualNetAmt as [Actual Net], 
	budgets.BillSelAmt as [Bill Selling], budgets.FinalSelAmt as [Final Selling], budgets.ClaimSelAmt as [Claim Selling], budgets.AppVOClaimSelAmt as [Approved Claimed VO Selling], 
	budgets.AppVOClaimNetAmt as [Approved Claimed VO Net], budgets.UNappVOClaimSelAmt as [Unapproved Claimed VO Selling], budgets.UNappVOClaimNetAmt as [Unapproved Claimed VO Net], budgets.AppVOFinalSelAmt as [Approved VO Final Selling], 
	budgets.AppVOFinalNetAmt as [Approved VO Final Net], budgets.UNappVOFinalSelAmt as [Unapproved VO Final Selling], budgets.UNappVOFinalNetAmt as [Unapproved VO Final Net], budgets.FinalNetAmt as [Final Net], 
	budgets.RemCostAmt as [Remaining Cost], budgets.PaidSelAmt as [Paid Selling], budgets.ActualSelAmt as [Actual Selling], budgets.NextMonthSelAmt as [Next Month Selling], budgets.UserSelAmt as [User Selling],
  AppVOActualSelAmt as [Approved Actual VO Selling], UNappVOActualSelAmt as [Unapproved Actual VO Selling] from CANDY_BUDGETS budgets
	where budgets.CONTRACT = @contrno
	and budgets.SYSDATE = @candyImportDate
	order by budgets.TASKCODE;

	RETURN
END
		
		