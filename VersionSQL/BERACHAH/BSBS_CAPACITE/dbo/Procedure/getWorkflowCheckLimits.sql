/****** Object:  Procedure [dbo].[getWorkflowCheckLimits]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 05-27-2016
-- Description:	Initiates and moves the workflow through the approval steps, and returns details for notification emails
-- NOTES:
-- 2017-09-01 Matthew : Added the WORKFLOWHEADER.PREAPPROVAL field and use it to check against the HISTORY tables to skip any preapprovals done
--  
-- =============================================
CREATE PROCEDURE getWorkflowCheckLimits (@theID INT, @proc nvarchar(10), @userid INT, @apprDescr nvarchar(max), @orgid INT)
  
AS
BEGIN
  declare @maxSeq int 
  declare @wfValueApproved bit
  declare @wfValueApprovedOrig bit
  declare @headerUserid int
  declare @headerOrgid int  

  declare @approvalRequired int
  declare @useWF bit
  declare @roleID int
  declare @hasError bit
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
  set @wfValueApprovedOrig = 0
  set @headerUserid = -1
  set @headerOrgid = -1

  set @hasError = 0
  set @useWF = 0
  set @wfStatus = 0
  set @emailTo = null
  set @emailSub = null
  set @emailDetail = null

  create table #tempB (BORGID int)
  create table #tempA (AMOUNT DECIMAL(24, 4), THEID int)

  if @proc = 'REQ' BEGIN
    select @wfValueApprovedOrig = WFVALUEAPPROVED, @headerUserid = USERID, @headerOrgid = BORGID FROM REQ WHERE REQID = @theID
    insert into #tempB (BORGID) select distinct TBORGID from REQITEMS where REQID = @theID
    insert into #tempA (AMOUNT, THEID) select ((QTY * PRICE * EXCHRATE) - (QTY * PRICE * EXCHRATE * DISCOUNT / 100)) + (VATAMOUNT * EXCHRATE), REQ.REQID FROM REQITEMS inner join REQ on REQ.REQID = REQITEMS.REQID WHERE REQITEMS.REQID = @theID
  END

  if @proc = 'JNL' BEGIN
    select @wfValueApprovedOrig = WFVALUEAPPROVED, @headerUserid = JNLUSERID, @headerOrgid = BORGID FROM JOURNALHEADER WHERE JNLHEADID = @theID
    insert into #tempB (BORGID) select distinct case when isnull(J.JNLTOORG, -1) = -1 then JH.BorgID else J.JNLTOORG end from JOURNALS J inner join JOURNALHEADER JH on J.JnlHeadID = JH.JnlHeadID where JH.JNLHEADID = @theID
    insert into #tempA (AMOUNT, THEID) select case when JnlExchRate <> 1 and JnlExchRate <> 0 then JnlHomeCurrency else JnlDebit end, JNLHEADID FROM JOURNALS WHERE JNLHEADID = @theID and JNLCREDIT = 0
  END

  if @proc = 'PRLCC' BEGIN
    select @wfValueApprovedOrig = 1, @headerUserid = BATCHOWNER, @headerOrgid = P.BORGID FROM CCBATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID
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
    insert into #tempA (AMOUNT, THEID) select 0, @theID
  END

  if @proc = 'PRLAA' BEGIN
    select @wfValueApprovedOrig = 1, @headerUserid = BATCHOWNER, @headerOrgid = P.BORGID FROM AABATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID
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
    insert into #tempA (AMOUNT, THEID) select 0, @theID
  END

  if @proc = 'PRLSD' BEGIN
    select @wfValueApprovedOrig = 1, @headerUserid = -1, @headerOrgid = P.BORGID FROM SDBATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID
    insert into #tempB (BORGID)
        select distinct PR.BORGID
        from SDBATCHHEADER SDH
        INNER JOIN PAYROLLS PR ON PR.PAYROLLID = SDH.PAYROLLID AND PR.ENABLEWORKFLOWSD = 1
        WHERE SDH.HEADERID = @theID
    insert into #tempA (AMOUNT, THEID) select 0, @theID
  END

  if @proc = 'PRLLD' BEGIN
    select @wfValueApprovedOrig = 1, @headerUserid = -1, @headerOrgid = P.BORGID FROM LDBATCHHEADER H INNER JOIN PAYROLLS P ON H.PAYROLLID = P.PAYROLLID WHERE H.HEADERID = @theID
    insert into #tempB (BORGID)
        select distinct PR.BORGID
        from LDBATCHHEADER LDH
        INNER JOIN PAYROLLS PR ON PR.PAYROLLID = LDH.PAYROLLID AND PR.ENABLEWORKFLOWLD = 1
        WHERE LDH.HEADERID = @theID
    insert into #tempA (AMOUNT, THEID) select 0, @theID
  END

  if @proc = 'SCI' BEGIN
    select @wfValueApprovedOrig = WFVALUEAPPROVED, @headerUserid = USERS.USERID, @headerOrgid = SCR.ORGID, @apprDescr = @apprDescr + ' Valuation Number: ' + cast(SCR.VALNO as nvarchar(10)) FROM SUBCRECONS SCR LEFT OUTER JOIN CONTRACTS C on C.CONTRID = SCR.CONTRACT LEFT OUTER JOIN PROJECTS P ON C.PROJID = P.PROJID INNER JOIN USERS ON USERS.LOGINID = SCR.USERID where SCR.RECONID = @theID
    insert into #tempB (BORGID) select P.BORGID from SUBCRECONS SCR LEFT OUTER JOIN CONTRACTS C on C.CONTRID = SCR.CONTRACT LEFT OUTER JOIN PROJECTS P ON C.PROJID = P.PROJID where SCR.RECONID = @theID
    insert into #tempA (AMOUNT, THEID) select case when SUBCRECONS.EXCHRATE <> 1 and SUBCRECONS.EXCHRATE <> 0 then SUBCRECONS.PAID * SUBCRECONS.EXCHRATE else SUBCRECONS.PAID end, RECONID FROM SUBCRECONS WHERE RECONID = @theID
  END

  if @proc = 'DTI' BEGIN
    select @wfValueApprovedOrig = WFVALUEAPPROVED, @headerUserid = USERS.USERID, @headerOrgid = DTR.ORGID, @apprDescr = @apprDescr + ' Valuation Number: ' + cast(DTR.VALNO as nvarchar(10)) FROM DEBTRECONS DTR LEFT OUTER JOIN CONTRACTS C on C.CONTRID = DTR.CONTRACT LEFT OUTER JOIN PROJECTS P ON C.PROJID = P.PROJID INNER JOIN USERS ON USERS.LOGINID = DTR.USERID where DTR.RECONID = @theID
    insert into #tempB (BORGID) select P.BORGID from DEBTRECONS DTR LEFT OUTER JOIN CONTRACTS C on C.CONTRID = DTR.CONTRACT LEFT OUTER JOIN PROJECTS P ON C.PROJID = P.PROJID where DTR.RECONID = @theID
    insert into #tempA (AMOUNT, THEID) select case when DEBTRECONS.EXCHRATE <> 1 and DEBTRECONS.EXCHRATE <> 0 then DEBTRECONS.PAID * DEBTRECONS.EXCHRATE else DEBTRECONS.PAID end, RECONID FROM DEBTRECONS WHERE RECONID = @theID
  END
    

  if (SELECT USEWORKFLOW FROM BORGS WHERE BORGID = @headerOrgid) = 1
  BEGIN
    if (select ID from getWorkflowProc(@theID, @proc, 'H')) <> -1
    BEGIN
    	set @useWF = 1
    END
  END

  /*
  SPENDINGLIMIT = Total Requisition Approval Limit
  APPROVALLIMIT = Line Item Approval Limit
  */

  BEGIN TRANSACTION

  if @hasError = 0
  BEGIN
    if @useWF = 0
    BEGIN
      set @approvalRequired = 0
    END
    ELSE
    BEGIN
      if Exists(select * from WORKFLOWSTATUS where THEID = @theID and [PROC] = @proc)
      BEGIN
        /*get roleid of current user*/
        if @proc = 'REQ' 
        BEGIN
          select @roleID = USERSINBORGP.ROLEID
          from USERSINBORGP
          INNER JOIN REQ on USERSINBORGP.BORGID = REQ.BORGID
          WHERE REQ.REQID = @theID
          AND USERSINBORGP.USERID = @userid
        END

        if @proc <> 'REQ' 
        BEGIN
          select @roleID = ISADMIN FROM USERS WHERE USERS.USERID = @userid 
        END

    
        /*select all workflow lines currently on workflow status this user can complete*/
     	  select WORKFLOWSTATUS.WDID, WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.LINELIMIT, WORKFLOWDETAIL.APPROVALLIMIT, WORKFLOWHEADER.WHID
     	  into #temp
     	  FROM WORKFLOWSTATUS
     	  INNER JOIN WORKFLOWDETAIL on WORKFLOWSTATUS.WDID = WORKFLOWDETAIL.WDID
     	  INNER JOIN WORKFLOWHEADER on WORKFLOWHEADER.WHID = WORKFLOWDETAIL.WHID 
     	  LEFT OUTER JOIN USERS on USERS.USERID = (case when WORKFLOWDETAIL.USERID = 0 then @headerUserid else WORKFLOWDETAIL.USERID end) AND USERS.OUTOFOFFICE = 1 and @proc <> 'REQ'
		    LEFT OUTER JOIN USERSINBORGP on USERSINBORGP.USERID = (case when WORKFLOWDETAIL.USERID = 0 then @headerUserid else WORKFLOWDETAIL.USERID end) AND USERSINBORGP.OUTOFOFFICE = 1 and USERSINBORGP.BORGID = @orgid and @proc = 'REQ'
     	  WHERE WORKFLOWSTATUS.[PROC] = @proc
     	  AND WORKFLOWSTATUS.THEID = @theID
     	  AND (
     		  (case when WORKFLOWDETAIL.USERID = 0 then @headerUserid else WORKFLOWDETAIL.USERID end) = @userid
     		  OR WORKFLOWDETAIL.ROLEID = @roleID
     		  OR (ISNULL(ISNULL(USERS.USERID, USERSINBORGP.USERID), -2) = (case when WORKFLOWDETAIL.USERID = 0 then @headerUserid else WORKFLOWDETAIL.USERID end) and (case when WORKFLOWDETAIL.USERID2 = 0 then @headerUserid else WORKFLOWDETAIL.USERID2 end) = @userid)
     	  )
     	  ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.DESCR

     	  select @approvalRequired = count(*), @wfValueApproved = case when count(*) = 0 then 1 else 0 end
     	  FROM (
          /*first check line item by line item*/
     		  select ABS(#tempA.AMOUNT) as AMOUNT,
     		  IsNull(WORKFLOWDETAIL.LINELIMIT, -1) AS LINELIMIT
     		  From #tempA
     		  inner join WORKFLOWSTATUS on WORKFLOWSTATUS.[PROC] = @proc AND WORKFLOWSTATUS.THEID = #tempA.THEID
     		  INNER JOIN WORKFLOWDETAIL on WORKFLOWSTATUS.WDID = WORKFLOWDETAIL.WDID
     		  Where #tempA.THEID = @theID

     		  Union All
          /*then check total approval amount*/
     		  select Sum(ABS(case when #tempA.AMOUNT > 0 then #tempA.AMOUNT else 0 end)) as AMOUNT,
     		  IsNull(WORKFLOWDETAIL.APPROVALLIMIT, -1) AS APPROVALLIMIT
     		  From #tempA
     		  inner join WORKFLOWSTATUS on WORKFLOWSTATUS.[PROC] = @proc AND WORKFLOWSTATUS.THEID = #tempA.THEID
     		  INNER JOIN WORKFLOWDETAIL on WORKFLOWSTATUS.WDID = WORKFLOWDETAIL.WDID
     		  Where #tempA.THEID = @theID
     		  group by WORKFLOWDETAIL.APPROVALLIMIT
     	  ) TEMP
     	  WHERE TEMP.AMOUNT > TEMP.LINELIMIT

        /*update WFVALUEAPPROVED if @wfValueApproved set and value approved was not set before*/
     	  IF (@wfValueApproved = 1 and @wfValueApprovedOrig = 0)
     	  BEGIN
            if @proc = 'REQ' BEGIN
                UPDATE REQ set WFVALUEAPPROVED = @wfValueApproved WHERE REQID = @theID
            END
     		    if @proc = 'JNL' BEGIN
     		        UPDATE JOURNALHEADER set WFVALUEAPPROVED = @wfValueApproved WHERE JNLHEADID = @theID
     		    END
     		    if @proc = 'SCI' BEGIN
     		        UPDATE SUBCRECONS set WFVALUEAPPROVED = @wfValueApproved WHERE RECONID = @theID
     		    END
     		    if @proc = 'DTI' BEGIN
     		        UPDATE DEBTRECONS set WFVALUEAPPROVED = @wfValueApproved WHERE RECONID = @theID
     		    END
     	  END   
    
        /*insert wf histories for what is being completed*/
        if @proc = 'REQ' 
        BEGIN
          INSERT REQAPPROVALHIST (REQID, SEQ, USERID, REQSTATUSID, DESCRIPTION, WDID, WFVALUEAPPROVED)
          SELECT @theID, isnull(@maxSeq, 0) + 1, @userid, 26, @apprDescr, WDID, @wfValueApproved
          from #temp
        END
        if @proc <> 'REQ' 
        BEGIN
     	    INSERT WORKFLOWHIST ([PROC], THEID, SEQ, USERID, DESCRIPTION, WDID, STATUSID, WFVALUEAPPROVED)
     	    SELECT @proc, @theID, isnull(@maxSeq, 0) + 1, @userid, @apprDescr, WDID, 1, case when @wfValueApprovedOrig = 0 then @wfValueApproved else 0 end
     	    from #temp
        END

        /*remove completed workflow steps from workflow status*/
     	  DELETE FROM WORKFLOWSTATUS
     	  WHERE WDID in (select WDID from #temp)
     	  AND [PROC] = @proc
     	  AND THEID = @theID

        /*insert next workflow steps after max sequence
        if approval limits meet only insert force steps and skip conditions matching borg
        */
     	  if NOT Exists(select * from WORKFLOWSTATUS where THEID = @theID and [PROC] = @proc)
     	  BEGIN
     		  insert into WORKFLOWSTATUS (WDID, [PROC], THEID)
     		  select WORKFLOWDETAIL.WDID, @proc, @theID
     		  from WORKFLOWHEADER
     		  INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
     		  AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
     		  AND WORKFLOWDETAIL.SKIPCONDITION = case when @approvalRequired > 0 then WORKFLOWDETAIL.SKIPCONDITION else case when WORKFLOWDETAIL.SKIPCONDITION = -1 then -10 else WORKFLOWDETAIL.SKIPCONDITION end end
     		  WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
     		  AND WORKFLOWDETAIL.SEQ = (
     			  select min(SEQ)
     			  from WORKFLOWHEADER
     			  INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
     			  AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
     			  AND WORKFLOWDETAIL.SEQ > (select max(SEQ) FROM #temp)
     			  AND WORKFLOWDETAIL.SKIPCONDITION = case when @approvalRequired > 0 then WORKFLOWDETAIL.SKIPCONDITION else case when WORKFLOWDETAIL.SKIPCONDITION = -1 then -10 else WORKFLOWDETAIL.SKIPCONDITION end end
     			  WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
     		  )
     		  ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.WDID
    
          set @wfStatus = 1
        END

        /*if at end of workflow and master not Value Approved bring back last step*/
     	  if NOT Exists(select * from WORKFLOWSTATUS where THEID = @theID and [PROC] = @proc) and @wfValueApproved = 0 and @wfValueApprovedOrig = 0
     	  BEGIN
     		  insert into WORKFLOWSTATUS (WDID, [PROC], THEID)
     		  select WORKFLOWDETAIL.WDID, @proc, @theID
     		  from WORKFLOWHEADER
     		  INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID 
     		  AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
     		  AND WORKFLOWDETAIL.SKIPCONDITION = case when @approvalRequired > 0 then WORKFLOWDETAIL.SKIPCONDITION else case when WORKFLOWDETAIL.SKIPCONDITION = -1 then -10 else WORKFLOWDETAIL.SKIPCONDITION end end
     		  WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
     		  AND WORKFLOWDETAIL.SEQ = (
     			  select min(SEQ)
     			  from WORKFLOWHEADER
     			  INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
     			  AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
     			  AND WORKFLOWDETAIL.SEQ = (select max(SEQ) FROM #temp)
     			    AND WORKFLOWDETAIL.SKIPCONDITION = case when @approvalRequired > 0 then WORKFLOWDETAIL.SKIPCONDITION else case when WORKFLOWDETAIL.SKIPCONDITION = -1 then -10 else WORKFLOWDETAIL.SKIPCONDITION end end
     			  WHERE WORKFLOWHEADER.WHID in (select WHID from #temp)
     		  )
     		  ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.WDID

          set @wfStatus = 1
     	  END

     	  drop table #temp
      END
      ELSE
      BEGIN
        /*when no workflowstatus is present and a workflow exists, insert the first step into the workflowstatus*/
     	  insert into WORKFLOWSTATUS (WDID, [PROC], THEID)
     	  select WORKFLOWDETAIL.WDID, @proc, @theID
     	  from WORKFLOWHEADER
     	  INNER JOIN getWorkflowProc(@theID, @proc, 'H') G on G.ID = WORKFLOWHEADER.WHID
     	  INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
     	  AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
     	  WHERE  WORKFLOWDETAIL.SEQ = (
     		  select min(WORKFLOWDETAIL.SEQ)
     		  from WORKFLOWHEADER
     		  INNER JOIN getWorkflowProc(@theID, @proc, 'H') G on G.ID = WORKFLOWHEADER.WHID
     		  INNER JOIN WORKFLOWDETAIL on WORKFLOWDETAIL.WHID = WORKFLOWHEADER.WHID
     		  AND (WORKFLOWDETAIL.SKIPCONDITION in (-1, 0) or WORKFLOWDETAIL.SKIPCONDITION IN (select BORGID from #tempB) OR (@wfValueApproved = 0 and WORKFLOWDETAIL.SKIPCONDITION in (-2, -3) AND WORKFLOWDETAIL.WDID in (select ID from getWorkflowProc(@theID, @proc, 'D'))))
              OUTER APPLY (SELECT top 1 WD.SEQ 
							FROM WORKFLOWHEADER WH 
							INNER JOIN WORKFLOWDETAIL WD on WD.WHID = WH.WHID AND WD.WDID = WH.PREAPPROVAL
							LEFT OUTER JOIN REQAPPROVALHIST RAH on WD.WDID = RAH.WDID and REQID = @theID and @proc = 'REQ'
							LEFT OUTER JOIN WORKFLOWHIST WAH on WD.WDID = WAH.WDID and THEID = @theID and @proc <> 'REQ'
							WHERE WH.WHID = WORKFLOWHEADER.WHID
							AND WH.PREAPPROVAL <> -1
							AND (WD.WDID = RAH.WDID OR WD.WDID = WAH.WDID)
			  ) PREAPP
              WHERE WORKFLOWDETAIL.SEQ > isnull(PREAPP.SEQ, -1)
     	  )
     	  ORDER BY WORKFLOWDETAIL.SEQ, WORKFLOWDETAIL.WDID

        if @proc <> 'REQ' 
        BEGIN
     	    INSERT WORKFLOWHIST ([PROC], THEID, SEQ, USERID, DESCRIPTION, WDID, STATUSID, WFVALUEAPPROVED)
     	    SELECT @proc, @theID, isnull(@maxSeq, 0) + 1, @userid, @apprDescr, -1, 4, 0
        END

        set @wfStatus = 1
      END

    /*count approval steps*/
    select @approvalRequired = count(*) from WORKFLOWSTATUS where THEID = @theID and [PROC] = @proc
    END
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


  if @@ERROR = 0 and @hasError = 0
  begin
  
    if @@ERROR = 0
    begin
    	COMMIT TRANSACTION
      /*return true if can submit, false if needs approval first*/
    	if @approvalRequired = 0
    	BEGIN
    		select 'DoneOK', 'True', @wfStatus, @emailTo EMAILS, @emailSub [SUBJECT], case when isnull(@emailDetail, '') = '' then @emailSub else @emailDetail end [DETAIL]
    	END
    	ELSE
    	BEGIN
    		select 'DoneOK', 'False', @wfStatus, @emailTo EMAILS, @emailSub [SUBJECT], case when isnull(@emailDetail, '') = '' then @emailSub else @emailDetail end [DETAIL]
    	END
    END
    ELSE
    BEGIN
    	ROLLBACK TRANSACTION
    	select 'DB Error', @@error, 0
    END
   
  END
  ELSE
  BEGIN
    select 'APPROVAL', 'Error checking line item amounts against approval amounts !', 0
  END
 
  drop table #tempA
  drop table #tempB


	RETURN
END
		
		