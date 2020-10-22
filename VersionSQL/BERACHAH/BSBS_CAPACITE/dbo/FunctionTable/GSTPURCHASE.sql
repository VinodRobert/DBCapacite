/****** Object:  Function [dbo].[GSTPURCHASE]    Committed by VersionSQL https://www.versionsql.com ******/

create function dbo.GSTPURCHASE
(
@Org		int,
@CGSTTypes	nvarchar(100),
@SGSTTypes	nvarchar(100),
@IGSTTypes	nvarchar(100),
@Period		int,
@Year		int
)

returns @GSTPURCHASE Table
(
TransID					int,
TranGrp					int,
Transtype				nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,	
Organisation			nvarchar (75) COLLATE SQL_Latin1_General_CP1_CI_AS,	
POWONumber				nvarchar (55) COLLATE SQL_Latin1_General_CP1_CI_AS,	
POWODate				date,
SupplierNumber			nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,	
SupplierName			nvarchar (55) COLLATE SQL_Latin1_General_CP1_CI_AS,	
Place					nvarchar (120) COLLATE SQL_Latin1_General_CP1_CI_AS,	
RCM						nvarchar (5) COLLATE SQL_Latin1_General_CP1_CI_AS,	
GSTN					nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,	
Type					nvarchar (7) COLLATE SQL_Latin1_General_CP1_CI_AS,	
InvNo					nvarchar (55) COLLATE SQL_Latin1_General_CP1_CI_AS,	
InvDate					date,
Description				nvarchar (255) COLLATE SQL_Latin1_General_CP1_CI_AS,	
UOM						nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,	
Qty						numeric (23,4),
Rate					money,
ValueBeforeGST			money,
GSTperc					numeric(23,4),
CGST					money,
SGST					money,
IGST					money,
TotalAmt				money
)					
as
begin	
insert into @GSTPURCHASE

select T.transid,T.trangrp,T.Transtype, B.BORGNAME,T.OrderNo,O.CREATEDATE, T.credno,case when TransType in ('DEL','CRI','CCN') then C.CredName else S.SubName end,
case when TransType in ('DEL','CRI','CCN') then P.PROVINCENAME else P2.PROVINCENAME end,
'',
case when TransType in ('DEL','CRI','CCN') then C.ISOCERTIFICATION else s.ISOCERTIFICATION end,case when TransType in ('DEL','CRI','CCN') then 'Goods' else 'Services' end,
case when T.TRANSREFEXT is null then T.TransRef else T.TRANSREFEXT end ,T.PDate,
replace (replace (replace (replace (replace (T.Description,char(9),' '),char(160),' '),';',' '),char(13),' '),char(10),' '),
T.Unit,T.Quantity,T.Rate,T.Debit-T.Credit,0,0,0,0,0
from TRANSACTIONS T
left outer join BORGS B on B.Borgid=T.OrgID
left outer join Ord O on O.ORDNUMBER=T.OrderNo
left outer join CREDITORS C on C.CredNumber=T.Credno
left outer join PROVINCES P on P.PROVINCEID=C.PROVINCEID
left outer join SUBCONTRACTORS S on S.SubNumber=T.Credno
left outer join PROVINCES P2 on P2.PROVINCEID=S.PROVINCEID
left outer join CONTROLCODES CC on CC.Controlname='Work in progress'
left outer join CONTROLCODES CC1 on CC1.Controlname='Retained Income'
left outer join CONTROLCODES CC2 on CC2.Controlname='Value Added Tax'
left outer join CONTROLCODES CC3 on CC3.Controlname='Reverse Charge Mechanism'
left outer join CONTROLCODES CC4 on CC4.Controlname='Creditors'
left outer join CONTROLCODES CC5 on CC5.Controlname='Sub Contractors'
--left outer join TAXTRANS TT on TT.TRANSID=T.TransID
where transtype in ('DEL','CRI','CCN','SCI','SIN','SCN') and T.LedgerCode<>CC.ControlFromGL and T.LedgerCode<>CC1.ControlFromGL and T.LedgerCode not between CC2.ControlFromGL and CC2.ControlToGL 
and T.LedgerCode not between CC3.ControlFromGL and CC3.ControlToGL and T.LedgerCode <>CC4.ControlFromGL and T.LedgerCode not between CC5.ControlFromGL and CC5.ControlToGL and T.Period=@Period and T.year=@Year


update @GSTPURCHASE
set CGST=CG.AMT from (select transid as ID,sum(tax) as AMT from TAXTRANS where VATTYPE in (select S.Items from dbo.Split(@CGSTTypes, ',') S where S.Items is not null ) group by TRANSID) as CG
left outer join @GSTPURCHASE on TransID=CG.ID

update @GSTPURCHASE
set SGST=SG.AMT from (select transid as ID,sum(tax) as AMT from TAXTRANS where VATTYPE in (select S.Items from dbo.Split(@SGSTTypes, ',') S where S.Items is not null ) group by TRANSID) as SG
left outer join @GSTPURCHASE on TransID=SG.ID

update @GSTPURCHASE
set IGST=IG.AMT from (select transid as ID,sum(tax) as AMT from TAXTRANS where VATTYPE in (select S.Items from dbo.Split(@IGSTTypes, ',') S where S.Items is not null ) group by TRANSID) as IG
left outer join @GSTPURCHASE on TransID=IG.ID

update @GSTPURCHASE
set GSTperc=TX.PERC from (select transid as ID,sum(PERC) as PERC from TAXTRANS group by TRANSID) as TX
left outer join @GSTPURCHASE on TransID=TX.ID

update @GSTPURCHASE
set TotalAmt=ValueBeforeGST+SGST+CGST+IGST

update @GSTPURCHASE
set RCM= case when TranGrp in (select trangrp from transactions left outer join Controlcodes CC on CC.ControlName='Reverse Charge Mechanism' 
where LedgerCode between CC.ControlFromGL and CC.ControlToGL and year=@Year and period=@Period and OrgID=@Org) then 'Yes' else 'No' end
return
end


--Testing query
--select * from GSTPurchase (2,'G1,G3,G5,GA','G2,G4,G6,GB','GC',1,2018)

--===========================================================================
--Inserts the GSTPURCHASE function into the UDR Tables
--===========================================================================