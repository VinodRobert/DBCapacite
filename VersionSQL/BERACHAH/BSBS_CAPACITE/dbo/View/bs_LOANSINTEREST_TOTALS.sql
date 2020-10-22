/****** Object:  View [dbo].[bs_LOANSINTEREST_TOTALS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_LOANSINTEREST_TOTALS
AS
SELECT     SUM(INTERESTAMOUNT) AS TOTALINTEREST, LOANID
FROM         dbo.EMPLOANSINTR
GROUP BY LOANID