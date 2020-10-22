/****** Object:  View [dbo].[simon_certs]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.simon_certs
AS
SELECT     TOP 100 PERCENT dbo.SUBCRECONS.OrgID, dbo.SUBCRECONS.SubConNumber, dbo.SUBCRECONS.Contract, dbo.SUBCONTRACTORS.SubNumber, 
                      dbo.SUBCONTRACTORS.SubName, dbo.CONTRACTS.CONTRNUMBER, dbo.CONTRACTS.CONTRNAME, dbo.SUBCRECONS.Orderno, 
                      dbo.SUBCRECONS.RetentionTot
FROM         dbo.SUBCRECONS INNER JOIN
                      dbo.SUBCONTRACTORS ON dbo.SUBCRECONS.SubConNumber = dbo.SUBCONTRACTORS.SubID INNER JOIN
                      dbo.CONTRACTS ON dbo.SUBCRECONS.Contract = dbo.CONTRACTS.CONTRID
ORDER BY dbo.SUBCONTRACTORS.SubNumber, dbo.CONTRACTS.CONTRNUMBER, dbo.SUBCRECONS.SubConNumber, dbo.SUBCRECONS.Contract