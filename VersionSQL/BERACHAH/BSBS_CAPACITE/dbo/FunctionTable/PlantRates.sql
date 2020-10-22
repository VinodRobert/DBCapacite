/****** Object:  Function [dbo].[PlantRates]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.PlantRates
(
@OrgID	int,
@Active nvarchar(3)
)

returns @Plantrates table
(
[Category]					nvarchar(70)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Plant No.]					nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Plant Name]				nvarchar(35)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate Type]					nvarchar(20)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Contract/Debtor/Division]	nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 1 Description]		nvarchar(25)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 1 Amount]				money,
[Rate 1 UOM]				nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 2 Description]		nvarchar(25)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 2 Amount]				money,
[Rate 2 UOM]				nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 3 Description]		nvarchar(25)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 3 Amount]				money,
[Rate 3 UOM]				nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 4 Description]		nvarchar(25)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 4 Amount]				money,
[Rate 4 UOM]				nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 5 Description]		nvarchar(25)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Rate 5 Amount]				money,
[Rate 5 UOM]				nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Min Hrs/Day]				numeric(18,4)
)
as
begin

if @active='Yes'

insert into @Plantrates
select case when PE.CatID =-1 then 'ZZZ No Category Assigned' else rtrim(PC.CatNumber)+' - '+rtrim(PC.CatName) end, 
rtrim(PE.PeNumber), 
rtrim(PE.PEName),
'1 - Category',
'',
rtrim(PC.catdesc1),
PC.catrate1, 
rtrim(PC.catunit1),
rtrim(PC.catdesc2),
PC.catrate2, 
rtrim(PC.catunit2),
rtrim(PC.catdesc3),
PC.catrate3, 
rtrim(PC.catunit3),
rtrim(PC.catdesc4),
PC.catrate4, 
rtrim(PC.catunit4),
rtrim(PC.catdesc5),
PC.catrate5, 
rtrim(PC.catunit5),
PC.HireRDayMin
from PLANTANDEQ PE
left outer join PLANTCATEGORIES PC on PC.CATID=PE.CatID
where PE.BorgID=@OrgID and PE.PeStatus=0

else 

insert into @Plantrates
select case when PE.CatID =-1 then 'ZZZ No Category Assigned' else rtrim(PC.CatNumber)+' - '+rtrim(PC.CatName) end, 
rtrim(PE.PeNumber), 
rtrim(PE.PEName),
'1 - Category',
'',
rtrim(PC.catdesc1),
PC.catrate1, 
rtrim(PC.catunit1),
rtrim(PC.catdesc2),
PC.catrate2, 
rtrim(PC.catunit2),
rtrim(PC.catdesc3),
PC.catrate3, 
rtrim(PC.catunit3),
rtrim(PC.catdesc4),
PC.catrate4, 
rtrim(PC.catunit4),
rtrim(PC.catdesc5),
PC.catrate5, 
rtrim(PC.catunit5),
PC.HireRDayMin
from PLANTANDEQ PE
left outer join PLANTCATEGORIES PC on PC.CATID=PE.CatID
where PE.BorgID=@OrgID 

if @Active='Yes'

insert into @Plantrates
select 
case when PE.CatID =-1 then 'ZZZ No Category Assigned' else rtrim(PC.CatNumber)+' - '+rtrim(PC.CatName) end, 
rtrim(PE.PeNumber), 
rtrim(PE.PEName),
case when PHR.HireFlag=2 then '2 - Plant Rate' else case when PHR.Hireflag=3 then '3 - Debtor Rate' else case when PHR.Hireflag=4 then '4 - Overhead Rate' else case when PHR.hireflag=5 then '5 - Contract Rate' else '' end end end end,
case when PHR.HireFlag=2 then '' else case when PHR.Hireflag=3 then PHR.DebtNumber else case when PHR.Hireflag=4 then cast(PHR.DivID as nvarchar) else case when PHR.hireflag=5 then PHR.ContractNum else '' end end end end,
rtrim(PC.catdesc1),
PHR.HireRate1, 
rtrim(PC.catunit1),
rtrim(PC.catdesc2),
PHR.HireRate2, 
rtrim(PC.catunit2),
rtrim(PC.catdesc3),
PHR.HireRate3, 
rtrim(PC.catunit3),
rtrim(PC.catdesc4),
PHR.HireRate4, 
rtrim(PC.catunit4),
rtrim(PC.catdesc5),
PHR.HireRate5, 
rtrim(PC.catunit5),
PHR.HireRDayMin
from PlantHireRates PHR
left outer join PLANTANDEQ PE on PE.PeNumber=PHR.PeNumber
left outer join PLANTCATEGORIES PC on PC.CatID=PE.CatID
where PHR.HireFlag<>0 and  PE.BorgID=@OrgID and PE.PeStatus=0

else

insert into @Plantrates
select 
case when PE.CatID =-1 then 'ZZZ No Category Assigned' else rtrim(PC.CatNumber)+' - '+rtrim(PC.CatName) end, 
rtrim(PE.PeNumber), 
rtrim(PE.PEName),
case when PHR.HireFlag=2 then '2 - Plant Rate' else case when PHR.Hireflag=3 then '3 - Debtor Rate' else case when PHR.Hireflag=4 then '4 - Overhead Rate' else case when PHR.hireflag=5 then '5 - Contract Rate' else '' end end end end,
case when PHR.HireFlag=2 then '' else case when PHR.Hireflag=3 then PHR.DebtNumber else case when PHR.Hireflag=4 then cast(PHR.DivID as nvarchar) else case when PHR.hireflag=5 then PHR.ContractNum else '' end end end end,
rtrim(PC.catdesc1),
PHR.HireRate1, 
rtrim(PC.catunit1),
rtrim(PC.catdesc2),
PHR.HireRate2, 
rtrim(PC.catunit2),
rtrim(PC.catdesc3),
PHR.HireRate3, 
rtrim(PC.catunit3),
rtrim(PC.catdesc4),
PHR.HireRate4, 
rtrim(PC.catunit4),
rtrim(PC.catdesc5),
PHR.HireRate5, 
rtrim(PC.catunit5),
PHR.HireRDayMin
from PlantHireRates PHR
left outer join PLANTANDEQ PE on PE.PeNumber=PHR.PeNumber
left outer join PLANTCATEGORIES PC on PC.CatID=PE.CatID
where PHR.HireFlag<>0 and  PE.BorgID=@OrgID

RETURN
END