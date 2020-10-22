/****** Object:  Procedure [BI].[CrossTab_ToSave]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [BI].[CrossTab_ToSave] (@Select varchar(1000), 
    @PivotCol varchar(100),
    @Summaries varchar(100), 
    @GroupBy varchar(100),
    @OtherCols varchar(100) = Null)
AS
 


set nocount on
set ansi_warnings off
 
declare @Vals varchar(8000);
set @Vals = '';
 
set @OtherCols= isNull(', ' + @OtherCols,'')
 
create table #temp  (Pivots varchar(100))
 
insert into #temp
exec ('select distinct convert(varchar(100),' + @PivotCol + ') as Pivots FROM (' + @Select + ') A')
 
select @Vals = @Vals + ', ' + 
    replace(replace(@Summaries,'(','(CASE WHEN ' + @PivotCol + '=''' + 
            Pivots +  ''' THEN '),')[', ' END) as [' + Pivots )
from #Temp 
order by Pivots

 
drop table #Temp
IF OBJECT_ID ('BSBS_TEMP.DBO.CROSSTAB','U') IS NOT NULL
  DROP TABLE BSBS_TEMP.DBO.CROSSTAB 

 
 exec ( 'select  ' + @GroupBy + @OtherCols + @Vals + 
       ' INTO BSBS_TEMP.DBO.CROSSTAB from (' + @Select + ') A GROUP BY ' + @GroupBy)


set nocount off
set ansi_warnings on

 