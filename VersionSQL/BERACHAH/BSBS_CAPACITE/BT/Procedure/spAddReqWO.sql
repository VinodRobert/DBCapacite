/****** Object:  Procedure [BT].[spAddReqWO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BT].[spAddReqWO](@LOGINID VARCHAR(15),@PROJECTID INT,@LASTREQID INT OUTPUT) 

AS
 
DECLARE @REQUIREDBYDATE DATETIME 
DECLARE @BORGID INT
DECLARE @REQNUMPREFIX VARCHAR(25)
DECLARE @REQNUMSUFFIX VARCHAR(25)
DECLARE @REQSEPARATEDBY VARCHAR(1)
DECLARE @USERID INT 
DECLARE @REQSTATUSID INT
DECLARE @NEXTREQID INT
DECLARE @REQNUMBER VARCHAR(55)
DECLARE @SPACES VARCHAR(2)
DECLARE @LASTREQNUMBER INT 
DECLARE @REQSUBJECT VARCHAR(125)
DECLARE @REQSHORTDESC VARCHAR(255)
DECLARE @REQUIREDBYSTRING VARCHAR(15)
DECLARE @REQNOTES VARCHAR(250)

SELECT @BORGID=BORGID FROM BT.PROJECTS WHERE BSPROJECTID=@PROJECTID 
 
 
SET @SPACES = ' ' 
SET @REQSUBJECT='WEB REQUISITION'
SET @REQSHORTDESC = 'BMT'
SET @REQUIREDBYDATE = GETDATE()+5
SET @REQNOTES =@SPACES
SELECT @BORGID = BORGID FROM BT.PROJECTS WHERE PROJECTID=@PROJECTID

SELECT @REQNUMPREFIX=REQNUMPREFIX,@REQNUMSUFFIX=REQNUMSUFFIX,@REQSEPARATEDBY=REQSEPARATEDBY,@LASTREQNUMBER = LASTREQNUMBER  FROM BORGS WHERE BORGID=@BORGID

SELECT @USERID  = USERID FROM USERS WHERE LOGINID=@LOGINID 

 
SET @REQSTATUSID = 163


SELECT @NEXTREQID = @LASTREQNUMBER+1  
SET @REQNUMBER = LTRIM(RTRIM(@REQNUMPREFIX))+LTRIM(RTRIM(@REQSEPARATEDBY))+LTRIM(RTRIM(@NEXTREQID))+LTRIM(RTRIM(@REQSEPARATEDBY))+LTRIM(RTRIM(@REQNUMSUFFIX))
 


INSERT INTO [dbo].[REQ]
           ([BORGID]
           ,[REQNUMBER]
           ,[REQSUBJECT]
           ,[REQSTATUSID]
           ,[REQSTATUSDATE]
           ,[USERID]
           ,[CREATEDATE]
           ,[SUBMITIONDATE]
           ,[SHORTDESCR]
           ,[MIMETYPE]
           ,[FILESIZEINKB]
           ,[FILEPATH]
           ,[ORIGINALFILEPATH]
           ,[EID]
           ,[ATTMESSAGE]
           ,[SENDATTTOSUPP]
           ,[INVTOID]
           ,[LASTCHANGE]
           ,[LASTCHANGEBY]
           ,[REQUIREDBY]
           ,[CURRENCY]
           ,[INFO]
           ,[APPROVER]
           ,[ISEXTPO]
           ,[RECTYPE]
           ,[SCORDNUMBER]
           ,[FORCEAPPROVER]
           ,[HOMECURRENCY]
           ,[EXCHRATE]
           ,[ORIGUSERID]
           ,[PACKAGE]
           ,[IMPORTED]
           ,[BUYERUSERID]
           ,[WHTID]
           ,[TERM]
           ,[ISBULKORDER]
           ,[ERFQID]
           ,[WFVALUEAPPROVED]
           ,[TEMPWFAPPROVER]
           ,[LOGUSERID]
           ,[LOGDATETIME]
		   )
     VALUES
           (@BORGID 
           ,@REQNUMBER
           ,@REQSUBJECT
           ,@REQSTATUSID
           ,GETDATE()
           ,@USERID
           ,GETDATE()
           ,NULL
           ,@REQSHORTDESC
           ,@SPACES
           ,0
           ,@SPACES
           ,@SPACES
           ,'CIL'
           ,@SPACES
           ,0
           ,1
           ,NULL
           ,NULL
           ,@REQUIREDBYDATE
           ,'INR'
           ,@REQNOTES
           ,-1
           ,0
           ,'SC'
           ,@SPACES
           ,0
           ,'INR'
           ,1.0
           ,@USERID 
           ,@SPACES
           ,0
           ,NULL
           ,NULL
           ,0
           ,0
           ,NULL
           ,0
           ,-1
           ,@USERID 
           ,GETDATE()
		    )
UPDATE BORGS SET LASTREQNUMBER = @NEXTREQID WHERE BORGID=@BORGID 



SELECT @LASTREQID = REQID FROM REQ WHERE REQNUMBER= @REQNUMBER

--SET @LASTREQID = @NEXTREQID
SELECT @LASTREQID 