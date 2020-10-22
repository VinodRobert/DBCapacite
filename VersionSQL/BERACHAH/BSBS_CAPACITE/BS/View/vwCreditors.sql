/****** Object:  View [BS].[vwCreditors]    Committed by VersionSQL https://www.versionsql.com ******/

create VIEW BS.vwCreditors 
as
SELECT     dbo.CREDITORS.CredNumber, dbo.CREDITORS.CredName AS Creditor, dbo.CREDITORS.CredAddress1 AS Street, dbo.CREDITORS.CredAddress2 AS City, 
                      dbo.CREDITORS.CredAddress3 AS State, dbo.CREDITORS.CredPcode AS PostalCode, dbo.CREDITORS.CredTel AS Telephone, dbo.CREDITORS.CredVAT AS PAN, 
                      dbo.CREDITORS.CredFax AS Fax, dbo.CREDITORS.CredeMail AS EMail, dbo.PROVINCES.PROVINCENAME AS Province
FROM         dbo.CREDITORS INNER JOIN
                      dbo.PROVINCES ON dbo.CREDITORS.PROVINCEID = dbo.PROVINCES.PROVINCEID