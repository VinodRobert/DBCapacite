/****** Object:  View [dbo].[bs_PERIODEND_EMPHOURS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_PERIODEND_EMPHOURS AS SELECT TOP 100 PERCENT dbo.CLOCKCARDS.PAYROLLID, dbo.CLOCKCARDS.YEARNO, dbo.CLOCKCARDS.PERIODNO, dbo.CLOCKCARDS.RUNNO, dbo.CLOCKCARDS.EMPNUMBER, SUM(dbo.CLOCKCARDS.NT) AS NT, SUM(dbo.CLOCKCARDS.OT1) AS OT1, EDSETS.EDSVALUE AS VALOT1, SUM(dbo.CLOCKCARDS.OT2) AS OT2, EDSETS_1.EDSVALUE AS VALOT2, SUM(dbo.CLOCKCARDS.OT3) AS OT3, EDSETS_2.EDSVALUE AS VALOT3, SUM(dbo.CLOCKCARDS.OT4) AS OT4, EDSETS_3.EDSVALUE AS VALOT4, SUM(dbo.CLOCKCARDS.OT5) AS OT5, EDSETS_4.EDSVALUE AS VALOT5 FROM dbo.CLOCKCARDS INNER JOIN dbo.EMPLOYEES ON dbo.EMPLOYEES.EMPNUMBER=dbo.CLOCKCARDS.EMPNUMBER AND dbo.EMPLOYEES.PAYROLLID=dbo.CLOCKCARDS.PAYROLLID INNER JOIN dbo.EDSETS EDSETS ON dbo.EMPLOYEES.EDSHID=EDSETS.EDSHID INNER JOIN dbo.EDSETS EDSETS_1 ON dbo.EMPLOYEES.EDSHID=EDSETS_1.EDSHID INNER JOIN dbo.EDSETS EDSETS_2 ON dbo.EMPLOYEES.EDSHID=EDSETS_2.EDSHID INNER JOIN dbo.EDSETS EDSETS_3 ON dbo.EMPLOYEES.EDSHID=EDSETS_3.EDSHID INNER JOIN dbo.EDSETS EDSETS_4 ON dbo.EMPLOYEES.EDSHID=EDSETS_4.EDSHID GROUP BY dbo.CLOCKCARDS.PAYROLLID, dbo.CLOCKCARDS.PERIODNO, dbo.CLOCKCARDS.RUNNO, dbo.CLOCKCARDS.YEARNO, dbo.CLOCKCARDS.EMPNUMBER, EDSETS.EDSVALUE, EDSETS_1.EDSVALUE, EDSETS_2.EDSVALUE, EDSETS_3.EDSVALUE, EDSETS_4.EDSVALUE, EDSETS_3.EDSCODE, EDSETS_4.EDSCODE, EDSETS_2.EDSCODE, EDSETS.EDSCODE, EDSETS_1.EDSCODE HAVING (EDSETS_3.EDSCODE=N'OT4 ') AND (EDSETS_1.EDSCODE=N'OT2 ') AND (EDSETS_2.EDSCODE=N'OT3 ') AND (EDSETS_4.EDSCODE=N'OT5 ') AND (EDSETS.EDSCODE=N'OT1 ') ORDER BY dbo.CLOCKCARDS.PAYROLLID, dbo.CLOCKCARDS.YEARNO, dbo.CLOCKCARDS.PERIODNO, dbo.CLOCKCARDS.RUNNO, dbo.CLOCKCARDS.EMPNUMBER 