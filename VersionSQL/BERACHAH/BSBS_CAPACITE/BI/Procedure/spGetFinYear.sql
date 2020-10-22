/****** Object:  Procedure [BI].[spGetFinYear]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spGetFinYear]
AS

SELECT DISTINCT [YEAR] FINYEAR  FROM PERIODSETUP WHERE YEAR>2014 AND ORGID=2 ORDER BY YEAR  
 