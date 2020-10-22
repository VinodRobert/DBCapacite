/****** Object:  Procedure [BI].[spGetPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [BI].[spGetPeriod] 
as
select PERIODID,PERIODDESC from periodmaster order by PeriodID