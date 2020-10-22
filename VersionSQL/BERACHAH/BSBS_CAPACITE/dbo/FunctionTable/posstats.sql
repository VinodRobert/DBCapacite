/****** Object:  Function [dbo].[posstats]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.posstats
(
@daysprior int,
@End	datetime,
@Borg  int

)

returns @POSSTATS table
(
[Requisitioner]								nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[No Req Raised]								int,
[No of Req Lines]							int,
[No of PO created]							int,
[Value of PO]								decimal(19,2),
[Trade Discount on PO]						decimal(19,2),
[Reqs Pending Approval]						int,
[Reqs Cancelled]							int,
[Reqs Currently Rejected]					int,
[Change Orders Completed]					int,
[Change Orders Pending]						int
)

as
begin

declare @POSV table
(
[RequisitionerV]					nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[ReqID]							int,
[Line]							int,
[PO Value]						decimal(18,2),
[Discount Value]				decimal(18,2)
)
insert into @POSV
select U.LOGINID,RI.REQID,RI.LINENUMBER,RI.QTY*(RI.PRICE*((100-RI.DISCOUNT)/100)),RI.QTY*(RI.PRICE*(RI.DISCOUNT/100))
from REQITEMS RI
left outer join REQ R on R.REQID=RI.REQID
left outer join USERS U on U.USERID=R.ORIGUSERID
where CREATEDATE between dateadd(dd,-@daysprior,@end) and cast(@end as datetime) and REQSTATUSID=173 and BORGID=@Borg

declare @PVAL table
(
[ReqU]	nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[POVal]	money,
[PODisc]	money
)
insert into @PVAL
select RequisitionerV,sum([PO Value]),sum([Discount Value])
from @POSV
group by RequisitionerV


insert into @POSSTATS
select 
U.LOGINID,
count(distinct(R.Reqid)),
count(distinct(RI.REQID+RI.LINENUMBER)),
count(distinct(PV.Reqid)),
0,
0,
0,
0,
0,
0,
0
from REQ R
left outer join USERS U on U.USERID=R.ORIGUSERID
left outer join REQITEMS RI on RI.REQID=R.REQID
left outer join @POSV PV on PV.RequisitionerV=U.LOGINID

where CREATEDATE between dateadd(dd,-@daysprior,@end)  and cast(@end as datetime) and BORGID=@Borg
group by U.LOGINID

update @POSSTATS
set [Value of PO]=(select POVal from @PVAL where [ReqU]=[Requisitioner]	)

update @POSSTATS
set [Trade Discount on PO]=(select PODisc from @PVAL where [ReqU]=[Requisitioner]	)

update @POSSTATS
set [Reqs Pending Approval]=APP.PAcount
from (select U.LOGINID,count(distinct(R.REQID)) as PACOUNT
from REQ R
left outer join Users U on U.USERID=R.ORIGUSERID
where R.REQSTATUSID=32 and  CREATEDATE between dateadd(dd,-@daysprior,@end)  and cast(@end as datetime) and BORGID=@Borg
group by U.LOGINID) as APP
left outer join @POSSTATS on Requisitioner=APP.LOGINID

update @POSSTATS
set [Reqs Cancelled]	=CAN.CACount
from (
select U.LOGINID,count(distinct(R.REQID)) as CACount
from REQ R
left outer join Users U on U.USERID=R.ORIGUSERID
where R.REQSTATUSID=36 and  CREATEDATE between dateadd(dd,-@daysprior,@end)  and cast(@end as datetime) and BORGID=@Borg
group by U.LOGINID) as CAN
left outer join @POSSTATS on Requisitioner=CAN.LOGINID
		
update @POSSTATS
set [Reqs Currently Rejected]	= REJ.RJCount
from (
select U.LOGINID,count(distinct(R.REQID)) as RJCount
from REQ R
left outer join Users U on U.USERID=R.ORIGUSERID
where R.REQSTATUSID=202 and  CREATEDATE between dateadd(dd,-@daysprior,@end)  and cast(@end as datetime) and BORGID=@Borg
group by U.LOGINID) as REJ
left outer join @POSSTATS on Requisitioner=REJ.LOGINID

update @POSSTATS
set [Change Orders Completed]	= COC.COCCount
from (
select U.LOGINID,count(distinct(R.REQID)) as COCCount
from REQ R
left outer join Users U on U.USERID=R.ORIGUSERID
where R.REQSTATUSID=501 and  CREATEDATE between dateadd(dd,-@daysprior,@end) and cast(@end as datetime) and BORGID=@Borg
group by U.LOGINID) as COC
left outer join @POSSTATS on Requisitioner=COC.LOGINID

update @POSSTATS
set [Change Orders Pending]	=COP.COPCount
from (
select U.LOGINID,count(distinct(R.REQID)) as COPCount
from REQ R
left outer join Users U on U.USERID=R.ORIGUSERID
where R.REQSTATUSID=500 and  CREATEDATE between dateadd(dd,-@daysprior,@end)  and cast(@end as datetime) and BORGID=@Borg
group by U.LOGINID) as COP
left outer join @POSSTATS on Requisitioner=COP.LOGINID
 

RETURN
END