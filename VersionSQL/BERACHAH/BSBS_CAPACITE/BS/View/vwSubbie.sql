/****** Object:  View [BS].[vwSubbie]    Committed by VersionSQL https://www.versionsql.com ******/

create VIEW BS.vwSubbie
as
SELECT     dbo.SUBCONTRACTORS.SubNumber, dbo.SUBCONTRACTORS.SubName AS SubContractor, dbo.SUBCONTRACTORS.SubAddress1 AS Street, 
                      dbo.SUBCONTRACTORS.SubAddress2 AS City, dbo.SUBCONTRACTORS.SubAddress3 AS State, dbo.SUBCONTRACTORS.SubPCode AS PostalCode, 
                      dbo.SUBCONTRACTORS.SubTel AS Tel, dbo.SUBCONTRACTORS.SubFax AS Fax, dbo.SUBCONTRACTORS.SubeMail AS Mail, 
                      dbo.SUBCONTRACTORS.SubType AS SubbieType, dbo.SUBCONTRACTORS.SubVATNo AS VATNumber, dbo.PROVINCES.PROVINCENAME
FROM         dbo.SUBCONTRACTORS LEFT OUTER JOIN
                      dbo.PROVINCES ON dbo.SUBCONTRACTORS.PROVINCEID = dbo.PROVINCES.PROVINCEID