/****** Object:  View [dbo].[bs_CONTR_ACT_VAR_TRANS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_CONTR_ACT_VAR_TRANS
AS
SELECT     SUM(Debit) AS DEBIT, SUM(Credit) AS CREDIT, OrgID, Contract, Activity, LedgerCode, Period, [Year]
FROM         dbo.TRANSACTIONS
WHERE     (Allocation = 'Contracts')
GROUP BY OrgID, Contract, Activity, LedgerCode, Period, [Year]