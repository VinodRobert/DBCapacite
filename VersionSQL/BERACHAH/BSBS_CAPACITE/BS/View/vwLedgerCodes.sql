/****** Object:  View [BS].[vwLedgerCodes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW BS.vwLedgerCodes
AS
SELECT     LedgerAlloc AS Allocation, LedgerCode, LedgerName
FROM         dbo.LEDGERCODES