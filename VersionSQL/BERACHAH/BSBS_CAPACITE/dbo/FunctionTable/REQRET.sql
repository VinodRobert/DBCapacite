/****** Object:  Function [dbo].[REQRET]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[REQRET] 
(
@Year			nvarchar(4),
@Period			int,
@Type			nvarchar(10),
@Org			int
)

returns @ReqRet table
(
ID					int,
PltGroup			nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
PltCatNo			nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
PltCatName			nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
PENumber			nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
PEName				nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
ReturnYear			nvarchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS,
ReturnPeriod		int,
HireType			nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
HiredTo				nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
REqNo				nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
OnSiteDate			datetime,
OffSiteDate			datetime,
ReturnReference		nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
FromDate			datetime,
ToDate				datetime,
Q1					numeric(18,4),
Q2					numeric(18,4),
Q3					numeric(18,4),
Q4					numeric(18,4),
Q5					numeric(18,4),
WeekDays			decimal(18,2),
PHDays				decimal(18,2),
Revenue				money,
ReturnStatus		nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
InvNo				nvarchar(10)	COLLATE SQL_Latin1_General_CP1_CI_AS
)

as
Begin
if @Type='Period'

Insert into @ReqRet
select 
RPH.ID, 
PG.PltGroupNumber,
PC.CatNumber,
PC.CatName,
RPH.PeNumber,
PE.PeName,
RPH.HireRYear,
RPH.hirerperiod,
case when PHH.HireHAllocation='IPH' then 'Contracts' else case when PHH.HireHAllocation='EPH' then 'Debtors' else 'Overheads' end end,
case when PHH.HireHAllocation='IPH' then PHH.ContrNumber else case when PHH.HireHAllocation='EPH' then PHH.DebtNumber else cast (phh.DivIDTo as char) end end,
RPH.HireHNumber,
PHD.HireDDateOnSite,
PHD.HireDDateOfSite,
RPH.HireRNumber,
RPH.HireRFromDate,
RPH.HireRToDate,
RPH.HireRQ1,
RPH.HireRQ2,
RPH.HireRQ3,
RPH.HireRQ4,
RPH.HireRQ5,
RPH.HireRWeekDays,
RPH.HireRHolyday,
0,
case when RPH.HireRPostFlag=0 then 'Open' else case when RPH.HireRPostFlag=1 then 'Proforma' else case when RPH.HireRPostFlag=2 then 'Saved' else case when RPH.HireRPostFlag=3 then 'Posted' else '' end end end end,
case when RPH.HireRInvoiceNumber is not null then RPH.HireRInvoiceNumber else '' end

from ReqPlantHireReturnsHead RPH
left outer join PLANTANDEQ PE on PE.PeNumber=RPH.PeNumber
left outer join PLANTCATEGORIES PC on PC.CatID=PE.CatID
left outer join PlantGroups PG on PG.PltGroupID=PC.PltGroupID
left outer join PlantHireHeader PHH on  PHH.HireHNumber=RPH.HireHNumber
left outer join PlantHireDetail PHD on PHD.PeNumber=RPH.PeNumber and PHD.HireHNumber=RPH.HireHNumber
where PHH.BorgID=@Org and RPH.HireRYear=@Year and RPH.HireRPeriod=@Period

if @Type='YTD'
Insert into @ReqRet
select RPH.ID, 
PG.PltGroupNumber,
PC.CatNumber,
PC.CatName,
RPH.PeNumber,
PE.PeName,
RPH.HireRYear,
RPH.hirerperiod,
case when PHH.HireHAllocation='IPH' then 'Contracts' else case when PHH.HireHAllocation='EPH' then 'Debtors' else 'Overheads' end end,
case when PHH.HireHAllocation='IPH' then PHH.ContrNumber else case when PHH.HireHAllocation='EPH' then PHH.DebtNumber else  cast (phh.DivIDTo as char) end end,
RPH.HireHNumber,
PHD.HireDDateOnSite,
PHD.HireDDateOfSite,
RPH.HireRNumber,
RPH.HireRFromDate,
RPH.HireRToDate,
RPH.HireRQ1,
RPH.HireRQ2,
RPH.HireRQ3,
RPH.HireRQ4,
RPH.HireRQ5,
RPH.HireRWeekDays,
RPH.HireRHolyday,
0,
case when RPH.HireRPostFlag=0 then 'Open' else case when RPH.HireRPostFlag=1 then 'Proforma' else case when RPH.HireRPostFlag=2 then 'Saved' else case when RPH.HireRPostFlag=3 then 'Posted' else '' end end end end,
case when RPH.HireRInvoiceNumber is not null then RPH.HireRInvoiceNumber else '' end
from ReqPlantHireReturnsHead RPH
left outer join PLANTANDEQ PE on PE.PeNumber=RPH.PeNumber
left outer join PLANTCATEGORIES PC on PC.CatID=PE.CatID
left outer join PlantGroups PG on PG.PltGroupID=PC.PltGroupID
left outer join PlantHireHeader PHH on  PHH.HireHNumber=RPH.HireHNumber
left outer join PlantHireDetail PHD on PHD.PeNumber=RPH.PeNumber and PHD.HireHNumber=RPH.HireHNumber
where PHH.BorgID=@Org and RPH.HireRYear=@Year and RPH.HireRPeriod<=@Period

update @reqret
set revenue=FA.REV from 
(select IDR, sum(HireRTotalAmount) as REV from ReqPlantHireReturns group by IDR)
 as FA
 left outer join @ReqRet on ID=FA.IDR

return
end