/****** Object:  View [dbo].[bs_sum_cc_pslp]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_sum_cc_pslp
AS
SELECT     TOP 100 PERCENT PAYROLLID, EMPNUMBER, SUM(NT + OT1 + OT2 + OT3 + OT4 + OT5) AS tothrs, SUM(SHIFTSTW) AS totshifts, PERIODNO, RUNNO, 
                      YEARNO
FROM         dbo.CLOCKCARDS
GROUP BY PAYROLLID, EMPNUMBER, PERIODNO, RUNNO, YEARNO
ORDER BY EMPNUMBER, YEARNO, PERIODNO, RUNNO