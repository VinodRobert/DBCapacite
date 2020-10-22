/****** Object:  Function [dbo].[getBudgetsSnapshot]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 10-01-2015
-- Description:	returns Budgets rolledback to a date
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getBudgetsSnapshot (@theDate datetime)
    RETURNS @t TABLE (
      [BorgID] [int] NOT NULL,
      [ContractID] [int] NOT NULL,
      [ContractNo] [nvarchar](10) NOT NULL,
      [ActivityID] [int] NOT NULL,
      [ActivityNo] [char](10) NOT NULL,
      [LedgerID] [int] NOT NULL,
      [LedgerNo] [char](10) NOT NULL,
      [YearNo] [char](10) NOT NULL,
      [Period] [int] NOT NULL,
      [Budget] [money] NOT NULL,
      [BudgetID] [int] NOT NULL,
      [OREst] [money] NOT NULL,
      [FFCost] [money] NOT NULL,
      [AIVar] [money] NOT NULL,
      [ACVar] [money] NOT NULL,
      [QTY] [decimal](18, 4) NOT NULL,
      [BUDGETFE] [decimal](18, 4) NOT NULL,
      [QTYFE] [decimal](18, 4) NOT NULL,
      [BUDGETBILLED] [decimal](18, 4) NOT NULL,
      [QTYBILLED] [decimal](18, 4) NOT NULL,
      [BUDGETTP] [decimal](18, 4) NOT NULL,
      [QTYTP] [decimal](18, 4) NOT NULL,
      [SYSDATE] [datetime] NOT NULL
  )
AS
BEGIN
    insert into @t
    SELECT 
    B.BorgID, B.ContractID, B.ContractNo, B.ActivityID, B.ActivityNo, 
    B.LedgerID, B.LedgerNo, B.YearNo, B.Period, 
    isnull(BS.BUDGET, B.BUDGET) BUDGET, 
    B.BudgetID, B.OREst, B.FFCost, B.AIVar, B.ACVar, 
    isnull(BS.QTY, B.QTY) QTY, 
    B.BUDGETFE, B.QTYFE, B.BUDGETBILLED, B.QTYBILLED, 
    B.BUDGETTP, B.QTYTP, B.SYSDATE
    FROM BUDGETS AS B
    OUTER APPLY (SELECT MIN(BS.SYSDATE) SYSDATE, BS.BUDGETID FROM BUDGETSSNAPSHOT BS WHERE BS.SYSDATE > @theDate AND BS.BUDGETID = B.BUDGETID GROUP BY BS.BUDGETID) BSD
    LEFT OUTER JOIN BUDGETSSNAPSHOT BS ON B.BUDGETID = BS.BUDGETID AND BS.SYSDATE = BSD.SYSDATE
    WHERE B.SYSDATE <= @theDate 

	RETURN
END
		
		