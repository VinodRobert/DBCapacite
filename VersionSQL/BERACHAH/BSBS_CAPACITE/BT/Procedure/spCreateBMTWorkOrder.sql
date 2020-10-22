/****** Object:  Procedure [BT].[spCreateBMTWorkOrder]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [BT].[spCreateBMTWorkOrder](@LOGINID VARCHAR(20), @SUBBIECODE VARCHAR(20), @SHORTDESCRIPTION VARCHAR(125),@LISTWORKORDERITEMS  ListWorkOrderID  READONLY)
AS

CREATE TABLE #WORKORDERITEMS(WORKORDERID BIGINT,QTY DECIMAL(18,4) )
INSERT INTO #WORKORDERITEMS(WORKORDERID,QTY)
SELECT WORKORDERID,QTY FROM @LISTWORKORDERITEMS 




DECLARE @MAXROWS INT
SELECT @MAXROWS  = COUNT(*) FROM #WORKORDERITEMS

DECLARE @BMTPROJECTID INT
DECLARE @WWWWITEMCODE INT
DECLARE @PRQTY DECIMAL(18,4) 
DECLARE @BORGID INT
DECLARE @CONTRACTCODE INT
DECLARE @DELIVERYID INT
DECLARE @ACTIVITY VARCHAR(10)
DECLARE @BOQCODE VARCHAR(25)
DECLARE @TOOLCODE VARCHAR(25)
DECLARE @WORKDESCRIPTION VARCHAR(255)
DECLARE @UOM VARCHAR(15)
DECLARE @RATE DECIMAL(18,4) 
DECLARE @ITEMID INT


DECLARE @REQUIREDBYDATE DATETIME 
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
DECLARE @REQITEMKEY INT 




SELECT TOP 1 @WWWWITEMCODE = WORKORDERID FROM #WORKORDERITEMS
SELECT  @BORGID=BSORGID ,
        @CONTRACTCODE=CONTRACTCODE,
		@DELIVERYID = DELIVERYID,
		@ACTIVITY=ACTIVITY,
		@BOQCODE=BOQCODE,
		@TOOLCODE=WORKITEMCODE,
		@WORKDESCRIPTION=WORKORDERITEMDESCRIPTION,
		@UOM=UOM,
		@RATE=RATE ,
		@ITEMID=ITEMID ,
		@BMTPROJECTID = BMTPROJECTCODE
FROM 
        BT.WEBWORKORDERITEMS 
		WHERE WWWITEMCODE=@WWWWITEMCODE
   
SELECT 
        @REQNUMPREFIX=REQNUMPREFIX,
		@REQNUMSUFFIX=REQNUMSUFFIX,
		@REQSEPARATEDBY=REQSEPARATEDBY,
		@LASTREQNUMBER = LASTREQNUMBER  
FROM BORGS 
WHERE BORGID=@BORGID

SELECT @USERID  = USERID FROM USERS WHERE LOGINID=@LOGINID 
 
SET @SPACES = ' ' 
SET @REQSUBJECT= 'BMT'
SET @REQSHORTDESC = @SHORTDESCRIPTION
SET @REQUIREDBYDATE = GETDATE()+5
SET @REQNOTES =@SPACES
SET @REQSTATUSID = 163

SELECT @NEXTREQID = @LASTREQNUMBER+1  
SET @REQNUMBER = LTRIM(RTRIM(@REQNUMPREFIX))+LTRIM(RTRIM(@REQSEPARATEDBY))+LTRIM(RTRIM(@NEXTREQID))+LTRIM(RTRIM(@REQSEPARATEDBY))+LTRIM(RTRIM(@REQNUMSUFFIX))
 


DECLARE @CATELOGID INT
DECLARE @BUYERPARTNUMBER VARCHAR(10)
DECLARE @PROJECTID INT
DECLARE @CONTRACTID INT 
DECLARE @ALLOCATION VARCHAR(15)
DECLARE @GLCODEID INT 
DECLARE @STORECODE VARCHAR(15)
DECLARE @STOREGLCODE INT 
DECLARE @STOCKCTL VARCHAR(10)
DECLARE @INVENTORYSTORE  VARCHAR(10)
DECLARE @CATORTENDITEM INT 
DECLARE @STOCKID INT
DECLARE @INSTRUCTIONS VARCHAR(255)
DECLARE @SUPPLIERID INT
DECLARE @ACTIVIYCODE INT
DECLARE @LINENUMBER INT
DECLARE @JOBCARDID INT 
DECLARE @TBORGID INT

SET @ALLOCATION = 'Contracts' 
SELECT @ACTIVIYCODE = ACTID FROM ACTIVITIES WHERE ACTNUMBER=@ACTIVITY

SELECT  @SUPPLIERID = SUPPID FROM SUPPLIERS WHERE SUPPCODE=@SUBBIECODE 

SET @GLCODEID=612
SET @INSTRUCTIONS = @SPACES
SET @STOCKID = -1
SET @JOBCARDID = -1 
SET @CATORTENDITEM =  1 
SET @CATELOGID = @ITEMID 
SET @BUYERPARTNUMBER =''
SET @BUYERPARTNUMBER =''
 




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
SELECT @REQITEMKEY=REQID FROM REQ WHERE REQNUMBER=@REQNUMBER

SET @LINENUMBER=0
DECLARE WORKITEMS CURSOR FOR SELECT  * FROM #WORKORDERITEMS
OPEN WORKITEMS
FETCH NEXT FROM WORKITEMS INTO @WWWWITEMCODE,@PRQTY 
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT
        @BORGID=PROJECTCODE,
        @CONTRACTCODE=CONTRACTCODE,
		@DELIVERYID = DELIVERYID,
		@ACTIVITY=ACTIVITY,
		@BOQCODE=BOQCODE,
		@TOOLCODE=WORKITEMCODE,
		@WORKDESCRIPTION=WORKITEMDESCRIPTION,
		@UOM=UOM,
		@RATE=RATE ,
		@ITEMID=ITEMID ,
		@CATELOGID = ITEMID ,
		@TBORGID = BSORGID 
	FROM  
        BT.WEBWORKORDERITEMS 
		WHERE WWWITEMCODE=@WWWWITEMCODE
  
  SET @LINENUMBER = @LINENUMBER+1

 
  
  INSERT INTO [dbo].[REQITEMS]
           ([REQID]
           ,[LINENUMBER]
           ,[CATALOGITEMID]
           ,[ITEMDESCRIPTION]
           ,[BUYERPARTNUMBER]
           ,[SUPPID]
           ,[PARTNUMBER]
           ,[PARTNUMBEREXT]
           ,[UOM]
           ,[QTY]
           ,[PRICE]
           ,[PAYMENTID]
           ,[DLVRID]
           ,[INSTRUCTIONS]
           ,[VATPERC]
           ,[PROJECTID]
           ,[CONTRACTID]
           ,[MIMETYPE]
           ,[FILESIZEINKB]
           ,[ORIGINALFILEPATH]
           ,[SENDTOSUPP]
           ,[DIVISIONID]
           ,[RESOURCECODE]
           ,[FILEPATH]
           ,[DISCOUNT]
           ,[ITEMSTATUSID]
           ,[LASTCHANGE]
           ,[LASTCHANGEBY]
           ,[ITEMSTATUSDATE]
           ,[ISFREEITEM]
           ,[CATORTENDITEM]
           ,[GLCODEID]
           ,[ACTID]
           ,[ALLOCATION]
           ,[PENUMBER]
           ,[STOCKID]
           ,[ATTMESSAGE]
           ,[VATID]
           ,[JOBCARDID]
           ,[JOBCARDVATID]
           ,[JOBCARDLEDGERID]
           ,[JOBCARDACTID]
           ,[TBORGID]
           ,[TERMS]
           ,[EID]
           ,[VATAMOUNT]
           ,[STKCONVERTFLAG]
           ,[STKBUYCONV]
           ,[TENDERPRICE]
		   --,[CATID]
		   --,[WHTID]
		   --,[WHTAMOUNT]
		   )
     VALUES
           (@REQITEMKEY
           ,@LINENUMBER
           ,@CATELOGID
           ,LEFT(@WORKDESCRIPTION,255)
           ,@BUYERPARTNUMBER
           ,@SUPPLIERID 
           ,@SPACES 
           ,@SPACES 
           ,@UOM
           ,@PRQTY 
           ,@RATE
           ,-1
           ,@DELIVERYID
           ,@INSTRUCTIONS
           ,0
           ,@BORGID
           ,@CONTRACTCODE
           ,@SPACES 
           ,0
           ,@SPACES
           ,0
           ,-1
           ,@TOOLCODE
           ,@SPACES
           ,0
           ,163
           ,NULL
           ,NULL
           ,GETDATE()
           ,1
           ,@CATORTENDITEM
           ,@GLCODEID 
           ,@ACTIVIYCODE
           ,@ALLOCATION 
           ,-1
           ,@STOCKID 
           ,@SPACES
           ,', , , , , '
           ,@JOBCARDID
           ,-1
           ,-1
           ,-1
           ,@TBORGID
           ,'Current'
           ,'CIL'
           ,0
           ,0
           ,null
           ,NULL
		   --,-1
		   --,0
		   --,0
		   )

  UPDATE TENDERITEMS SET ORDEREDQTY =ORDEREDQTY+@PRQTY , ORDEREDAMOUNT=ORDEREDAMOUNT+(@PRQTY*@RATE) WHERE ITEMID=@ITEMID 

  INSERT INTO  [BT].[BUDGETWORKORDERMOVEMENTDETAIL](PROJECTCODE,TOOLCODE,  WWWITEMCODE,  REQID,     REQDATE,   REQNUMBER, LINENUMBER, PRQTY,  PRRATE,PRAMOUNT    ,PRSTATUS,OPENPR, PRUOM)
  VALUES                                           (@BMTPROJECTID,@TOOLCODE,@WWWWITEMCODE,@REQITEMKEY,GETDATE(),@REQNUMBER,@LINENUMBER,@PRQTY ,@RATE ,@PRQTY*@RATE,163,     @PRQTY,@UOM)   
	 
  UPDATE BT.WEBWORKORDERITEMS 
  SET ORDEREDQTY = ORDEREDQTY + @PRQTY, ORDEREDAMOUNT = ORDEREDAMOUNT + (@PRQTY*@RATE) WHERE WWWITEMCODE = @WWWWITEMCODE
  UPDATE BT.WEBWORKORDERITEMS
  SET TOTALBALANCEQTY = TOTALQTY - ORDEREDQTY WHERE WWWITEMCODE = @WWWWITEMCODE

  FETCH NEXT FROM WORKITEMS INTO @WWWWITEMCODE,@PRQTY 
END



SELECT @REQNUMBER 



 