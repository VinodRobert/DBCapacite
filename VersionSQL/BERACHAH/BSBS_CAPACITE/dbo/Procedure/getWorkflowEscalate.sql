/****** Object:  Procedure [dbo].[getWorkflowEscalate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 05-27-2016
-- Description:	Escalates the workflow to the next step if it is available and returns details for notification emails
-- NOTES:
--  
-- =============================================
CREATE PROCEDURE getWorkflowEscalate (@theID INT, @proc nvarchar(10), @userid INT, @orgid INT)
AS
BEGIN
    
  declare @maxSeq int 
  declare @wfValueApproved bit
  declare @apprDescr nvarchar(max)
  declare @wfStatus int
  declare @thisUserRoleID int
  declare @emailTo nvarchar(max)
  declare @emailSub nvarchar (max)
  declare @emailDetail nvarchar (max)

  if @proc = 'REQ' 
  BEGIN
    select @maxSeq = Max(Seq) FROM REQAPPROVALHIST WHERE REQID = @theID GROUP BY REQID
  END

  if @proc <> 'REQ' 
  BEGIN
    select @maxSeq = Max(Seq) FROM WORKFLOWHIST WHERE THEID = @theID and [PROC] = @proc GROUP BY THEID, [PROC]
  END

  if @proc = 'REQ' 
  BEGIN
    select @thisUserRoleID = ROLEID FROM USERSINBORGP INNER JOIN REQ on REQ.BORGID = USERSINBORGP.BORGID and USERSINBORGP.USERID = @userid where REQ.REQID = @theID
  END
  if @proc <> 'REQ' 
  BEGIN
    select @thisUserRoleID = ISADMIN FROM USERS WHERE USERS.USERID = @userid
  END

  set @wfValueApproved = 0
  set @apprDescr = 'Manual Escalate Workflow'
  set @wfStatus = 0
  set @emailTo = null
  set @emailSub = null
  set @emailDetail = null
  
  create table #tempB (BORGID int)
  
  if @proc = 'REQ' BEGIN
   set @wfValueApproved = (SELECT WFVALUEAPPROVED FROM REQ WHERE REQID = @theID)
   insert into #tempB (BORGID) select distinct TBORGID from REQITEMS where REQID = @theID
  END

  if @proc = 'JNL' BEGIN
   set @wfValueApproved = (SELECT WFVALUEAPPROVED FROM JOURNALHEADER WHERE JNLHEADID = @theID)
   insert into #tempB (BORGID) select distinct case when isnull(J.JNLTOORG, -1) = -1 then JH.BorgID else J.JNLTOORG end from JOURNALS J inner join JOURNALHEADER JH on J.JnlHeadID = JH.JnlHeadID where JH.JNLHEADID = @theID
  END
  
  if @proc = 'SCI' BEGIN
   select @apprDescr = @apprDescr + ' Valuation Number: ' + cast(SUBCRECONS.VALNO as nvarchar(10)) FROM SUBCRECONS WHERE RECONID = @theID
   set @wfValueApproved = (SELECT WFVALUEAPPROVED FROM SUBCRECONS WHERE RECONID = @theID)
   insert into #tempB (BORGID) select P.BORGID from SUBCRECONS SCR LEFT OUTER JOIN CONTRACTS C on C.CONTRID = SCR.CONTRACT LEFT OUTER JOIN PROJECTS P ON C.PROJID = P.PROJID where SCR.RECONID = @theID
  END
  
  if @proc = 'DTI' BEGIN
   select @apprDescr = @apprDescr + ' Valuation Number: ' + cast(DEBTRECONS.VALNO as nvarchar(10)) FROM DEBTRECONS WHERE RECONID = @theID
   set @wfValueApproved = (SELECT WFVALUEAPPROVED FROM DEBTRECONS WHERE RECONID = @theID)
   insert into #tempB (BORGID) select P.BORGID from DEBTRECONS DTR LEFT OUTER JOIN CONTRACTS C on C.CONTRID = DTR.CONTRACT LEFT OUTER JOIN PROJECTS P ON C.PROJID = P.PROJID where DTR.RECONID = @theID
  END
  
  if @proc = 'PRLCC' BEGIN
   insert into #tempB (BORGID)
   select distinct isnull(PROJ.BORGID, isnull(D.BORGID, isnull(P.BORGID, PR.BORGID)))
   from CCBATCHHEADER CCH
   INNER JOIN CCBATCHDETAIL CCD ON CCH.HeaderID = CCD.HeaderID
   INNER JOIN PAYROLLS PR ON PR.PAYROLLID = CCH.PAYROLLID AND PR.ENABLEWORKFLOWCC = 1
   LEFT OUTER JOIN LEDGERCODES L on L.LedgerCode = CCD.LEDGERCODE
   LEFT OUTER JOIN CONTRACTS C on C.CONTRNUMBER = CCD.COSTALLOCATION and L.LEDGERALLOC = 'Contracts'
   LEFT OUTER JOIN PROJECTS PROJ on PROJ.PROJID = C.PROJID and L.LEDGERALLOC = 'Contracts'
   LEFT OUTER JOIN PLANTANDEQ P on P.PENUMBER = CCD.COSTALLOCATION and L.LEDGERALLOC = 'Plant'
   LEFT OUTER JOIN DIVISIONS D on D.DIVID = case when isnumeric(rtrim(CCD.COSTALLOCATION) + '.0') = 1 then CCD.COSTALLOCATION else '-1' end and L.LEDGERALLOC = 'Overheads'
   WHERE CCH.HEADERID = @theID
  END
  
  if @proc = 'PRLAA' BEGIN
   insert into #tempB (BORGID)
   select distinct isnull(PROJ.BORGID, isnull(D.BORGID, isnull(P.BORGID, PR.BORGID)))
   from AABATCHHEADER AAH
   INNER JOIN AABATCHDETAIL AAD ON AAH.HeaderID = AAD.HeaderID
   INNER JOIN PAYROLLS PR ON PR.PAYROLLID = AAH.PAYROLLID AND PR.ENABLEWORKFLOWAA = 1
   LEFT OUTER JOIN LEDGERCODES L on L.LedgerCode = AAD.LEDGERCODE
   LEFT OUTER JOIN CONTRACTS C on C.CONTRNUMBER = AAD.COSTALLOCATION and L.LEDGERALLOC = 'Contracts'
   LEFT OUTER JOIN PROJECTS PROJ on PROJ.PROJID = C.PROJID and L.LEDGERALLOC = 'Contracts'
   LEFT OUTER JOIN PLANTANDEQ P on P.PENUMBER = AAD.COSTALLOCATION and L.LEDGERALLOC = 'Plant'
   LEFT OUTER JOIN DIVISIONS D on D.DIVID = case when isnumeric(rtrim(AAD.COSTALLOCATION) + '.0') = 1 then AAD.COSTALLOCATION else '-1' end and L.LEDGERALLOC = 'Overheads'
   WHERE AAH.HEADERID = @theID
  END
  
  if @proc = 'PRLSD' BEGIN
   insert into #tempB (BORGID)
   select distinct PR.BORGID
   from SDBATCHHEADER SDH
   INNER JOIN PAYROLLS PR ON PR.PAYROLLID = SDH.PAYROLLID AND PR.ENABLEWORKFLOWSD = 1
   WHERE SDH.HEADERID = @theID
  END
  
  if @proc = 'PRLLD' BEGIN
   insert into #tempB (BORGID)
   select distinct PR.BORGID
   from LDBATCHHEADER LDH
   INNER JOIN PAYROLLS PR ON PR.PAYROLLID = LDH.PAYROLLID AND PR.ENABLEWORKFLOWLD = 1
   WHERE LDH.HEADERID = @theID
  END
  
  
  /*select all workflow lines currently on workflow status this user can escalate*/
  select WORKFLOWSTATUS.WDID, WORKFLOWDETAIL.SEQ, WORKFLOWHEADER.WHID
  into #temp
  FROM WORKFLOWSTATUS
  INNER JOIN WORKFLOWDETAIL on WORKFLOWSTATUS.WDID = WORKFLOWDETAIL.WDID
  INNER JOIN WORKFLOWHEADER on WORKFLOWHEADER.WHID = WORKFLOWDETAIL.WHID
  WHERE WORKFLOWSTATUS.[PROC] = @proc
  AND WORKFLOWSTATUS.THEID = @theID
  AND WORKFLOWDETAIL.SKIPCONDITION = -1
  ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.DESCR
  
  /*insert histories for what is being escalated*/
  if @proc = 'REQ' 
  BEGIN
    INSERT REQAPPROVALHIST (REQID, SEQ, USERID, REQSTATUSID, DESCRIPTION, WDID)
    SELECT @theID, isnull(@maxSeq, 0) + 1, @userid, 40, 'Manual Escalate Requisition Workflow', WDID
    from #temp
  END

  if @proc <> 'REQ' 
  BEGIN
    INSERT WORKFLOWHIST ([PROC], THEID, SEQ, USERID, DESCRIPTION, WDID, STATUSID)
    SELECT @proc, @theID, isnull(@maxSeq, 0) + 1, @userid, @apprDescr, WDID, 6
    from #temp
  END
  
  /*remove escalated workflow steps from workflow status*/
  DELETE FROM WORKFLOWSTATUS
  WHERE WDID in (select WDID from #temp)
  AND [PROC] = @proc
  AND THEID = @theID
  
  /*insert next workflow steps after max sequence */
  if NOT Exists(select * from WORKFLOWSTATUS where THEID = @theID and [PROC] = @proc)
  BEGIN
  	insert into WORKFLOWSTATUS (WDID, [PROC], THEID)
  	select WORKFLOWDETAIL.WDID, @proc, @theID
  	from WORKFLOWHEADER
  	INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
  	AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in ( select ID from getWorkflowProc(@theID, @proc, 'D'))))
  	WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
  	AND WORKFLOWDETAIL.SEQ = (
  		select min(SEQ)
  		from WORKFLOWHEADER
  		INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
  		AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in ( select ID from getWorkflowProc(@theID, @proc, 'D'))))
  		AND WORKFLOWDETAIL.SEQ > (select max(SEQ) FROM #temp)
  		WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
  	)
  	ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.WDID
  
   set @wfStatus = 1
  END
  
  /*if at end of workflow bring back last step*/
  if NOT Exists(select * from WORKFLOWSTATUS where THEID = @theID and [PROC] = @proc) and @wfValueApproved = 0
  BEGIN
  	insert into WORKFLOWSTATUS (WDID, [PROC], THEID)
  	select WORKFLOWDETAIL.WDID, @proc, @theID
  	from WORKFLOWHEADER
  	INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
  	AND (WORKFLOWDETAIL.SKIPCONDITION IN (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
  	WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
  	AND WORKFLOWDETAIL.SEQ = (
  		select min(SEQ)
  		from WORKFLOWHEADER
  		INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
  		AND (WORKFLOWDETAIL.SKIPCONDITION IN (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
  		AND WORKFLOWDETAIL.SEQ = (select max(SEQ) FROM #temp)
  		WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
  	)
  	ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.WDID
  
   set @wfStatus = 1
  END
  
  if @wfStatus = 1
  BEGIN
   IF (select count(WFS.THEID) COUNT
   from WORKFLOWSTATUS WFS
   INNER JOIN WORKFLOWDETAIL WFD on WFD.WDID = WFS.WDID
   INNER JOIN WORKFLOWHEADER WFH ON WFH.WHID = WFD.WHID
   WHERE WFH.SENDMAIL = 1
   AND WFS.THEID = @theID
   AND WFS.[PROC] = @proc
   AND rtrim(WFD.EMAILTO) <> '') = 0
   BEGIN
    set @wfStatus = 0
   END
  END
  
  drop table #temp
  drop table #tempB

  INSERT INTO LOG (LOGDATE,LOGACTION,LOGUSERID,PAYROLLID,LOGBORGID) 
  values (getDate(),'Manual Escalated Workflow Proc [' + @proc + '], ID = ' + cast(@theID as nvarchar(10)), @userid, -1, @orgid)
   
  if @wfStatus = 1
  BEGIN
    create table #tempM (USERID int, BORGID int, [NO] nvarchar(max), SHORTDESCR nvarchar(250) default (''), SUBJECT nvarchar(250) default (''), BORG nvarchar(max))

    if @proc = 'REQ' BEGIN insert into #tempM (USERID, BORGID, [NO], SHORTDESCR, SUBJECT, BORG) select USERID, REQ.BORGID, REQNUMBER, rtrim(REQ.SHORTDESCR), rtrim(REQ.REQSUBJECT), cast(BORGS.BORGID as nvarchar(10)) + ' - ' + rtrim(BORGS.BORGNAME) from REQ LEFT OUTER JOIN BORGS ON REQ.BORGID = BORGS.BORGID where REQID = @theID END
    if @proc = 'JNL' BEGIN insert into #tempM (USERID, BORGID, [NO], SHORTDESCR, BORG) select JNLUSERID, JOURNALHEADER.BORGID, 'JNL' + rtrim(JnlHeadTransRef), rtrim(JOURNALHEADER.JnlHeadDescription), cast(BORGS.BORGID as nvarchar(10)) + ' - ' + rtrim(BORGS.BORGNAME) from JOURNALHEADER LEFT OUTER JOIN BORGS ON JOURNALHEADER.BORGID = BORGS.BORGID where JNLHEADID = @theID END
    if @proc = 'PRLCC' BEGIN insert into #tempM (USERID, BORGID, [NO], BORG) select BATCHOWNER, P.BORGID, '', cast(P.PAYROLLID as nvarchar(10)) + ' - ' + rtrim(P.PAYROLLNAME) FROM CCBATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID END
    if @proc = 'PRLAA' BEGIN insert into #tempM (USERID, BORGID, [NO], BORG) select BATCHOWNER, P.BORGID, '', cast(P.PAYROLLID as nvarchar(10)) + ' - ' + rtrim(P.PAYROLLNAME) FROM AABATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID END
    if @proc = 'PRLSD' BEGIN insert into #tempM (USERID, BORGID, [NO], BORG) select -1 BATCHOWNER, P.BORGID, '', cast(P.PAYROLLID as nvarchar(10)) + ' - ' + rtrim(P.PAYROLLNAME) FROM SDBATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID END
    if @proc = 'PRLLD' BEGIN insert into #tempM (USERID, BORGID, [NO], BORG) select -1 BATCHOWNER, P.BORGID, '', cast(P.PAYROLLID as nvarchar(10)) + ' - ' + rtrim(P.PAYROLLNAME) FROM LDBATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID END
    if @proc = 'SCI' BEGIN insert into #tempM (USERID, BORGID, [NO], BORG) select USERS.USERID, SUBCRECONS.ORGID, 'Sub Contractor: ' + rtrim(isnull(SUBCONTRACTORS.SubNumber, '')) + ' - ' + rtrim(isnull(SUBCONTRACTORS.SubName, '')) + ', Contract: ' + rtrim(isnull(CONTRACTS.CONTRNUMBER, '')) + ' - ' + rtrim(isnull(CONTRACTS.CONTRNAME, '')), cast(BORGS.BORGID as nvarchar(10)) + ' - ' + rtrim(BORGS.BORGNAME) from SUBCRECONS INNER JOIN USERS ON USERS.LOGINID = SUBCRECONS.USERID LEFT OUTER JOIN BORGS ON SUBCRECONS.OrgID = BORGS.BORGID LEFT OUTER JOIN CONTRACTS ON SUBCRECONS.Contract = CONTRACTS.CONTRID LEFT OUTER JOIN SUBCONTRACTORS ON SUBCRECONS.SubConNumber = SUBCONTRACTORS.SUBID where SUBCRECONS.RECONID = @theID END
    if @proc = 'DTI' BEGIN insert into #tempM (USERID, BORGID, [NO], BORG) select USERS.USERID, DEBTRECONS.ORGID, 'Debtor: ' + rtrim(isnull(DEBTORS.DEBTNumber, '')) + ' - ' + rtrim(isnull(DEBTORS.DebtName, '')) + ', Contract: ' + rtrim(isnull(CONTRACTS.CONTRNUMBER, '')) + ' - ' + rtrim(isnull(CONTRACTS.CONTRNAME, '')), cast(BORGS.BORGID as nvarchar(10)) + ' - ' + rtrim(BORGS.BORGNAME) from DEBTRECONS INNER JOIN USERS ON USERS.LOGINID = DEBTRECONS.USERID LEFT OUTER JOIN BORGS ON DEBTRECONS.OrgID = BORGS.BORGID LEFT OUTER JOIN CONTRACTS ON DEBTRECONS.Contract = CONTRACTS.CONTRID LEFT OUTER JOIN DEBTORS ON DEBTRECONS.SubConNumber = DEBTORS.DEBTID where DEBTRECONS.RECONID = @theID END

    SELECT 
    @emailTo = COALESCE(@emailTo, '') + 
				    case when patindex('%' + case when WFD.EMAILTO in ('[User Email]', '[Approver Email]') then rtrim(isnull(users.EMAIL, '')) else rtrim(WFD.EMAILTO) end + '%', @emailTo) <> 0 
				    then '' 
				    else case when @emailTo is not null then '; ' else '' end + case when WFD.EMAILTO in ('[User Email]', '[Approver Email]') then rtrim(isnull(users.EMAIL, '')) else rtrim(WFD.EMAILTO) end 
				    end,
    @emailSub = replace(replace(replace(replace(rtrim(COALESCE(@emailSub, '') + 
				    case when patindex('%' + case when WFD.EMAILHEADER = '[Header Description]' then rtrim(WFH.DESCR) else rtrim(replace(replace(replace(replace(replace(WFD.EMAILHEADER, '[Header Description]', WFH.DESCR) COLLATE SQL_Latin1_General_CP1_CI_AS, '[NO]', TM.NO) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SHORTDESCR]', TM.SHORTDESCR) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SUBJECT]', TM.SUBJECT) COLLATE SQL_Latin1_General_CP1_CI_AS, '[ORG]', TM.BORG)) end + '%', @emailSub) <> 0
				    then ''
				    else case when @emailSub is not null then ', ' else '' end + case when WFD.EMAILHEADER = '[Header Description]' then rtrim(WFH.DESCR) else rtrim(replace(WFD.EMAILHEADER, '[Header Description]', WFH.DESCR)) end
				    end
				    ) COLLATE SQL_Latin1_General_CP1_CI_AS, '[NO]', TM.NO) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SHORTDESCR]', TM.SHORTDESCR) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SUBJECT]', TM.SUBJECT) COLLATE SQL_Latin1_General_CP1_CI_AS, '[ORG]', TM.BORG),
    @emailDetail = replace(replace(replace(replace(rtrim(COALESCE(@emailDetail, '') + 
				    case when patindex('%' + case when WFD.EMAILDETAIL = '[Header Description]' then rtrim(WFH.DESCR) else rtrim(replace(replace(replace(replace(replace(WFD.EMAILDETAIL, '[Header Description]', WFH.DESCR) COLLATE SQL_Latin1_General_CP1_CI_AS, '[NO]', TM.NO) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SHORTDESCR]', TM.SHORTDESCR) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SUBJECT]', TM.SUBJECT) COLLATE SQL_Latin1_General_CP1_CI_AS, '[ORG]', TM.BORG)) end + '%', @emailDetail) <> 0
				    then ''
				    else case when @emailDetail is not null then ', ' else '' end + case when WFD.EMAILDETAIL = '[Header Description]' then rtrim(WFH.DESCR) else rtrim(replace(WFD.EMAILDETAIL, '[Header Description]', WFH.DESCR)) end
				    end
				    ) COLLATE SQL_Latin1_General_CP1_CI_AS, '[NO]', TM.NO) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SHORTDESCR]', TM.SHORTDESCR) COLLATE SQL_Latin1_General_CP1_CI_AS, '[SUBJECT]', TM.SUBJECT) COLLATE SQL_Latin1_General_CP1_CI_AS, '[ORG]', TM.BORG)
    FROM #tempM TM
    INNER JOIN WORKFLOWSTATUS WFS ON WFS.[PROC] = @proc AND WFS.THEID = @theID
    INNER JOIN WORKFLOWDETAIL WFD ON WFS.WDID = WFD.WDID
    INNER JOIN WORKFLOWHEADER WFH ON WFH.WHID = WFD.WHID
    LEFT OUTER JOIN USERS USERSOOO on (case when WFD.USERID = 0 then TM.USERID else WFD.USERID end) = USERSOOO.USERID and @proc <> 'REQ'
    LEFT OUTER JOIN USERS USERS1 on (case when WFD.USERID = 0 then TM.USERID else WFD.USERID end) = USERS1.USERID AND USERS1.OUTOFOFFICE = 0 and @proc <> 'REQ'
    LEFT OUTER JOIN USERS USERS2 on (case when WFD.USERID2 = 0 then TM.USERID else WFD.USERID2 end) = USERS2.USERID AND USERSOOO.OUTOFOFFICE = 1 and @proc <> 'REQ'
    LEFT OUTER JOIN USERS USERROLE on USERROLE.ISADMIN = WFD.ROLEID and USERS1.USERID IS NULL AND USERS2.USERID IS NULL and WFD.ROLEID <> -1 and @proc <> 'REQ'
    LEFT OUTER JOIN USERSINBORGP USERSINBORGPOOO on (case when WFD.USERID = 0 then TM.USERID else WFD.USERID end) = USERSINBORGPOOO.USERID AND TM.BORGID = USERSINBORGPOOO.BORGID and @proc = 'REQ'
    LEFT OUTER JOIN USERSINBORGP on (case when WFD.USERID = 0 then TM.USERID else WFD.USERID end) = USERSINBORGP.USERID AND TM.BORGID = USERSINBORGP.BORGID AND USERSINBORGP.OUTOFOFFICE = 0 and @proc = 'REQ'
    LEFT OUTER JOIN USERSINBORGP USERSINBORGP2 on (case when WFD.USERID2 = 0 then TM.USERID else WFD.USERID2 end) = USERSINBORGP2.USERID AND TM.BORGID = USERSINBORGP2.BORGID AND USERSINBORGPOOO.OUTOFOFFICE = 1 and @proc = 'REQ'
    LEFT OUTER JOIN USERSINBORGP USERROLEP on USERROLEP.ROLEID = WFD.ROLEID and USERROLEP.BORGID = TM.BorgID and USERSINBORGP.USERID IS NULL AND USERSINBORGP2.USERID IS NULL and WFD.ROLEID <> -1 and @proc = 'REQ'
    LEFT OUTER JOIN USERS USEROWNER ON TM.USERID = USEROWNER.USERID and WFD.EMAILTO = '[User Email]'
    LEFT OUTER JOIN USERS on USERS.USERID = isnull(USEROWNER.USERID, isnull(USERS1.USERID, isnull(USERS2.USERID, isnull(USERSINBORGP.USERID, isnull(USERSINBORGP2.USERID, ISNULL(USERROLE.USERID, USERROLEP.USERID))))))
    WHERE WFS.[PROC] = @proc
    AND WFS.THEID = @theID
    AND rtrim(isnull(WFD.EMAILTO, '')) <> ''

    drop table #tempM
  END

  Select 'ESCALATEWF' DESCR, 'OK' STATUS, @wfStatus WFSTATUS, @emailTo EMAILS, @emailSub [SUBJECT], case when isnull(@emailDetail, '') = '' then @emailSub else @emailDetail end [DETAIL]

	RETURN
END
		
		