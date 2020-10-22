/****** Object:  View [dbo].[bs_LOANSPAYMENTS_TOTALS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_LOANSPAYMENTS_TOTALS
AS
SELECT     LOANID, SUM(PAYMENT) AS TOTALPAYMENTS
FROM         dbo.EMPLOANSPAY
GROUP BY LOANID