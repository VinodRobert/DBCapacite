/****** Object:  Function [dbo].[INV_vs_PO_Date]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[INV_vs_PO_Date] (@fromdate date,@todate date, @org char(150))

returns @Inv_vs_PO table 
(
[Org ID]					int,
[ReqID]						int,
[Inv No/Trans Ref]			char(10)	COLLATE SQL_Latin1_General_CP1_CI_AS,
[Order Number]				char(55)	COLLATE SQL_Latin1_General_CP1_CI_AS,
[Invoice Capture User]		char(150)	COLLATE SQL_Latin1_General_CP1_CI_AS,
[Invoice Date]				datetime,
[Invoice Capture Date]		datetime,
[Order Create Date]			datetime,
[Requisition Create Date]	datetime,
[Requisition Create User]	char(150)	COLLATE SQL_Latin1_General_CP1_CI_AS,
[Final Approver]			char(150)	COLLATE SQL_Latin1_General_CP1_CI_AS,
[OrigMaxAPP]				int
)
as begin 
insert into @Inv_vs_PO
select T.OrgID, O.reqid, T.TransRef, T.OrderNo, T.UserID, T.PDate, T.SYSDATE, O.CREATEDATE, R.CREATEDATE, U.LOGINID, '', 0
from 
Transactions T
left outer join CONTROLCODES CC on CC.ControlName='Creditors'
left outer join Ord O on O.ORDNUMBER=T.OrderNo and O.BORGID=T.OrgID
left outer join Req R on R.REQID=O.REQID
left outer join Users U on U.USERID=R.USERID
where T.TransType='DEL' and T.PDate<cast(O.CREATEDATE as date) and pdate between @fromdate and @todate and T.OrgID in (select S.Items from dbo.Split(@org, ',') S where S.Items is not null ) and T.LedgerCode=CC.ControlFromGL

update @Inv_vs_PO
set [Invoice Capture User]=LoginID from USERS where Users.USERID=[Invoice Capture User] and isnumeric([Invoice Capture User])=1
 
update @Inv_vs_PO
set OrigMaxAPP=A.A from (select Max(seq) A,reqid ID from REQAPPROVALHIST where reqid in (select reqid from @Inv_vs_PO) group by reqid) A 
left outer join @Inv_vs_PO on ReqID=A.ID

update @Inv_vs_PO
set [Final Approver]=F.U from (
select U.Loginid U ,AP.SEQ SQ, AP.REQID ID from USERS U left outer join REQAPPROVALHIST AP on AP.USERID=U.USERID) F
left outer join @Inv_vs_PO on REQID=F.ID and OrigMaxAPP=F.SQ

RETURN
END