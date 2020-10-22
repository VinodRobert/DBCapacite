/****** Object:  View [dbo].[LCGDETAILS]    Committed by VersionSQL https://www.versionsql.com ******/

 
create view dbo.LCGDETAILS
as
select 
LH.NAME															as [Group Name]		, 
LH.SYS															as [System]			,
LH.ALLOC														as [Allocation]		, 
case when LD.TYPE='ACT' then 'Activity' else 'Ledger Code' end	as [Item Type]		,
case when LD.TYPE='LED' then LC.LedgerCode else '' end			as [Ledger Code]	,
case when LD.TYPE='LED' then LC.LedgerName else '' end			as [Ledger Name]	,
case when LD.TYPE='ACT' then A.ActNumber else '' end			as [Activity]		,
case when LD.TYPE='ACT' then A.ActName else '' end				as [Activity Name]
from LEDGERCODEGROUPHEADER LH
left outer join LEDGERCODEGROUPDETAIL LD on LD.HID=LH.ID
left outer join LEDGERCODES LC on LC.LedgerID=LD.TID and LD.TYPE='LED'
left outer join ACTIVITIES A on A.ActID=LD.TID and LD.TYPE='ACT'