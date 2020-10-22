/****** Object:  View [dbo].[LCGLINKS]    Committed by VersionSQL https://www.versionsql.com ******/

 
create view dbo.LCGLINKS
as
select 
LH.NAME															as [Group Name]		, 
LH.SYS															as [System]			,
LH.ALLOC														as [Allocation]		, 
case when LL.LEV=1 then 'Organisiation' else case when LL.LEV=2 and LH.ALLOC='Contracts' then 'Project' else case when  LL.LEV=3 and LH.ALLOC='Contracts' then 'Contract' else case when  LL.LEV=2 and LH.ALLOC='Overheads' then 'Division' else  case when  LL.LEV=2 and LH.ALLOC='Plant' then 'Plant item' else'' end end end end end as [Linkage Level],
case when ll.LEV=1 then cast(B.BORGID as nvarchar) +' - '+B.BORGNAME else case when LL.LEV=2 and LH.ALLOC='Contracts' then rtrim(P.ProjNumber)+' - '+P.ProjName else case when  LL.LEV=3 and LH.ALLOC='Contracts' then rtrim(C.CONTRNUMBER)+' - '+C.CONTRNAME else case when  LL.LEV=2 and LH.ALLOC='Overheads' then cast(D.DivID as nvarchar)+' - '+D.DivName else  case when  LL.LEV=2 and LH.ALLOC='Plant' then rtrim(PP.PeNumber)+' - '+PP.PeName else'' end end end end end as [Linked Entity]
from LEDGERCODEGROUPHEADER LH
left outer join LEDGERCODEGROUPLINK LL on LL.HID=LH.ID
left outer join CONTRACTS C on C.CONTRID=LL.THEID and LH.ALLOC='Contracts' and LL.LEV=3
left outer join PROJECTS P on P.PROJID=LL.THEID and  LH.ALLOC='Contracts' and LL.LEV=2
left outer join DIVISIONS D on D.DivID=LL.THEID and LH.ALLOC='Overheads' and LL.LEV=2
left outer join BORGS B on B.BORGID=LL.THEID and ll.LEV=1
left outer join PLANTANDEQ PP on PP.PEID=LL.THEID and LH.ALLOC='Plant' and LL.LEV=2