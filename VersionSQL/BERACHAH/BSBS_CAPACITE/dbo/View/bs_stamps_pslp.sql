/****** Object:  View [dbo].[bs_stamps_pslp]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_stamps_pslp
AS
SELECT     TOP 100 PERCENT dbo.EMPSTAMPS.EMPNUMBER, dbo.EMPSTAMPS.PAYROLLID, SUM(dbo.EMPSTAMPS.NOOFSTAMPS) AS totstamp, 
                      SUM(dbo.EMPSTAMPS.SSTOTAL) AS totvalue
FROM         dbo.EMPSTAMPS INNER JOIN
                      dbo.STAMPSETS ON dbo.EMPSTAMPS.SSID = dbo.STAMPSETS.SSID
GROUP BY dbo.EMPSTAMPS.EMPNUMBER, dbo.EMPSTAMPS.PAYROLLID
ORDER BY dbo.EMPSTAMPS.EMPNUMBER