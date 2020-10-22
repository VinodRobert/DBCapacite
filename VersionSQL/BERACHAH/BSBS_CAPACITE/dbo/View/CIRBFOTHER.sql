/****** Object:  View [dbo].[CIRBFOTHER]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.CIRBFOTHER  AS  SELECT     dbo.EMPLOYEES.EMPNUMBER, dbo.EMPLOYEES.PAYROLLID, dbo.EMPLOYEES.TERMDATE, dbo.EMPLOYEES.SEX,  dbo.EMPLOYEES.MARITALSTATUS, dbo.EMPLOYEES.BIRTHDAY, dbo.EMPLOYEES.TAXNUMBER, dbo.EMPLOYEES.IDNUM, dbo.EMPLOYEES.RATE1,  dbo.EMPLOYEES.PENDATE, dbo.EMPLOYEES.INITIALS, dbo.EMPLOYEES.SURNAME, dbo.EMPLOYEES.GRSTARTDATE, dbo.EMPLOYEES.GRADE,   SUM(dbo.EMPED.THEMONEY) AS Other, dbo.EMPEDSETT.USEIT, dbo.EMPED.PERIODNO, dbo.EMPED.RUNNO, dbo.EMPED.YEARNO  FROM         dbo.EMPEDSETT INNER JOIN  dbo.EMPED INNER JOIN  dbo.EMPLOYEES ON dbo.EMPED.PRLID = dbo.EMPLOYEES.PAYROLLID AND dbo.EMPED.EMPNUMBER = dbo.EMPLOYEES.EMPNUMBER ON   dbo.EMPEDSETT.PRLID = dbo.EMPED.PRLID AND dbo.EMPEDSETT.EMPNUMBER = dbo.EMPED.EMPNUMBER AND  dbo.EMPEDSETT.EDSNUMBER = dbo.EMPED.EDSNUMBER AND dbo.EMPEDSETT.EDSCODE = dbo.EMPED.EDSCODE AND   dbo.EMPEDSETT.EDSHID = dbo.EMPED.EDSHID  GROUP BY dbo.EMPLOYEES.GRADE, dbo.EMPLOYEES.PAYROLLID, dbo.EMPLOYEES.TERMDATE, dbo.EMPLOYEES.SEX, dbo.EMPLOYEES.MARITALSTATUS,  dbo.EMPLOYEES.BIRTHDAY, dbo.EMPLOYEES.TAXNUMBER, dbo.EMPLOYEES.IDNUM, dbo.EMPLOYEES.RATE1, dbo.EMPLOYEES.GRSTARTDATE,  dbo.EMPLOYEES.SURNAME, dbo.EMPLOYEES.INITIALS, dbo.EMPLOYEES.PENDATE, dbo.EMPEDSETT.USEIT, dbo.EMPLOYEES.EMPNUMBER,   dbo.EMPEDSETT.EDSCODE, dbo.EMPED.PERIODNO, dbo.EMPED.RUNNO, dbo.EMPED.YEARNO  HAVING      (dbo.EMPEDSETT.EDSCODE = N'PRC') AND (SUM(dbo.EMPED.THEMONEY) > 0) OR  (dbo.EMPEDSETT.EDSCODE = N'PRF') 