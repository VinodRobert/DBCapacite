/****** Object:  Function [dbo].[COSUM]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[COSUM] 
( 
	@orgs	nvarchar(150),
	@start date,
	@end date
)


returns @COSummary table 
(
[OrdHistID]							int,
[ORDIDHIST]							char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Ordid]								char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Order Number]						nvarchar (55) COLLATE SQL_Latin1_General_CP1_CI_AS,	
[Order Description]					nvarchar (125) COLLATE SQL_Latin1_General_CP1_CI_AS,	
[Starting ReqID]					int,
[Current Req ID]					int,
[CO Status]							nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,						
[Revision Number]					nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,						
[Initial Order Date]				datetime,
[CO Start Date]						datetime,
[CO End Date]						datetime,
[CO Duration]						numeric (18,2),
[Initial Owner]						char (15) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Current Owner]						char (15) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Initial Value ex VAT]				money,
[Initial VAT]						money,
[Current Value ex VAT]				money,
[Current VAT]						money,
[Starting Req Number]				nvarchar (55) COLLATE SQL_Latin1_General_CP1_CI_AS,	
[Current Req Number]				nvarchar (55) COLLATE SQL_Latin1_General_CP1_CI_AS,
[OSEQ]								int,
[CSEQ]								int,
[Original Final Approver]			nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Current Final Approver]			nvarchar (15) COLLATE SQL_Latin1_General_CP1_CI_AS,
[First Line Allocation]				nvarchar (25) COLLATE SQL_Latin1_General_CP1_CI_AS,
[First Line Cost Code]							nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[First Line Cost Code Name]					nvarchar (100) COLLATE SQL_Latin1_General_CP1_CI_AS
)

as
begin
insert into @COSummary
select 


OH.ORDHISTID,
OH.ORDID,
(select left(OH.ORDID,(select CHARINDEX('-',OH.ORDID)-1))),
OH.ORDNUMBER,
OH.shortdescr,
OH.REQID,
O.reqid,
case when O.ORDSTATUSID='500' then 'CO Pending' else case when OH.REQID=O.REQID then 'CO Cancelled' else 'CO Completed' end end,
(select right(OH.ORDID,(select CHARINDEX('-',OH.ORDID)))), 
OH.CREATEDATE,
OH.HISTDATE,
 case when O.ORDSTATUSID='500' then GETDATE() else case when OH.REQID=O.reqid then (select logdatetime from REQ where REQID=O.REQID) else (select ORDSTATUSDATE from ORD where left(OH.ORDID,(select CHARINDEX('-',OH.ORDID)-1))=ORD.ORDID) end end,
DATEDIFF(dd,OH.HISTDATE,(case when O.ORDSTATUSID='500' then GETDATE() else (select logdatetime from REQ where REQID=O.REQID)  end)),
U.LOGINID,
UU.LOGINID,
'',
'',
'',
'',
R.REQNUMBER,
RR.REQNUMBER,0,0,
'',
'',
'',
'',
''
from ORDHISTORY OH
left outer join USERS U on U.USERID=OH.USERID
left outer join ORD O on O.ORDID=(select left(OH.ORDID,(select CHARINDEX('-',OH.ORDID)-1)))
left outer join Users UU on UU.userid=O.USERID
left outer join REQ R on R.Reqid=OH.REQID
left outer join REQ RR on RR.Reqid=O.Reqid
where OH.HISTDATE between @start and @end and O.Borgid in (select S.Items from dbo.Split(@Orgs, ',') S where S.Items is not null )

declare @COLINES table
(
[ORDID HIST]					char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Line No]					int,
[Value ex VAt]				money,
[VAT]						money
)
insert into @COLINES
select
ORDID,LINENUMBER,QTY*PRICE*(1-(DISCOUNT/100)),(QTY*PRICE*(1-(DISCOUNT/100)))*(VATPERC/100)
from 
ORDITEMSHISTORY
where HISTDATE between @start and @end

update @COSummary
set [Initial Value ex VAT]=(select sum([Value ex VAt]) from @COLINES where [ordid hist]=ordidhist group by [ORDID HIST] )

update @COSummary
set [Initial VAT]=(select sum([VAT]) from @COLINES where [ordid hist]=ordidhist group by [ORDID HIST] )

declare @REQLINES table
(
[REQ ID]					char (10) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Line No]					int,
[Value ex VAt]				money,
[VAT]						money,
[Allocation]				nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS,		
[Cost Code]					nvarchar (10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Cost Code Name]			nvarchar (100) COLLATE SQL_Latin1_General_CP1_CI_AS
)
insert into @REQLINES
select RI.reqid, RI.LINENUMBER,RI.QTY*RI.PRICE*(1-(RI.DISCOUNT/100)),(RI.QTY*RI.PRICE*(1-(RI.DISCOUNT/100)))*(RI.VATPERC/100),
RI.ALLOCATION,
case when RI.ALLOCATION='Contracts' then C.CONTRNUMBER else case when RI.ALLOCATION='Overheads' then cast(RI.DIVISIONID as nvarchar) else case when RI.ALLOCATION='Plant' then RI.PENUMBER else '' end end end,
case when RI.ALLOCATION='Contracts' then C.CONTRName else case when RI.ALLOCATION='Overheads' then D.DivName else case when RI.ALLOCATION='Plant' then PE.PeName else '' end end end
from reqitems RI
left outer join Contracts C on C.CONTRID=RI.CONTRACTID
left outer join DIVISIONS D on D.DivID=RI.DIVISIONID
left outer join PLANTANDEQ PE on PE.PeNumber=RI.PENUMBER
where REQID in (select [current req id] from  @COSummary)

update @COSummary
set [First Line Allocation]=(select top 1 Allocation from @REQLINES where  [REQ ID]=[Current Req ID] order by [Line No])

update @COSummary
set [First Line Cost Code Name]=(select top 1 [Cost Code Name] from @REQLINES where  [REQ ID]=[Current Req ID] order by [Line No])

update @COSummary
set [First Line Cost Code]=(select top 1 [Cost Code] from @REQLINES where  [REQ ID]=[Current Req ID] order by [Line No])

update @COSummary
set [Current Value ex VAT]	=(select sum([Value ex VAt]) from @REQLINES where [REQ ID]=[Current Req ID] group by [REQ ID] )

update @COSummary
set [Current VAT]	=(select sum([VAT]) from @REQLINES where [REQ ID]=[Current Req ID] group by [REQ ID] )

update @COSummary
set OSEQ=A.A from (select Max(seq) A,reqid ID from REQAPPROVALHIST where reqid in (select [Starting ReqID] from @COSummary)  and REQSTATUSID=26 group by reqid) A 
left outer join @COSummary on [Starting ReqID]=A.ID

update @COSummary
set [Original Final Approver]=F.U from (
select U.Loginid U ,AP.SEQ SQ, AP.REQID ID from USERS U left outer join REQAPPROVALHIST AP on AP.USERID=U.USERID)F
left outer join @COSummary on [Starting ReqID]=F.ID and OSEQ=F.SQ

update @COSummary
set CSEQ=A.A from (select Max(seq) A,reqid ID from REQAPPROVALHIST where reqid in (select [Current Req ID] from @COSummary) and REQSTATUSID=26 group by reqid) A 
left outer join @COSummary on [Current Req ID]=A.ID

update @COSummary
set [Current Final Approver] =F.U from (
select U.Loginid U ,AP.SEQ SQ, AP.REQID ID from USERS U left outer join REQAPPROVALHIST AP on AP.USERID=U.USERID)F
left outer join @COSummary on [Current Req ID]=F.ID and CSEQ=F.SQ

return 
end

 