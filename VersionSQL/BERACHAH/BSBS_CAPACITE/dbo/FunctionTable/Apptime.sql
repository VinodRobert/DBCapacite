/****** Object:  Function [dbo].[Apptime]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.Apptime
(
@days int,
@OrgID nvarchar(500)
)
returns @AppTime table
(
[User]					nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Req ID]				int,
Action					nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Date Time Actioned]	datetime, 
[Sequence]				int,
[Org ID]				int,
[Order Number]			nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Req Number]			nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Date Time Allocated]	datetime,
[Time to action]		numeric(18,4)
)

as
begin
if @OrgID='-1'

insert into @AppTime
select U.LOGINID, RH.REQID,
case when RH.REQSTATUSID=26 then '26 - Approved' else case when RH.REQSTATUSID=202 then '202 - Rejected' else case when rh.REQSTATUSID=99 then '99 - Owner Changed' 
else case when rh.REQSTATUSID=98 then '98 - Submitted' else case when RH.REQSTATUSID=97 then '97 - Approver Changed' else case when rh.REQSTATUSID=40 then '40 - Escaleted' 
else case when rh.REQSTATUSID=41 then '41 - Escalated' else case when rh.REQSTATUSID=96 then '96 - Edited' else'' end end end end end end end end
, RH.THEDATE, RH.SEQ,O.BORGID, O.ORDNUMBER,R.REQNUMBER,case when RH.SEQ=1 then R.CREATEDATE else RH1.THEDATE end, DATEDIFF(HH,case when RH.SEQ=1 then R.CREATEDATE else RH1.THEDATE end,RH.THEDATE)
from REQAPPROVALHIST RH
left outer join Req R on R.REQID=RH.REQID
left outer join Ord O on O.REQID=R.REQID
left outer join Users U on U.USERID=RH.USERID
left outer join REQAPPROVALHIST RH1 on RH1.REQID=Rh.REQID and RH1.SEQ=RH.SEQ-1
where O.ORDSTATUSID=274 and O.CREATEDATE>DATEADD(dd,-@days,getdate()) and RH.REQSTATUSID in (26,202)

else 
insert into @AppTime
select U.LOGINID, RH.REQID, 
case when RH.REQSTATUSID=26 then '26 - Approved' else case when RH.REQSTATUSID=202 then '202 - Rejected' else case when rh.REQSTATUSID=99 then '99 - Owner Changed' 
else case when rh.REQSTATUSID=98 then '98 - Submitted' else case when RH.REQSTATUSID=97 then '97 - Approver Changed' else case when rh.REQSTATUSID=40 then '40 - Escaleted' 
else case when rh.REQSTATUSID=41 then '41 - Escalated' else case when rh.REQSTATUSID=96 then '96 - Edited' else'' end end end end end end end end,
RH.THEDATE, RH.SEQ,O.BORGID, O.ORDNUMBER,R.REQNUMBER,case when RH.SEQ=1 then R.CREATEDATE else RH1.THEDATE end, DATEDIFF(HH,case when RH.SEQ=1 then R.CREATEDATE else RH1.THEDATE end,RH.THEDATE)
from REQAPPROVALHIST RH
left outer join Req R on R.REQID=RH.REQID
left outer join Ord O on O.REQID=R.REQID
left outer join Users U on U.USERID=RH.USERID
left outer join REQAPPROVALHIST RH1 on RH1.REQID=Rh.REQID and RH1.SEQ=RH.SEQ-1
where O.ORDSTATUSID=274 and O.CREATEDATE>DATEADD(dd,-@days,getdate()) and RH.REQSTATUSID in (26,202) and O.BORGID in (select S.Items from dbo.Split(@OrgID, ',') S where S.Items is not null ) 

RETURN
END