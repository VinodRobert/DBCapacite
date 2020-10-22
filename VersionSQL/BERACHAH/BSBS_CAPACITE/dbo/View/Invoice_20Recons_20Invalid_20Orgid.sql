/****** Object:  View [dbo].[Invoice Recons Invalid Orgid]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.[Invoice Recons Invalid Orgid]
AS
SELECT     dbo.ORD.BORGID, dbo.TRANSACTIONS.OrgID, dbo.ORD.ORDNUMBER, dbo.TRANSACTIONS.OrderNo
FROM         dbo.ORD INNER JOIN
                      dbo.TRANSACTIONS ON dbo.ORD.BORGID <> dbo.TRANSACTIONS.OrgID AND dbo.ORD.ORDNUMBER = dbo.TRANSACTIONS.OrderNo