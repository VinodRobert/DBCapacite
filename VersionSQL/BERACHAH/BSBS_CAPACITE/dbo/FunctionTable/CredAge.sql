/****** Object:  Function [dbo].[CredAge]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[CredAge] 
(
@Org	int,
@Year nvarchar (10)
)
returns @CredAge table
(
[CredCode]					nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS,
[CredName]					nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Current]					money,
[30Days]					money,
[60Days]					money,
[90Days]					money,
[>90Days]					money,
[TotalOutstanding]			money
)
as
begin

insert into @CredAge
Select distinct Credno,C.CredName,0,0,0,0,0,0
from Transactions T
left outer join ControlCodes CC on CC.Controlname='Creditors'
left outer join Creditors C on C.CredNumber=T.Credno
where 
(T.OrgID=@Org and T.Year=@Year and T.PaidFor=0 and T.LedgerCode = CC.ControlFromGL and Credno<>'')

update @CredAge
set [Current]=OS.OC from
(select Credno, sum(case when T.Currency=B.CURRENCY then -(T.Debit-T.Credit) else case when T.Currency <> B.Currency and T.Debit>0 then -T.HomeCurrAmount else T.HomeCurrAmount end end) as OC
from TRANSACTIONS T
left outer join Borgs B on B.BORGID=T.OrgID
left outer join CONTROLCODES CC1 on CC1.ControlName='Creditors'
where (T.OrgID=@Org and Year=@Year and PaidFor=0 and T.LedgerCode=CC1.ControlFromGL
and DATEDIFF(dd,T.Pdate,getdate())<30
)
group by Credno) as OS
left outer join @CredAge SA on SA.CredCode=OS.Credno

update @CredAge
set [30Days]=OS.OC30 from
(select Credno, sum(case when T.Currency=B.CURRENCY then -(T.Debit-T.Credit) else case when T.Currency <> B.Currency and T.Debit>0 then -T.HomeCurrAmount else T.HomeCurrAmount end end) as OC30
from TRANSACTIONS T
left outer join Borgs B on B.BORGID=T.OrgID
left outer join CONTROLCODES CC1 on CC1.ControlName='Creditors'
where (T.OrgID=@Org and Year=@Year and PaidFor=0 and T.LedgerCode = CC1.ControlFromGL and DATEDIFF(dd,T.Pdate,getdate())>=30 and DATEDIFF(dd,T.Pdate,getdate())<60)
group by Credno) as OS
left outer join @CredAge SA on SA.CredCode=OS.Credno

update @CredAge
set [60Days]=OS.OC60 from
(select Credno, sum(case when T.Currency=B.CURRENCY then -(T.Debit-T.Credit) else case when T.Currency <> B.Currency and T.Debit>0 then -T.HomeCurrAmount else T.HomeCurrAmount end end) as OC60
from TRANSACTIONS T
left outer join Borgs B on B.BORGID=T.OrgID
left outer join CONTROLCODES CC1 on CC1.ControlName='Creditors'
where (T.OrgID=@Org and Year=@Year and PaidFor=0 and T.LedgerCode = CC1.ControlFromGL and DATEDIFF(dd,T.Pdate,getdate())>=60 and DATEDIFF(dd,T.Pdate,getdate())<90)
group by Credno) as OS
left outer join @CredAge SA on SA.CredCode=OS.Credno

update @CredAge
set [90Days]=OS.OC90 from
(select Credno, sum(case when T.Currency=B.CURRENCY then -(T.Debit-T.Credit) else case when T.Currency <> B.Currency and T.Debit>0 then -T.HomeCurrAmount else T.HomeCurrAmount end end) as OC90
from TRANSACTIONS T
left outer join Borgs B on B.BORGID=T.OrgID
left outer join CONTROLCODES CC1 on CC1.ControlName='Creditors'
where (T.OrgID=@Org and Year=@Year and PaidFor=0 and T.LedgerCode = CC1.ControlFromGL and DATEDIFF(dd,T.Pdate,getdate())>=90 and DATEDIFF(dd,T.Pdate,getdate())<120)
group by Credno) as OS
left outer join @CredAge SA on SA.CredCode=OS.Credno

update @CredAge
set [>90Days]=OS.OC90 from
(select Credno, sum(case when T.Currency=B.CURRENCY then -(T.Debit-T.Credit) else case when T.Currency <> B.Currency and T.Debit>0 then -T.HomeCurrAmount else T.HomeCurrAmount end end) as OC90
from TRANSACTIONS T
left outer join Borgs B on B.BORGID=T.OrgID
left outer join CONTROLCODES CC1 on CC1.ControlName='Creditors'
where (T.OrgID=@Org and Year=@Year and PaidFor=0 and T.LedgerCode = CC1.ControlFromGL and DATEDIFF(dd,T.Pdate,getdate())>=90 and DATEDIFF(dd,T.Pdate,getdate())>=120)
group by Credno) as OS
left outer join @CredAge SA on SA.CredCode=OS.Credno


update @CredAge
set [TotalOutstanding]=[Current]+[30Days]+[60Days]+[90Days]+[>90Days]
	
return
end