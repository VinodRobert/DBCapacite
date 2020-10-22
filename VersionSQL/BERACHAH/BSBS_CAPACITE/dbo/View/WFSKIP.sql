/****** Object:  View [dbo].[WFSKIP]    Committed by VersionSQL https://www.versionsql.com ******/

 

create view dbo.WFSKIP

as

select 
WFH.DESCR as			[WorkflowDesc],
WFH.[PROC] as			[Process], 
WFD.SEQ as				[Sequence] , 
WFD.DESCR as			[ApprovalDescription],
U.LOGINID as			[Approver],
U2.LOGINID as			[Substitute],
case when WFD.ROLEID=-1 then '' else case when WFH.[PROC]='REQ' then RP.ROLENAME else case when WFH.[proc] in('JNL','SCI','DTI') then  RH.ROLENAME else '' end end end 	[ApproverRole],
case when WFD.SKIPCONDITION=-2 then 'Yes' else 'No' end as [IsAdditionalSkip],
WFD.LINELIMIT as		[LineLimit],
WFD.APPROVALLIMIT as	[AppLimit],
Case when WFSC.LEV=0 then cast (B.BORGID as nvarchar)+' - '+rtrim(B.BORGNAME)	else case when WFSC.LEV=4 then rtrim(WFLR.DESCR) else case when WFSC.ALLOC='CONTRACTS' and WFSC.LEV=2 then rtrim(P.PROJNAME)+' - '+rtrim(P.ProjName)  else case when WFSC.ALLOC='CONTRACTS' and WFSC.LEV=3 then rtrim(C.ContrNumber)+' - '+Rtrim(C.CONTRNAME) else case when WFSC.ALLOC='Overheads' and WFSC.LEV=2 then cast(D.DivID as nvarchar)+' - '+rtrim(D.divname) else case when WFSC.ALLOC='Plant' and WFSC.LEV=2 then cast(D.Divid as nvarchar)+' - '+rtrim(D.Divname)+' - as Plant Dept on Master'  else case when WFSC.ALLOC='STORE' and WFSC.LEV=2 then 'Org '+cast(WFSB.BORGID as nvarchar) + ' Store code '+rtrim(WFSB.Storecode) else '' end end end end end end end as [SkipLinkedTo]

 
from WORKFLOWDETAIL WFD
left outer join WORKFLOWHEADER WFH on WFH.WHID=WFD.WHID
left outer join USERS U on U.USERID=WFD.USERID
left outer join Users U2 on U2.USERID=WFD.USERID2
left outer join WORKFLOWSKIPCONDITION WFSC on WFSC.WDID=WFD.WDID
left outer join BORGS B on B.BORGID=WFSC.THEID and WFSC.LEV=0
left outer join DIVISIONS D on D.DivID=WFSC.THEID and WFSC.ALLOC in ('Plant','Overhreads') and WFSC.LEV=2
left outer join PROJECTS P on P.PROJID=WFSC.THEID and WFSC.ALLOC='Contracts' and WFSC.LEV=2
left outer join CONTRACTS C on C.CONTRID=WFSC.THEID and WFSC.ALLOC='Contracts' and WFSC.LEV=3
left outer join WORKFLOWLEDGERCODERANGERS WFLR on WFLR.WLCID=WFSC.THEID and WFSC.LEV=4
left outer join ROLEHEADER RH on RH.ROLEHEADERID=wfd.ROLEID and WFH.[PROC] in ('JNL','DTI','SCI')
left outer join ROLEHEADERP RP on RP.ROLEID=WFD.ROLEID and WFH.[PROC]='REQ'
left outer join WORKFLOWSTOREBORG WFSB on WFSB.WSBID=WFSC.THEID and WFSC.ALLOC='STORE' and WFSC.LEV=2
where WFD.SKIPCONDITION=-2


--Insert the UDR