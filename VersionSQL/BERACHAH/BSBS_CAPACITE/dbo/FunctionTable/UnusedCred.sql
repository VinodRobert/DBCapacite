/****** Object:  Function [dbo].[UnusedCred]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[UnusedCred] 
(
@days int
)

returns @UnusedCred table
(
CredNo				nvarchar (10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
CredName			nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
LastTranDate		nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
LastOrdDate			nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
LastDelDate			nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS
)

as
begin
insert into @UnusedCred
select 
C.Crednumber,C.CredName,'','',''
from Creditors C
where C.CredStatus=0 and C.CredNumber not in (select credno from TRANSACTIONS where TransType in ('DEL','CRI','CCN','CRA','JNL') and SYSDATE > DATEADD(dd,-@days,getdate()))

update @UnusedCred 
set LastTranDate=TT.TDATE from 
(select T.Credno CN, case when convert(nvarchar(max),max(T.SYSDATE),3) is null then 'No transaction date found' else convert(nvarchar(max),max(T.SYSDATE),3)end as  TDATE from TRANSACTIONS T left outer join CONTROLCODES CC on CC.ControlName='creditors'
where T.LedgerCode=CC.ControlFromGL
group by Credno) TT
left outer join @UnusedCred on CN=CredNo

update @UnusedCred set LastTranDate='No transactions exist' where lasttrandate=''


update @UnusedCred
set LastOrdDate=OD.OD from 
(select S.Suppcode SC, case when convert(nvarchar(max),max(O.CreateDate),3) is null then 'No order date found' else convert(nvarchar(max),max(O.CreateDate),3)end as OD from ORD O
left outer join Suppliers S on S.Suppid=O.Suppid
where O.RECTYPE='STD'
group by S.SUPPCODE) OD
left outer join @UnusedCred on SC=CredNo

update @UnusedCred set LastOrdDate='No orders exist' where LastOrdDate=''

update @UnusedCred
set LastDelDate=ODD.OD from 
(select S.Suppcode SC, case when convert(nvarchar(max),max(D.DLVRCAPTDATE),3) is null then 'No delivery date found' else convert(nvarchar(max),max(D.DLVRCAPTDATE),3)end as  OD from DELIVERIES D
left outer join  ORD O on O.ORDID=D.ORDID
left outer join Suppliers S on S.Suppid=O.Suppid
where O.RECTYPE='STD'
group by S.SUPPCODE) ODD
left outer join @UnusedCred on SC=CredNo

update @UnusedCred
set LastDelDate ='No deliveries exist' where LastDelDate=''

return
end