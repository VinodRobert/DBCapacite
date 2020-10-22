/****** Object:  View [dbo].[WFLEVELS]    Committed by VersionSQL https://www.versionsql.com ******/

 

create view dbo.WFLEVELS

as

select				
WFH.DESCR as																						[WorkflowDescription],
WFH.[PROC]	as																						[Process],
WFH.SUBTYPE	as																						[SubType],
WFH.ALLOC as																						[Allocation],
WFD.SEQ	as																							[Sequence],
WFD.DESCR as																						[ApprovalDescription],
U.username as																						[PrimaryApprover],
U2.USERNAME as																						[Substitute],
case when WFD.ROLEID=-1 then '' else case when WFH.[PROC]='REQ' then RP.ROLENAME else case when WFH.[proc] in('JNL','SCI','DTI') then  RH.ROLENAME else '' end end end 	[ApproverRole],
case when WFD.SKIPCONDITION=0 then 'Yes' else 'No' end as											[ForceApproval],
case when WFD.SKIPCONDITION=-2 then 'Yes' else 'No' end as											[AddSkipCondition],
WFD.LINELIMIT as																					[LineLimit],
WFD.APPROVALLIMIT as																				[ApprovalLimit]

from 
WORKFLOWHEADER WFH
Left outer join WORKFLOWDETAIL WFD on WFD.WHID=WFH.WHID
left outer join USERS U on U.USERID=WFD.USERID
left outer join USERS U2 on U2.USERID=WFD.USERID2
left outer join ROLEHEADERP RP on RP.ROLEID=WFD.ROLEID and WFH.[PROC]='REQ'
left outer join ROLEHEADER RH on RH.ROLEHEADERID=WFD.ROLEID and WFH.[PROC] in ('JNL','SCI','DTI')


--Insert the UDR