/****** Object:  Procedure [BT].[spAddReqDetailsWO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spAddReqDetailsWO](@REQHEADERID  INT,@TOOLCODE VARCHAR(25),@LINENUMBER INT,@ITEMDESCRIPTION VARCHAR(600),@QTY DECIMAL(18,2),@PRICE DECIMAL(18,2),@UOM VARCHAR(15),@ACTID VARCHAR(10),@ITEMID INT  )

AS


DECLARE @CATELOGID INT
DECLARE @BUYERPARTNUMBER VARCHAR(10)
DECLARE @PROJECTID INT
DECLARE @CONTRACTID INT 
DECLARE @ALLOCATION VARCHAR(15)
DECLARE @GLCODEID INT 
DECLARE @STORECODE VARCHAR(15)
DECLARE @STOREGLCODE INT 
DECLARE @STOCKCTL VARCHAR(10)
DECLARE @DELIVERYID INT 
DECLARE @INVENTORYSTORE  VARCHAR(10)
DECLARE @CATORTENDITEM INT 
DECLARE @STOCKID INT
DECLARE @INSTRUCTIONS VARCHAR(255)
DECLARE @SUPPLIERID INT
DECLARE @SPACES VARCHAR(2)
DECLARE @BORGID INT
DECLARE @ACTIVIYCODE INT


SET @SPACES = ' '
SET @ALLOCATION = 'Contracts' 
SELECT @ACTIVIYCODE = ACTID FROM ACTIVITIES WHERE ACTNUMBER=@ACTID 

SET @SUPPLIERID =36281 
SET @GLCODEID=612
SET @INSTRUCTIONS = @SPACES
SET @STOCKID = 0
SET @CATORTENDITEM =  1 
SET @CATELOGID = @ITEMID 
SET @BUYERPARTNUMBER =''
SET @BUYERPARTNUMBER =''
SELECT  @BORGID=BORGID FROM REQ WHERE REQID = @REQHEADERID
SELECT  @PROJECTID = BSPROJECTID, @CONTRACTID =BSCONTRACTID ,@DELIVERYID = BSDELIVERYID FROM BT.PROJECTS WHERE BORGID=@BORGID 



SELECT @BORGID,@PROJECTID,@DELIVERYID,@CONTRACTID 

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
           (@REQHEADERID
           ,@LINENUMBER
           ,@CATELOGID
           ,@ITEMDESCRIPTION
           ,@BUYERPARTNUMBER
           ,@SUPPLIERID 
           ,@SPACES 
           ,@SPACES 
           ,@UOM
           ,@QTY
           ,@PRICE
           ,-1
           ,@DELIVERYID
           ,@INSTRUCTIONS
           ,0
           ,@PROJECTID
           ,@CONTRACTID 
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
           ,@SPACES
           ,@SPACES
           ,-1
           ,-1
           ,@BORGID
           ,@SPACES
           ,'CIL'
           ,0
           ,0
           ,1.0
           ,NULL
		   --,-1
		   --,0
		   --,0
		   )


 