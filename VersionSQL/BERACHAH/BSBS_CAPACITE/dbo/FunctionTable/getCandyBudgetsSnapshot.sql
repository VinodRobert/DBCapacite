/****** Object:  Function [dbo].[getCandyBudgetsSnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 09-02-2016
-- Description:	returns Candy Budgets rolledback to a date
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getCandyBudgetsSnapshot (@theDate datetime)
    RETURNS @t TABLE (
  [ID] [int] NOT NULL,
  [TASKCODE] nvarchar(10),
	[TASKNAME] nvarchar(100),
	[CONTRACT] nvarchar(20),
	[UNIT] nvarchar(15),
	[ActualNetAmt] [money] NOT NULL,
	[BillSelAmt] [money] NOT NULL,
	[FinalSelAmt] [money] NOT NULL,
	[ClaimSelAmt] [money] NOT NULL,
	[AppVOClaimSelAmt] [money] NOT NULL,
	[AppVOClaimNetAmt] [money] NOT NULL,
	[UNappVOClaimSelAmt] [money] NOT NULL,
	[UNappVOClaimNetAmt] [money] NOT NULL,
	[AppVOFinalSelAmt] [money] NOT NULL,
	[AppVOFinalNetAmt] [money] NOT NULL,
	[UNappVOFinalSelAmt] [money] NOT NULL,
	[UNappVOFinalNetAmt] [money] NOT NULL,
	[FinalNetAmt] [money] NOT NULL,
	[RemCostAmt] [money] NOT NULL,
	[PaidSelAmt] [money] NOT NULL,
	[ActualSelAmt] [money] NOT NULL,
	[NextMonthSelAmt] [money] NOT NULL,
	[UserSelAmt] [money] NOT NULL,
	[SYSDATE] [datetime] NOT NULL
  )
AS
BEGIN
    insert into @t
	select CR.ID,
  CR.TASKCODE,
	CR.TASKNAME,
	CR.CONTRACT,
	CR.UNIT, 
	CR.ActualNetAmt, 
	CR.BillSelAmt, 
	CR.FinalSelAmt, 
	CR.ClaimSelAmt, 
	CR.AppVOClaimSelAmt, 
	CR.AppVOClaimNetAmt, 
	CR.UNappVOClaimSelAmt, 
	CR.UNappVOClaimNetAmt, 
	CR.AppVOFinalSelAmt, 
	CR.AppVOFinalNetAmt, 
	CR.UNappVOFinalSelAmt, 
	CR.UNappVOFinalNetAmt, 
	CR.FinalNetAmt, 
	CR.RemCostAmt, 
	CR.PaidSelAmt, 
	CR.ActualSelAmt, 
	CR.NextMonthSelAmt, 
	CR.UserSelAmt, 
	CR.SYSDATE
	FROM CANDY_BUDGETS AS CR
	OUTER APPLY (SELECT MIN(CRS.SYSDATE) SYSDATE, CRS.ID FROM CANDY_BUDGETSSNAPSHOT CRS WHERE CRS.SYSDATE > @theDate AND CRS.ID = CR.ID GROUP BY CRS.ID) CRSD
	LEFT OUTER JOIN CANDY_BUDGETSSNAPSHOT CRS ON CR.ID = CRSD.ID AND CR.SYSDATE = CRSD.SYSDATE
    WHERE CR.SYSDATE <= @theDate
    
	RETURN
END
		
		