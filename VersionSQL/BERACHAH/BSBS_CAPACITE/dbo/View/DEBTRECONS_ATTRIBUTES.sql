/****** Object:  View [dbo].[DEBTRECONS_ATTRIBUTES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW DEBTRECONS_ATTRIBUTES AS SELECT DEBTRECONS.* , A20.VALUE [Attribute.E-Invoice] FROM DEBTRECONS  LEFT OUTER JOIN ATTRIBVALUE A20 on A20.TABLENAME = 'DEBTRECONS' and A20.ATTRIBUTE = 'E-Invoice' and A20.COLKEY = DEBTRECONS.ReconID and A20.ARRAYINDEX = 0