/****** Object:  View [dbo].[bs_activethisyear]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_activethisyear  AS  SELECT DISTINCT YEARNO, EMPNUMBER, PAYROLLID  FROM         dbo.EMPFINHISTORY 