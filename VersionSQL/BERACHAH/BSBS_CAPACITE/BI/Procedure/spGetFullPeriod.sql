/****** Object:  Procedure [BI].[spGetFullPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spGetFullPeriod] 
as
select 0 AS PERIODID,'Opening Balance' AS PERIODDESC UNION SELECT PERIODID,PERIODDESC from periodmaster  