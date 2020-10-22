/****** Object:  Procedure [BI].[CrossTab_DebtorReg]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [BI].[CrossTab_DebtorReg] (@Select varchar(6000), 
    @PivotCol varchar(600),
    @Summaries varchar(600), 
    @GroupBy varchar(600),
    @OtherCols varchar(600) = NULL)
AS
 



set nocount on
set ansi_warnings off
 
declare @Vals varchar(Max);
set @Vals = '';
 
set @OtherCols= isNull(', ' + @OtherCols,'')
 
create table #temp  (Pivots varchar(8000))



insert into #temp
exec ('select distinct convert(varchar(600),' + @PivotCol + ') as Pivots FROM (' + @Select + ') T')

 


select @Vals = @Vals + ',' + 
    replace(replace(@Summaries,'(','(CASE WHEN ' + @PivotCol + '=''' + 
            Pivots +  ''' THEN '),')[', ' END) as [' + Pivots )
from #Temp 
order by Pivots
 


drop table #Temp

declare @sql varchar(Max)

 

set @sql = 'select ' + @GroupBy + @OtherCols + @Vals + ' from (' + @Select + ') Z GROUP BY ' + @GroupBy + ' Order by Ledgername '

 
 
 --MODIFIED BY VINOD ROBERT ON 24 JAN 2018 MADE THE ORDER BY LEDGERNAME ON HOLD 
--exec ( 'select ' + @GroupBy + @OtherCols + @Vals + 
--       ' from (' + @Select + ') Z GROUP BY ' + @GroupBy + ' Order by Ledgername ' )
 
exec ( 'select ' + @GroupBy + @OtherCols + @Vals + 
       ' from (' + @Select + ') Z GROUP BY ' + @GroupBy   )


set nocount off
set ansi_warnings on