/****** Object:  Function [dbo].[getWorkflowSteps]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Matthew Spiller
-- Create date: 05-27-2016
-- Description:	returns workflow Details associated with provided proccess ID and proc
-- NOTES:
--  
-- =============================================
CREATE FUNCTION getWorkflowSteps (@theID INT, @proc nvarchar(10), @userid INT)
    RETURNS @t TABLE (
      USERID INT, 
      ROLEID INT, 
      THISUSERROLEID INT, 
      DESCR nvarchar(500), 
      SKIPCONDITION INT, 
      CONFIRMMESSAGE nvarchar(max),
      WDID INT
		)
AS
BEGIN
  declare @thisUserRoleID int

  if @proc = 'REQ' 
  BEGIN
    select @thisUserRoleID = ROLEID FROM USERSINBORGP INNER JOIN REQ on REQ.BORGID = USERSINBORGP.BORGID and USERSINBORGP.USERID = @userid where REQ.REQID = @theID
  END
  if @proc <> 'REQ' 
  BEGIN
    select @thisUserRoleID = ISADMIN FROM USERS WHERE USERS.USERID = @userid
  END
 
  if @proc = 'REQ' 
  BEGIN
    insert into @t(USERID, ROLEID, THISUSERROLEID, DESCR, SKIPCONDITION, CONFIRMMESSAGE, WDID)
    select isnull(USERS.USERID, -1) USERID, 
    isnull(ROLEHEADERP.ROLEID, -1) ROLEID, 
    @thisUserRoleID ThisUserRoleID,
    'Seq ('+ cast(WORKFLOWDETAIL.SEQ as nvarchar(10)) +') - ' + rtrim(WORKFLOWDETAIL.DESCR)
	    + case when USERS.USERID is not null then ' [User: '+ rtrim(USERS.USERNAME) +']' else '' end
	    + case when ROLEHEADERP.ROLEID is not null then ' [Role: '+ rtrim(ROLEHEADERP.ROLENAME) +']' else '' end DESCR,
    WORKFLOWDETAIL.SKIPCONDITION,
    case when rtrim(isnull(WORKFLOWDETAIL.CONFIRMMESSAGE,'')) <> '' then rtrim(isnull(WORKFLOWDETAIL.DESCR,'')) + ':\n' end + rtrim(isnull(WORKFLOWDETAIL.CONFIRMMESSAGE,'')) CONFIRMMESSAGE,
    WORKFLOWSTATUS.WDID
    FROM REQ
    INNER JOIN WORKFLOWSTATUS ON WORKFLOWSTATUS.[PROC] = 'REQ' AND WORKFLOWSTATUS.THEID = REQ.REQID
    INNER JOIN WORKFLOWDETAIL ON WORKFLOWSTATUS.WDID = WORKFLOWDETAIL.WDID
    LEFT OUTER JOIN USERSINBORGP USERSINBORGPOOO on (case when WORKFLOWDETAIL.USERID = 0 then REQ.USERID else WORKFLOWDETAIL.USERID end) = USERSINBORGPOOO.USERID AND REQ.BORGID = USERSINBORGPOOO.BORGID
    LEFT OUTER JOIN USERSINBORGP on (case when WORKFLOWDETAIL.USERID = 0 then REQ.USERID else WORKFLOWDETAIL.USERID end) = USERSINBORGP.USERID AND REQ.BORGID = USERSINBORGP.BORGID AND USERSINBORGP.OUTOFOFFICE = 0
    LEFT OUTER JOIN USERSINBORGP USERSINBORGP2 on (case when WORKFLOWDETAIL.USERID2 = 0 then REQ.USERID else WORKFLOWDETAIL.USERID2 end) = USERSINBORGP2.USERID AND REQ.BORGID = USERSINBORGP2.BORGID AND USERSINBORGPOOO.OUTOFOFFICE = 1
    LEFT OUTER JOIN USERS on USERS.USERID = isnull(USERSINBORGP.USERID, USERSINBORGP2.USERID)
    LEFT OUTER JOIN ROLEHEADERP ON WORKFLOWDETAIL.ROLEID = ROLEHEADERP.ROLEID
    WHERE REQ.REQID = @theID
  END
  ELSE
  BEGIN
    insert into @t(USERID, ROLEID, THISUSERROLEID, DESCR, SKIPCONDITION, CONFIRMMESSAGE, WDID)
    select isnull(USERS.USERID, -1) USERID, 
    isnull(ROLEHEADER.ROLEHEADERID, -1) ROLEID, 
    @thisUserRoleID ThisUserRoleID,
    'Seq ('+ cast(WORKFLOWDETAIL.SEQ as nvarchar(10)) +') - ' + rtrim(WORKFLOWDETAIL.DESCR)
	      + case when USERS.USERID is not null then ' [User: '+ rtrim(USERS.USERNAME) +']' else '' end
	      + case when ROLEHEADER.ROLEHEADERID is not null then ' [Role: '+ rtrim(ROLEHEADER.ROLENAME) +']' else '' end DESCR,
    WORKFLOWDETAIL.SKIPCONDITION + case when isnull(WD.NUM, 0) = 0 then 10 else 0 end SKIPCONDITION,
    case when rtrim(isnull(WORKFLOWDETAIL.CONFIRMMESSAGE,'')) <> '' then rtrim(isnull(WORKFLOWDETAIL.DESCR,'')) + ':\n' end + rtrim(isnull(WORKFLOWDETAIL.CONFIRMMESSAGE,'')) CONFIRMMESSAGE,
    WORKFLOWSTATUS.WDID
    FROM (
	    select JNLUSERID USERID from JOURNALHEADER where JNLHEADID = @theID and @proc = 'JNL'  
	    UNION ALL
	    select BATCHOWNER USERID FROM CCBATCHHEADER H WHERE H.HEADERID = @theID and @proc = 'PRLCC'
	    UNION ALL
	    select BATCHOWNER USERID FROM AABATCHHEADER H WHERE H.HEADERID = @theID and @proc = 'PRLAA'
	    UNION ALL
	    select -1 USERID FROM SDBATCHHEADER H WHERE H.HEADERID = @theID and @proc = 'PRLSD'
	    UNION ALL
	    select -1 USERID FROM LDBATCHHEADER H WHERE H.HEADERID = @theID and @proc = 'PRLLD'
	    UNION ALL
	    select USERS.USERID USERID from SUBCRECONS INNER JOIN USERS ON USERS.LOGINID = SUBCRECONS.USERID where SUBCRECONS.RECONID = @theID and @proc = 'SCI'  
	    UNION ALL
	    select USERS.USERID USERID from DEBTRECONS INNER JOIN USERS ON USERS.LOGINID = DEBTRECONS.USERID where DEBTRECONS.RECONID = @theID and @proc = 'DTI'  
    ) TM
    INNER JOIN WORKFLOWSTATUS ON WORKFLOWSTATUS.[PROC] = @proc AND WORKFLOWSTATUS.THEID = @theID
    INNER JOIN WORKFLOWDETAIL ON WORKFLOWSTATUS.WDID = WORKFLOWDETAIL.WDID
    LEFT OUTER JOIN USERS USERSOOO on (case when WORKFLOWDETAIL.USERID = 0 then TM.USERID else WORKFLOWDETAIL.USERID end) = USERSOOO.USERID
    LEFT OUTER JOIN USERS USERS1 on (case when WORKFLOWDETAIL.USERID = 0 then TM.USERID else WORKFLOWDETAIL.USERID end) = USERS1.USERID AND USERS1.OUTOFOFFICE = 0
    LEFT OUTER JOIN USERS USERS2 on (case when WORKFLOWDETAIL.USERID2 = 0 then TM.USERID else WORKFLOWDETAIL.USERID2 end) = USERS2.USERID AND USERSOOO.OUTOFOFFICE = 1
    LEFT OUTER JOIN USERS on USERS.USERID = isnull(USERS1.USERID, USERS2.USERID)
    LEFT OUTER JOIN ROLEHEADER ROLEHEADER ON WORKFLOWDETAIL.ROLEID = ROLEHEADER.ROLEHEADERID
    OUTER APPLY (select count(WD.WDID) NUM FROM WORKFLOWDETAIL WD WHERE WD.WHID = WORKFLOWDETAIL.WHID and WD.SEQ > WORKFLOWDETAIL.SEQ) WD
  END


  RETURN
END
		
		