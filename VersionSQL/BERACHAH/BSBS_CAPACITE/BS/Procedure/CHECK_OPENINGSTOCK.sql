/****** Object:  Procedure [BS].[CHECK_OPENINGSTOCK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[CHECK_OPENINGSTOCK] (@BORGID INT,@STORECODE VARCHAR(10))
AS
BEGIN
  DECLARE @ID INT
  DECLARE @STOCKCODE VARCHAR(10)
  DECLARE @OPENINGQTY DECIMAL(18,4)
  DECLARE @RATE DECIMAL(18,2)
  DECLARE @MISSINGCODE VARCHAR(10)
  DECLARE @DLVRDATE DATETIME
  DECLARE @DLVRQTY  DECIMAL(18,4)
  DECLARE @DLVRRATE DECIMAL(18,2)
  DECLARE @DLVRCODE VARCHAR(10)
  DECLARE @EXISTINGQTY DECIMAL(18,4)
  DECLARE @EXISTINGRATE DECIMAL(18,2)
  DECLARE @NEWRATE DECIMAL(18,2)
 
  
  DECLARE MISSING CURSOR FOR 
  SELECT STOCKCODE FROM VR_OPENINGSTOCK WHERE BORGID=@BORGID AND STORECODE=@STORECODE AND 
  STOCKCODE NOT IN (SELECT STKCODE FROM INVENTORY WHERE STKSTORE=@STORECODE AND BORGID=@BORGID) 

  OPEN MISSING
  FETCH NEXT FROM MISSING INTO @MISSINGCODE
  WHILE @@FETCH_STATUS =0
  BEGIN
    SELECT @MISSINGCODE 
    INSERT INTO INVENTORY
	SELECT @STORECODE 
      ,@MISSINGCODE 
      ,'TO BE EDITED'
      ,[StkUnit]
      ,[StkBin]
      ,[StkQuantity]
      ,[StkCostRate]
      ,[MUMethod]
      ,[MUValue]
      ,[StkSellRate]
      ,[StkGLCode]
      ,[StkMaxBal]
      ,[StkMinBal]
      ,@BORGID 
      ,[ToJoinI]
      ,[StkHireRate]
      ,[StkStatus]
      ,[STKSTKTAKE]
      ,[STKSHEET]
      ,[STKWEIGHT]
      ,[STKWEIGHTUNIT]
      ,[STKSELLUNIT]
      ,[STKSELLCONV]
      ,[STKBUYUNIT]
      ,[STKBUYCONV]
      ,[STKSUPPCODE]
      ,[STKBUYCOST]
      ,[STKBUYDATE]
      ,[STKSELLDATE]
      ,[STKSELECT]
      ,[StkSuppProdCode]
      ,[OB1]
      ,[OB2]
      ,[OB3]
      ,[OB4]
      ,[OB5]
      ,[OB6]
      ,[OB7]
      ,[OB8]
      ,[OB9]
      ,[OB10]
      ,[OB11]
      ,[OB12]
      ,[OPENINGBALANCE]
      ,[STKDEFGL]
      ,[StkDefAct]
      ,[StkConvertFlag]
      ,[SerialType]
      ,[STKSTKTAKERATE]
      ,[STKSHEETRATE]
      ,[DIVID]
     FROM [dbo].[VR_INV]
	   
     FETCH NEXT FROM MISSING INTO @MISSINGCODE
  END
  CLOSE MISSING
  DEALLOCATE MISSING



  DELETE FROM TRANSACTIONS WHERE   ORGID=@BORGID  AND TRANSREF='STK' AND TRANSTYPE='STW' 
  DELETE FROM TRANSACTIONS WHERE   ORGID=@BORGID  AND TRANSTYPE='STW'

  DECLARE OPSTK CURSOR FOR SELECT DISTINCT * FROM VR_OPENINGSTOCK WHERE BORGID=@BORGID AND STORECODE =@STORECODE 

  OPEN OPSTK
  FETCH NEXT FROM OPSTK INTO @ID,@STORECODE,@BORGID,@STOCKCODE,@OPENINGQTY,@RATE 
  


  UPDATE INVENTORY SET 
	   StkQuantity = 0 , STKSELLRATE=0 ,STKCOSTRATE= 0 WHERE STKSTORE=@STORECODE  AND BORGID=@BORGID 
                                                                                                      
  
                                                                                                                                                                                                                                                                                                                                                               
  WHILE @@FETCH_STATUS = 0
  BEGIN
    

	   INSERT INTO TRANSACTIONS
	   SELECT @BORGID 
      ,[Year]
      ,[Period]
      ,[PDate]
      ,[BatchRef]
      ,[TransRef]
      ,[MatchRef]
      ,[TransType]
      ,[Allocation]
      ,[LedgerCode]
      ,[Contract]
      ,[Activity]
      ,[Description]
      ,[ForeignDescription]
      ,[Currency]
      ,@OPENINGQTY*@RATE
      ,[Credit]
      ,[VatDebit]
      ,[VatCredit]
      ,[Credno]
      ,@STORECODE 
      ,[Plantno]
      ,@STOCKCODE
      ,@OPENINGQTY 
      ,[Unit]
      ,@RATE
      ,[ReqNo]
      ,[OrderNo]
      ,[Age]
      ,[SubConTran]
      ,[VATType]
      ,[HomeCurrAmount]
      ,[ConversionDate]
      ,[ConversionRate]
      ,[PaidFor]
      ,[PaidToDate]
      ,[PaidThisPeriod]
      ,[WhtThisPeriod]
      ,[DiscThisPeriod]
      ,[ReconStatus]
      ,[UserID]
      ,[DivID]
      ,[ForexVal]
      ,[HeadID]
      ,[XGLCODE]
      ,[XVATA]
      ,[XVATT]
      ,[DOCNUMBER]
      ,[WHTID]
      ,[FBID]
      ,[TERM]
      ,[SYSDATE]
      ,[RECEIVEDDATE]
      ,[ORIGTRANSID]
      ,[HCTODATE]
      ,[TRANGRP]
     FROM [dbo].[VR_TEMP]

	 
		
     
	 UPDATE INVENTORY SET 
	   StkQuantity = @OPENINGQTY , STKSELLRATE=@RATE ,STKCOSTRATE= @RATE WHERE STKSTORE=@STORECODE AND STKCODE=@STOCKCODE AND BORGID=@BORGID 
 

   

	FETCH NEXT FROM OPSTK INTO @ID, @STORECODE,@BORGID,@STOCKCODE,@OPENINGQTY,@RATE 
  END

  CLOSE OPSTK
  DEALLOCATE OPSTK


  SELECT SUM(QTY*RATE) FROM VR_OPENINGSTOCK WHERE BORGID=@BORGID  AND STORECODE=@STORECODE 
  SELECT SUM(QUANTITY*RATE) AMOUNT1, SUM(DEBIT) FROM TRANSACTIONS WHERE STORE=@STORECODE AND ORGID=@BORGID   AND PERIOD=11
  SELECT SUM(STKQUANTITY*STKCOSTRATE) FROM INVENTORY WHERE BORGID=@BORGID  AND STKSTORE=@STORECODE 


  SELECT D.DLVRDATE, I.STKCODE,D.DLVRQTY,D.PRICE 
  INTO #TEMP1
  FROM ORD O INNER JOIN ORDITEMS OI ON O.ORDID=OI.ORDID INNER JOIN DELIVERIES D ON O.ORDID=D.ORDID AND OI.LINENUMBER = D.ORDITEMLINENO 
  INNER JOIN INVENTORY I ON I.STKID = OI.STOCKID WHERE D.TBORGID = @BORGID 

  DECLARE DLVRS CURSOR FOR SELECT * FROM #TEMP1  ORDER BY DLVRDATE
  OPEN DLVRS
  FETCH NEXT FROM DLVRS INTO @DLVRDATE,@DLVRCODE,@DLVRQTY,@DLVRRATE  

  WHILE @@FETCH_STATUS=0
  BEGIN
    SET @EXISTINGQTY = 0
	SET @EXISTINGRATE = 0

    SELECT @EXISTINGQTY = STKQUANTITY ,@EXISTINGRATE=STKCOSTRATE FROM INVENTORY WHERE 
	STKSTORE=@STORECODE AND STKCODE=@DLVRCODE

	SELECT @NEWRATE = (@EXISTINGQTY*@EXISTINGRATE + @DLVRQTY*@DLVRRATE)/(@DLVRQTY+@EXISTINGQTY) 
	UPDATE INVENTORY SET STKQUANTITY = @EXISTINGQTY+@DLVRQTY, STKCOSTRATE=@NEWRATE,STKSELLRATE=@NEWRATE WHERE
	STKSTORE=@STORECODE AND STKCODE=@DLVRCODE AND BORGID=@BORGID 

	FETCH NEXT FROM DLVRS INTO @DLVRDATE,@DLVRCODE,@DLVRQTY,@DLVRRATE  

  END

  CLOSE DLVRS
  DEALLOCATE DLVRS

END