/****** Object:  View [dbo].[simon_retention]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.simon_retention
AS
SELECT     TOP 100 PERCENT dbo.TRANSACTIONS.Credno, dbo.simon_certs.SubName, dbo.simon_certs.CONTRNUMBER, dbo.simon_certs.CONTRNAME, 
                      SUM(dbo.TRANSACTIONS.Credit - dbo.TRANSACTIONS.Debit) AS ret, SUM(dbo.TRANSACTIONS.PaidToDate) AS paidtodate, 
                      SUM(dbo.TRANSACTIONS.PaidThisPeriod) AS paythisper, dbo.simon_certs.RetentionTot, dbo.simon_certs.Orderno
FROM         dbo.TRANSACTIONS INNER JOIN
                      dbo.simon_certs ON dbo.TRANSACTIONS.Credno = dbo.simon_certs.SubNumber AND 
                      dbo.TRANSACTIONS.Contract = dbo.simon_certs.CONTRNUMBER AND dbo.TRANSACTIONS.OrgID = dbo.simon_certs.OrgID
WHERE     (dbo.TRANSACTIONS.[Year] = '2004') AND (dbo.TRANSACTIONS.OrgID = 2) AND (dbo.TRANSACTIONS.SubConTran = 'retention')
GROUP BY dbo.simon_certs.RetentionTot, dbo.simon_certs.Orderno, dbo.TRANSACTIONS.Credno, dbo.simon_certs.SubName, dbo.TRANSACTIONS.Contract, 
                      dbo.simon_certs.CONTRNAME, dbo.simon_certs.CONTRNUMBER
ORDER BY dbo.TRANSACTIONS.Credno, dbo.TRANSACTIONS.Contract