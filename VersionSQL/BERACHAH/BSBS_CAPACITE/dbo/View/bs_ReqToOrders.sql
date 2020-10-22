/****** Object:  View [dbo].[bs_ReqToOrders]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_ReaToOrders
AS
SELECT     dbo.REQ.REQID, dbo.REQ.BORGID, dbo.REQ.REQNUMBER, dbo.REQ.REQSUBJECT, dbo.ORD.ORDID, dbo.ORD.ORDNUMBER, dbo.ORD.ORDSTATUSDATE
FROM         dbo.REQ LEFT OUTER JOIN
                      dbo.ORD ON dbo.REQ.REQID = dbo.ORD.REQID