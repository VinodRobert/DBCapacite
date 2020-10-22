/****** Object:  View [dbo].[PayslipContractOrder]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.PayslipContractOrder
AS
SELECT     TOP 100 PERCENT dbo.empccid.CCID, dbo.empccid.PAYROLLID, dbo.empccid.EMPNUMBER, dbo.CLOCKCARDS.CONTRNUMBER
FROM         dbo.empccid INNER JOIN
                      dbo.CLOCKCARDS ON dbo.empccid.CCID = dbo.CLOCKCARDS.CCID
ORDER BY dbo.empccid.EMPNUMBER