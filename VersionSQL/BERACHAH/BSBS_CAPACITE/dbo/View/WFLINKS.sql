/****** Object:  View [dbo].[WFLINKS]    Committed by VersionSQL https://www.versionsql.com ******/

 

create view dbo.WFLINKS

as

select				
WFH.DESCR as																						[WorkflowDescription],
WFH.[PROC]	as																						[Process],
WFH.SUBTYPE	as																						[SubType],
WFH.ALLOC as																						[WorkflowAllocation],
WFL.Alloc as																						[LinkAllocation],
Case when WFL.LEV=0 then 'Organisation'	else case when WFL.LEV=4 then 'Ledger Range' else case when WFL.ALLOC='CONTRACTS' and WFL.LEV=2 then 'PROJECT' else case when WFL.ALLOC='CONTRACTS' and WFL.LEV=3 then 'CONTRACT' else case when WFL.ALLOC='Overheads' and WFL.LEV=2 then 'Division' else case when WFL.ALLOC='Plant' and WFL.LEV=2 then 'Plant Division'  else case when WFL.ALLOC='STORE' and WFL.LEV=2 then 'Store in Org'  else  '' end end end end end end end as [LinkLevel],
Case when WFL.LEV=0 then cast (B.BORGID as nvarchar)+' - '+rtrim(B.BORGNAME)	else case when WFL.LEV=4 then rtrim(WFLR.DESCR) else case when WFL.ALLOC='CONTRACTS' and WFL.LEV=2 then rtrim(P.PROJNAME)+' - '+rtrim(P.ProjName)  else case when WFL.ALLOC='CONTRACTS' and WFL.LEV=3 then rtrim(C.ContrNumber)+' - '+Rtrim(C.CONTRNAME) else case when WFL.ALLOC='Overheads' and WFL.LEV=2 then cast(D.DivID as nvarchar)+' - '+rtrim(D.divname) else case when WFL.ALLOC='Plant' and WFL.LEV=2 then cast(D.Divid as nvarchar)+' - '+rtrim(D.Divname)+' - as Plant Dept on Master'  else case when WFL.ALLOC='STORE' and WFL.LEV=2 then 'Org '+cast(WFSB.BORGID as nvarchar) + ' Store code '+rtrim(WFSB.Storecode) else '' end end end end end end end as [LinkageEntity]



from 
WORKFLOWHEADER WFH
Left outer join WORKFLOWLINKS WFL on WFL.WHID=WFH.WHID
left outer join BORGS B on B.borgid=WFL.THEID and WFL.LEV=0
left outer join DIVISIONS D on D.DivID=WFL.THEID and WFL.ALLOC in ('Overheads','Plant') and WFL.LEV=2
left outer join PROJECTS P on P.PROJID=WFL.THEID and WFL.ALLOC='Contracts' and WFL.LEV=2
left outer join CONTRACTS C on C.CONTRID=WFL.THEID and WFL.ALLOC='Contracts' and WFL.LEV=3
left outer join WORKFLOWLEDGERCODERANGERS WFLR on WFLR.WLCID=WFL.THEID and WFL.LEV=4
left outer join WORKFLOWSTOREBORG WFSB on WFSB.WSBID=WFL.THEID and WFL.ALLOC='STORE' and WFL.LEV=2

--Insert the UDR