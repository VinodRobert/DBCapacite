/****** Object:  Function [dbo].[NonCandy]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.NonCandy
(
@Org		int,
@FromDate	datetime,
@Todate		datetime,
@Contracts	nvarchar(200)
)

returns @NonCandy table
(
[Contract]			nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Date]				datetime,
OrdNo				nvarchar(55)  COLLATE SQL_Latin1_General_CP1_CI_AS,
OrdStatus			nvarchar(55)  COLLATE SQL_Latin1_General_CP1_CI_AS,
Ordid				int,
ReqID				int,
[LineNo]			int,
[Type]				nvarchar(6)  COLLATE SQL_Latin1_General_CP1_CI_AS,
[Cred SubNo]		nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
Name				nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
Activity			nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
Ledger				nvarchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS,
LedgerName			nvarchar(35)  COLLATE SQL_Latin1_General_CP1_CI_AS,
ItemDesc			nvarchar(255)  COLLATE SQL_Latin1_General_CP1_CI_AS,
OrdQty				numeric(18,4),
DelQty				numeric(18,4),
RecQty				numeric(18,4),
OrdCur				nvarchar(3)  COLLATE SQL_Latin1_General_CP1_CI_AS,
Price				money,
Discount			decimal(18,2),
Value				money,
ReqCreator			nvarchar(15)  COLLATE SQL_Latin1_General_CP1_CI_AS,
FinalApprover		nvarchar(15)  COLLATE SQL_Latin1_General_CP1_CI_AS
)

as
begin

if @Contracts='-1'
insert into @NonCandy
select 
C.CONTRNUMBER
,O.CREATEDATE
,O.ORDNUMBER
,case when O.ordstatusid=37 then 'Cancelled' else case when O.ORDSTATUSID='41' then 'Completed' else case when O.ORDSTATUSID=274 then 'PO Ready' else case when O.ORDSTATUSID=500 then 'Change order pending' else '' end end end end
,O.ORDID
,O.REQID
,OI.LINENUMBER
,O.RECTYPE
,S.SUPPCODE
,S.SUPPNAME
,A.ActNumber
,LC.LedgerCode
,LC.LedgerName
,OI.ITEMDESCRIPTION
,OI.QTY
,0
,0
,O.CURRENCY
,OI.PRICE
,OI.DISCOUNT
,round(OI.QTY*OI.PRICE*((100-OI.DISCOUNT)/100),2)
,U.LOGINID
,''
from Orditems OI
left outer join Ord O on O.ORDID=OI.ORDID
left outer join REQ R on R.REQID=O.REQID
--left outer join DELIVERIES D on D.ORDID=OI.ORDID and D.ORDITEMLINENO=OI.LINENUMBER
left outer join USERS u on U.USERID=R.ORIGUSERID
left outer join CONTRACTS C on C.CONTRID=OI.CONTRACTID
left outer join SUPPLIERS S on S.SUPPID=O.SUPPID
left outer join ACTIVITIES A on A.ActID=OI.ACTID
left outer join LEDGERCODES LC on LC.LedgerID=OI.GLCODEID
left outer join Projects P on P.PROJID=C.PROJID
where
OI.ALLOCATION='Contracts' and OI.CATORTENDITEM<>1 and O.CREATEDATE between cast(@FromDate as datetime) and cast(@Todate as datetime) and P.BORGID=@Org

else

insert into @NonCandy
select
C.CONTRNUMBER
,O.CREATEDATE
,O.ORDNUMBER
,case when O.ordstatusid=37 then 'Cancelled' else case when O.ORDSTATUSID='41' then 'Completed' else case when O.ORDSTATUSID=274 then 'PO Ready' else case when O.ORDSTATUSID=500 then 'Change order pending' else '' end end end end
,O.ORDID
,O.REQID
,OI.LINENUMBER
,O.RECTYPE
,S.SUPPCODE
,S.SUPPNAME
,A.ActNumber
,LC.LedgerCode
,LC.LedgerName
,OI.ITEMDESCRIPTION
,OI.QTY
,0
,0
,O.CURRENCY
,OI.PRICE
,OI.DISCOUNT
,round(OI.QTY*OI.PRICE*((100-OI.DISCOUNT)/100),2)
,U.LOGINID
,''
from Orditems OI
left outer join Ord O on O.ORDID=OI.ORDID
left outer join REQ R on R.REQID=O.REQID
--left outer join DELIVERIES D on D.ORDID=OI.ORDID and D.ORDITEMLINENO=OI.LINENUMBER
left outer join USERS u on U.USERID=R.ORIGUSERID
left outer join CONTRACTS C on C.CONTRID=OI.CONTRACTID
left outer join SUPPLIERS S on S.SUPPID=O.SUPPID
left outer join ACTIVITIES A on A.ActID=OI.ACTID
left outer join LEDGERCODES LC on LC.LedgerID=OI.GLCODEID
left outer join Projects P on P.PROJID=C.PROJID
where
OI.ALLOCATION='Contracts' and OI.CATORTENDITEM<>1 and O.CREATEDATE between cast(@FromDate as datetime) and cast(@Todate as datetime) and P.BORGID=@Org and
 C.CONTRNUMBER in (select S.Items from dbo.Split(@Contracts, ',') S where S.Items is not null ) 


update @NonCandy
set FinalApprover=AP.AP from 
(select reqid as RID,U.LOGINID as AP
from REQAPPROVALHIST RAP
left outer join Users U on U.USERID=RAP.USERID
where ahid in (
select max(ahid)
from REQAPPROVALHIST
group by reqid)) as AP
left outer join @NonCandy on ReqID=AP.RID

update @NonCandy
set DelQty=DEL.Qty from
(select ORDID as OI,ORDITEMLINENO as OLN,sum(DLVRQTY) as qty
from deliveries
group by ORDID,ORDITEMLINENO) as DEL
left outer join @NonCandy on Ordid=Oi and [LineNo]=OLN

update @NonCandy
set RecQty=REC.Qty from
(select ORDID as OI,ORDITEMLINENO as OLN,sum(DLVRQTY) as qty
from deliveries
group by ORDID,ORDITEMLINENO) as REC
left outer join @NonCandy on Ordid=Oi and [LineNo]=OLN

return
END