/****** Object:  View [dbo].[BANKS_ATTRIBUTES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW BANKS_ATTRIBUTES AS SELECT BANKS.* , A4.VALUE [Attribute.RTGS Details] FROM BANKS  LEFT OUTER JOIN ATTRIBVALUE A4 on A4.TABLENAME = 'BANKS' and A4.ATTRIBUTE = 'RTGS Details' and A4.COLKEY = BANKS.BANKACCOUNT and A4.ARRAYINDEX = 0