/****** Object:  Procedure [BT].[spPopulateWorkOrderRelease]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spPopulateWorkOrderRelease](@PROJECTID INT, @TOPERIOD INT,@CATEGORY INT)
AS
  
 
  DECLARE @RESCODE VARCHAR(20)
  DECLARE @DESCR   VARCHAR(255)
  DECLARE @UNIT    VARCHAR(15)
  DECLARE @QTY     DECIMAL(18,2)
  DECLARE @RATE    DECIMAL(18,2) 
  DECLARE @BORG    INT 
  DECLARE @PROJECT INT
  DECLARE @CONTRACT INT

  DECLARE @SPACE VARCHAR(10) 

  DECLARE @EID VARCHAR(10)
  DECLARE @LEDGERCODE VARCHAR(10)
  DECLARE @SUPPCODE VARCHAR(10)
  DECLARE @REMARK VARCHAR(255)

  SET @LEDGERCODE='5008012' 
  SET @EID='CAP' 
  SET @SUPPCODE=''
  SET @REMARK = 'Budget Uploaded'
  SET @SPACE =''

  SELECT @BORG= BORGID,@PROJECT=BSPROJECTID,@CONTRACT=BSCONTRACTID  
  FROM BT.PROJECTS 
  WHERE PROJECTID = @PROJECTID 
   
  SELECT WO.BOQCODE,WO.MINORWORKHEADID,WO.UOM,SUM(WS.QTY) PERIODQTY, WO.RATE 
  INTO #TEMP0 
  FROM BT.WORKORDER WO INNER JOIN BT.WORKORDERSPREAD WS ON WO.WORKORDERID = WS.WORKORDERCODE 
  WHERE WO.PROJECTCODE = @PROJECTID AND WS.YearPeriodCode<=@TOPERIOD
  GROUP BY WO.BOQCODE,WO.MINORWORKHEADID,WO.UOM,WO.RATE

 
  ALTER TABLE #TEMP0 ADD BOQ VARCHAR(255)
  ALTER TABLE #TEMP0 ADD DESCRIPTION VARCHAR(255)
  UPDATE #TEMP0 SET BOQ = BTS.BOQ FROM BT.SALES BTS INNER JOIN #TEMP0 ON #TEMP0.BOQCODE=BTS.BOQNUMBER
  UPDATE #TEMP0 SET DESCRIPTION =MI.SUBTASKNAME FROM BT.WORKSUBTASK  MI INNER JOIN #TEMP0 ON #TEMP0.MINORWORKHEADID=MI.TEMPLATECODE 

  IF @CATEGORY = 1
     SELECT BOQCODE,BOQ,MINORWORKHEADID,DESCRIPTION,UOM,PERIODQTY,RATE  FROM #TEMP0 
  
  IF @CATEGORY = 2
     BEGIN
	     DECLARE TI CURSOR FOR SELECT MINORWORKHEADID,DESCRIPTION,UOM,PERIODQTY,RATE FROM #TEMP0 
		 OPEN TI
		 FETCH NEXT FROM TI INTO @RESCODE,@DESCR,@UNIT,@QTY,@RATE 
		 WHILE @@FETCH_STATUS = 0 
		 BEGIN 
		  INSERT INTO [dbo].[TENDERITEMS] 
           ([RESCODE]
           ,[DESCR]
           ,[RATE]
           ,[UNIT]
           ,[QTY]
           ,[BORG]
           ,[PROJECT]
           ,[CONTRACT]
           ,[ORDEREDQTY]
           ,[EID]
           ,[LEDGERCODE]
           ,[CURRENCY]
           ,[SUPPCODE]
           ,[CATEGORY]
           ,[PERIODQTY]
           ,[ORDEREDAMOUNT]
           ,[FINALWASTE]
           ,[REMARK]
           ,[PERIODWASTE]
           ,[COSTRATE]
           ,[COSTQTY]
           ,[BILLQTY]
           ,[COSTWASTE]
           ,[EXCHRATE]
           ,[ACTNUMBER]
           ,[ISACTDETAIL]
           ,[ACTUALUSAGE]
           ,[ACTUALWASTE]
           ,[SYSDATE]
           ,[ORDEREDDISCOUNT]
           ,[TEMP6])
          VALUES
           (@RESCODE
           ,@DESCR
           ,@RATE
           ,@UNIT
		   ,@QTY
           ,@BORG
           ,@PROJECT
           ,@CONTRACT
           ,0
           ,@EID
           ,@LEDGERCODE
           ,'INR'
           ,@SUPPCODE
           ,'SUBCONTRACTORS'
           ,@QTY
           ,0
           ,0
           ,@REMARK
           ,0
           ,0 
		   ,0
           ,0
           ,0
           ,1
           ,'400'
           ,0
           ,0
           ,0
           ,GETDATE()
           ,0
           ,@SPACE
		   )
         FETCH NEXT FROM TI INTO @RESCODE,@DESCR,@UNIT,@QTY,@RATE 
        END
		CLOSE TI
		DEALLOCATE TI
     SELECT 1 AS SUCCESS
	 END