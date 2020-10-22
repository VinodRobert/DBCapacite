/****** Object:  View [BS].[vwDebtors]    Committed by VersionSQL https://www.versionsql.com ******/

create VIEW BS.vwDebtors 
as
SELECT     dbo.DEBTORS.DebtNumber, dbo.DEBTORS.DebtName AS Debtor, dbo.DEBTORS.DebtAddress1 AS Street, dbo.DEBTORS.DebtAddress2 AS City, 
                      dbo.DEBTORS.DebtAddress3 AS State, dbo.DEBTORS.DebtPCode AS PostalCode, dbo.DEBTORS.DebtTel AS Telephone, dbo.DEBTORS.DebtFax AS Fax, 
                      dbo.DEBTORS.DebteMail AS Mail, dbo.DEBTORS.DebtControl AS ControlCode, dbo.DEBTORS.DebtVatNo AS VATNo, dbo.PROVINCES.PROVINCENAME
FROM         dbo.DEBTORS LEFT OUTER JOIN
                      dbo.PROVINCES ON dbo.DEBTORS.PROVINCEID = dbo.PROVINCES.PROVINCEID