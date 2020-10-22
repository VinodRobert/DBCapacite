/****** Object:  Function [dbo].[ContrOrditems]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function dbo.ContrOrditems
(
@daysprior			int,
@enddate			datetime,
@Contracts			nvarchar (500),
@Org				int
)

returns @ContrOrdItems table
(
[Order Number]					nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
[SupplierCode]					nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[SupplierName]					nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
[OrderType]						nvarchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Order Owner]					nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Create Date]					datetime,
[Status]						nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Line Number]					int,
[Contract]						nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,	
[Contract Name]					nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Ledger Code]					nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Ledger Name]					nvarchar(35) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Activity]						nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,			
[Item Type]						nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Resource Code]					nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Item Description]				nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Currency]						nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Price excl VAT]				money,
[Trade Discount]				decimal (18,4),
[UOM]							nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Ordered Qty]					numeric (18,4),
[Order Value]					money,
[Delivered Qty]					numeric (18,4),
[Delivered Value]				money,
[Reconciled Qty]				numeric (18,4),
[Req Number]					nvarchar(55) COLLATE SQL_Latin1_General_CP1_CI_AS,
ApprovalID						int,
[Final Approver]				nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[VAT Type]						nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS,
[VAT Percentage]				numeric(18,4),
[VAT Amount]					money
)
as
begin

if @Contracts='-1'

insert into @ContrOrdItems
Select
O.ORDNUMBER, S.SuppCode,S.SUPPNAME,O.RECTYPE,
U.LOGINID,
O.CREATEDATE, 
case when ORDSTATUSID=37 then 'Cancelled' else case when ORDSTATUSID=41 then 'Completed' else case when ORDSTATUSID=274 then 'PO Ready' else 'Change Order Pending' end end end,
OI.LINENUMBER,
rtrim(C.CONTRNUMBER),
rtrim(C.CONTRNAME),
LC.LedgerCode,
LC.LedgerName,
A.ActNumber,
Case when CATORTENDITEM=1 then 'Candy Item' else case when CATORTENDITEM=0 then 'Catalogue item' else 'Special Item' end end,
case when CATORTENDITEM=1 then RESOURCECODE else '' end,
replace (replace (replace (replace (replace (OI.ITEMDESCRIPTION,char(9),' '),char(160),' '),';',' '),char(13),' '),char(10),' '),
O.CURRENCY,
sum(OI.PRICE),
sum(OI.DISCOUNT),
OI.UOM,
sum(OI.QTY), 
OI.QTY * (OI.PRICE*((100-OI.DISCOUNT)/100)),
0,0,0,
R.REQNUMBER,-1,'',rtrim(VT.VATID)+' - '+rtrim(VT.VATNAME),OI.VATPERC,OI.VATAMOUNT
--case when  sum(D.DLVRQTY) is null then 0 else sum(D.DLVRQTY) end,
--case when sum(D.RECONQTY) is null then 0 else sum(D.RECONQTY) end

from ORDITEMS OI
left outer join Ord O on O.ORDID=OI.ORDID
left outer join Req R on R.ReqID=O.REQID
left outer join USERS U on U.USERID=O.USERID
left outer join CONTRACTS C on C.CONTRID=OI.CONTRACTID
left outer join LEDGERCODES LC on LC.LedgerID=OI.GLCODEID
left outer join ACTIVITIES A on A.ActID=OI.ACTID
left outer join Suppliers S on S.SuppID=O.SuppID
left outer join VATTYPES VT on VT.BORGID=O.BORGID and VT.VATID=OI.VATID
Where O.BORGID=@Org and OI.ALLOCATION='Contracts' and O.CREATEDATE between dateadd(dd,-@daysprior,@enddate) and cast(@enddate as datetime)
group by O.ORDNUMBER,S.SuppCode,S.SuppName,O.Rectype,U.LOGINID,O.CREATEDATE, ORDSTATUSID,OI.LINENUMBER,C.CONTRNUMBER,C.CONTRNAME,LC.LedgerCode,LC.LedgerName,A.ActNumber,CATORTENDITEM,
oi.ITEMDESCRIPTION,OI.RESOURCECODE,O.CURRENCY,OI.QTY,OI.PRICE,OI.DISCOUNT,R.ReqNumber,VT.VATID,VT.VATNAME,OI.VATPERC,OI.VATAMOUNT,OI.UOM

else 
insert into @ContrOrdItems
Select
O.ORDNUMBER, S.SuppCode,S.SUPPNAME,O.RECTYPE,
U.LOGINID,
O.CREATEDATE, 
case when ORDSTATUSID=37 then 'Cancelled' else case when ORDSTATUSID=41 then 'Completed' else case when ORDSTATUSID=274 then 'PO Ready' else 'Change Order Pending' end end end,
OI.LINENUMBER,
rtrim(C.CONTRNUMBER),
rtrim(C.CONTRNAME),
LC.LedgerCode,
LC.LedgerName,
A.ActNumber,
Case when CATORTENDITEM=1 then 'Candy Item' else case when CATORTENDITEM=0 then 'Catalogue item' else 'Special Item' end end,
case when CATORTENDITEM=1 then RESOURCECODE else '' end,
replace (replace (replace (replace (replace (OI.ITEMDESCRIPTION,char(9),' '),char(160),' '),';',' '),char(13),' '),char(10),' '),
O.CURRENCY,
sum(OI.PRICE),
sum(OI.DISCOUNT),
OI.UOM,
sum(OI.QTY), 
OI.QTY * (OI.PRICE*((100-OI.DISCOUNT)/100)),
0,0,0,
R.REQNUMBER,-1,'',rtrim(VT.VATID)+' - '+rtrim(VT.VATNAME),OI.VATPERC,OI.VATAMOUNT
--case when  sum(D.DLVRQTY) is null then 0 else sum(D.DLVRQTY) end,
--case when sum(D.RECONQTY) is null then 0 else sum(D.RECONQTY) end

from ORDITEMS OI
left outer join Ord O on O.ORDID=OI.ORDID
left outer join Req R on R.ReqID=O.REQID
left outer join USERS U on U.USERID=O.USERID
left outer join CONTRACTS C on C.CONTRID=OI.CONTRACTID
left outer join LEDGERCODES LC on LC.LedgerID=OI.GLCODEID
left outer join ACTIVITIES A on A.ActID=OI.ACTID
left outer join DELIVERIES D on D.ORDID=OI.ORDID and D.ORDITEMLINENO=OI.LINENUMBER
left outer join Suppliers S on S.SuppID=O.SuppID
left outer join VATTYPES VT on VT.BORGID=O.BORGID and VT.VATID=OI.VATID
Where O.BORGID=@Org and OI.ALLOCATION='Contracts' and O.CREATEDATE  between dateadd(dd,-@daysprior,@enddate) and cast(@enddate as datetime) and C.CONTRNUMBER in (select S.Items from dbo.Split(@Contracts, ',') S where S.Items is not null ) 
group by O.ORDNUMBER,S.SuppCode,S.SuppName,O.Rectype,U.LOGINID,O.CREATEDATE, ORDSTATUSID,OI.LINENUMBER,C.CONTRNUMBER,C.CONTRNAME,LC.LedgerCode,LC.LedgerName,A.ActNumber,
CATORTENDITEM,oi.ITEMDESCRIPTION,OI.RESOURCECODE,O.CURRENCY,OI.QTY,OI.PRICE,OI.DISCOUNT,R.ReqNumber,VT.VATID,VT.VATNAME,OI.VATPERC,OI.VATAMOUNT,OI.UOM

update @ContrOrdItems
set ApprovalID=
A.AD from (select Max(AHID) AD, ReqNumber RN from REQAPPROVALHIST RAH left outer join REQ R on R.ReqID=RAH.REQID where R.REQNUMBER in (select [Req Number] from @ContrOrdItems) and RAH.REQSTATUSID=26 group by R.REQNUMBER) A 
left outer join @ContrOrdItems on [Req Number]=A.RN

update @ContrOrdItems
set [Final Approver]=F.FA FROM
(select AHID, U.LoginID FA from REQAPPROVALHIST RAH left outer join Users U on U.Userid=RAH.UserID where AHID in (select ApprovalID from @ContrOrdItems)) F
left outer join @ContrOrdItems COI on F.AHID=COI.ApprovalID

update @ContrOrdItems
set [Delivered Qty]=DD.DQTY from
(select O.ORDNUMBER as ONO, ORDITEMLINENO as OLN,sum(DLVRQTY) as DQty
from DELIVERIES D
left outer join ORD O on O.ORDID=D.ORDID
group by ORDNUMBER,ORDITEMLINENO
) as DD
left outer join @ContrOrdItems on DD.ONO=[Order Number] and DD.OLN=[Line Number]

update @ContrOrdItems
set [Reconciled Qty]=RR.RQTY from
(select O.ORDNUMBER as ONO, ORDITEMLINENO as OLN,sum(RECONQTY) as RQty
from DELIVERIES D
left outer join ORD O on O.ORDID=D.ORDID
group by ORDNUMBER,ORDITEMLINENO
) as RR
left outer join @ContrOrdItems on RR.ONO=[Order Number] and RR.OLN=[Line Number]

update @ContrOrdItems
set [Delivered Value]=[Delivered Qty]*([Price excl VAT]*((100-[Trade Discount])/100))

RETURN
END