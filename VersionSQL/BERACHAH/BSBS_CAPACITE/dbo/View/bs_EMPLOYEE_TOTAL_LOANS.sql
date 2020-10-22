/****** Object:  View [dbo].[bs_EMPLOYEE_TOTAL_LOANS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_EMPLOYEE_TOTAL_LOANS
AS
SELECT     PRLID, EMPNUMBER, SUM(LOAN) AS LOANSAMOUNT
FROM         dbo.EMPLOANS
GROUP BY PRLID, EMPNUMBER