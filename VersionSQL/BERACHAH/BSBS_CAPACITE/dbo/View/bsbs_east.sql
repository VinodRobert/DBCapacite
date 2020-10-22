/****** Object:  View [dbo].[bsbs_east]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bsbs_east
AS
SELECT DISTINCT OrgID, [Year], Period, PDate, BatchRef, TransRef, Description, Currency, ConversionRate, LedgerCode
FROM         dbo.TRANSACTIONS
WHERE     (LedgerCode = '110301')