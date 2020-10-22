/****** Object:  View [dbo].[bs_BEastVAT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_BEastVAT
AS
SELECT DISTINCT OrgID, [Year], Period, PDate, BatchRef, TransRef, Description, Currency, ConversionRate, LedgerCode
FROM         dbo.TRANSACTIONS
WHERE     (LedgerCode = '110301')