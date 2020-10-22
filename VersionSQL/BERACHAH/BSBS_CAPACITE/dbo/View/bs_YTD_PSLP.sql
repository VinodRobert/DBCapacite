/****** Object:  View [dbo].[bs_YTD_PSLP]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_YTD_PSLP
AS
SELECT     TOP 100 PERCENT dbo.EMPED.PRLID, dbo.EMPED.EMPNUMBER, SUM(dbo.EMPED.THEMONEY) AS TOTDEDUCTIONS, dbo.EMPED.YEARNO, 
                      dbo.EMPED.EDSHID, dbo.EMPED.EDSNUMBER
FROM         dbo.EMPED INNER JOIN
                      dbo.EDSETS ON dbo.EMPED.EDSNUMBER = dbo.EDSETS.EDSNUMBER AND dbo.EMPED.PRLID = dbo.EDSETS.PAYROLLID AND 
                      dbo.EMPED.EDSHID = dbo.EDSETS.EDSHID
GROUP BY dbo.EMPED.PRLID, dbo.EMPED.EMPNUMBER, dbo.EMPED.YEARNO, dbo.EMPED.EDSHID, dbo.EMPED.EDSNUMBER, 
                      dbo.EDSETS.ISDEDUCTION
ORDER BY dbo.EMPED.PRLID, dbo.EMPED.EMPNUMBER, dbo.EMPED.EDSHID, dbo.EMPED.EDSNUMBER