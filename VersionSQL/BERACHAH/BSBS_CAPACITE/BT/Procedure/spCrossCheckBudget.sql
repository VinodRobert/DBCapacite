/****** Object:  Procedure [BT].[spCrossCheckBudget]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spCrossCheckBudget](@PROJECTID INT,@TOREPLACE INT)
as

 
DECLARE @PROJECTCODE VARCHAR(15)
DECLARE @PROJECTNAME VARCHAR(150)
DECLARE @BSPROJECTID INT 
DECLARE @HEADERID INT
DECLARE @BUDGETQTY DECIMAL(18,4)
DECLARE @BUDGETAMOUNT DECIMAL(18,4) 
DECLARE @TOOLCODE VARCHAR(25)
DECLARE @RELEASEDQTY DECIMAL(18,4)
DECLARE @TENDERITEMQTY DECIMAL(18,4)
DECLARE @TENDERORDEREDQTY DECIMAL(18,4) 
DECLARE @BORGID INT 
DECLARE @ITEMID INT 

DECLARE @PRQTY DECIMAL(18,4)
DECLARE @PRAMOUNT DECIMAL(18,4) 
DECLARE @CANCELLED DECIMAL(18,4)
DECLARE @REJECTED DECIMAL(18,4) 
DECLARE @ORDQTY DECIMAL(18,4) 
DECLARE @ORDAMOUNT DECIMAL(18,4) 
DECLARE @DELIVERYQTY DECIMAL(18,4) 
DECLARE @DELIVERYAMOUNT DECIMAL (18,4) 
DECLARE @COMPLETED DECIMAL(18,4) 
DECLARE @OPENPRQTY DECIMAL(18,4)
DECLARE @OPENPRAMOUNT DECIMAL(18,4)
DECLARE @WEBBASEDPRQTY DECIMAL(18,4) 
DECLARE @WEBBASEDPRAMOUNT DECIMAL(18,4) 
DECLARE @MONTHLYBUDGERTID INT

--  BMT BUDGET TABLE :   BT.PROJECTMATERIALBUDGETMASTER  IN SUMMARY LEVEL 
--                       BT.ProjectMaterialBudgetDetail  IS MONTHLY DISTRIBUTION 
--  BMT RELEASE TABLE:   BT.RELEASESUMMARY 
--  BMT WEB PR TABLE :   BT.MONTHLYMATERIALBUDGET

DECLARE PROJECTLIST CURSOR  FOR SELECT PROJECTID,PROJECTCODE,PROJECTNAME,BSPROJECTID,BORGID FROM BT.PROJECTS WHERE BORGID<>-1 AND PROJECTID=@PROJECTID
OPEN PROJECTLIST  

FETCH NEXT FROM PROJECTLIST INTO @PROJECTID,@PROJECTCODE,@PROJECTNAME,@BSPROJECTID,@BORGID  

--A.  TO CHECK ALL ENTRIES OF BUDGET IN THE MOVEMENTHEAD TABLE 

SELECT DISTINCT TOOLCODE INTO #TOOLCODELIST  FROM BT.PROJECTMATERIALBUDGETMASTER WHERE PROJECTCODE= @PROJECTID
ALTER TABLE #TOOLCODELIST ADD EXISTING INT 
UPDATE #TOOLCODELIST SET EXISTING=0
UPDATE #TOOLCODELIST SET EXISTING=1  FROM BT.BUDGETMATERAILMOVEMENTHEAD BTB INNER JOIN #TOOLCODELIST ON #TOOLCODELIST.ToolCode=BTB.TOOLCODE 

IF @TOREPLACE =0 
BEGIN
	SELECT * FROM #TOOLCODELIST WHERE EXISTING=0 
END


WHILE @@FETCH_STATUS = 0 
BEGIN
  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET PROJECTNAME = UPPER(@PROJECTNAME) WHERE PROJECTCODE=@PROJECTID 
  DECLARE ITEMLIST CURSOR FOR SELECT HEADERID,TOOLCODE FROM BT.BUDGETMATERAILMOVEMENTHEAD WHERE PROJECTCODE=@PROJECTID ORDER BY TOOLCODE 
  OPEN ITEMLIST
  FETCH NEXT FROM ITEMLIST INTO @HEADERID,@TOOLCODE 

  WHILE @@FETCH_STATUS = 0 
  BEGIN 
	   -- BUDGET UPDATING 
	   SELECT 
		@BUDGETQTY =ISNULL( SUM(BUDGETQTY),0)  ,@BUDGETAMOUNT =ISNULL( SUM(BUDGETAMOUNT) ,0)   
		FROM BT.ProjectMaterialBudgetMaster WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE 
	
		UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET BUDGET = @BUDGETQTY    WHERE PROJECTCODE=@PROJECTID   AND TOOLCODE=@TOOLCODE   AND CATEGORY='Q'
		UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET BUDGET = @BUDGETAMOUNT WHERE PROJECTCODE=@PROJECTID   AND TOOLCODE=@TOOLCODE   AND CATEGORY='L'

	   -- RELEASE UPDATING 
	   SELECT @RELEASEDQTY=ISNULL( SUM(RELEASEQTY),0) FROM BT.RELEASESUMMARY WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	   UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET RELEASED  = @RELEASEDQTY WHERE PROJECTCODE=@PROJECTID   AND TOOLCODE=@TOOLCODE 
 
	   -- TENDER TABLE ENTRY 

	   SET @ITEMID= 0 
	   SELECT @ITEMID = ISNULL(ITEMID,0) FROM TENDERITEMS WHERE BORG=@BORGID  AND RESCODE=@TOOLCODE 
	   SET @TENDERITEMQTY = 0
	   SET @TENDERORDEREDQTY = 0
	   IF @ITEMID = 0 
		BEGIN
		  SET @TENDERITEMQTY = 0 
		  SET @TENDERORDEREDQTY = 0 
		END
	   ELSE 
	    BEGIN 
		  SELECT @TENDERITEMQTY = QTY ,@TENDERORDEREDQTY = ORDEREDQTY FROM TENDERITEMS WHERE ITEMID=@ITEMID 
		  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET TENDERITEMID=@ITEMID WHERE  PROJECTCODE=@PROJECTID   AND TOOLCODE=@TOOLCODE
		END

	   UPDATE BT.BUDGETMATERAILMOVEMENTHEAD 
		 SET TENDERTABLEQTY  = @TENDERITEMQTY , TENDERTABLEORDEREDQTY  =  @TENDERORDEREDQTY 
		 WHERE PROJECTCODE=@PROJECTID   AND TOOLCODE=@TOOLCODE 
	   UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET TENDERTABLEFORORDERING = TENDERTABLEQTY - TENDERTABLEORDEREDQTY
		 WHERE PROJECTCODE=@PROJECTID   AND TOOLCODE=@TOOLCODE
  
	  -- PURCHASE REQUISITION MADE 

	  SET @PRQTY = 0
	  SET @PRAMOUNT = 0
	  SELECT @PRQTY = ISNULL( SUM(PRQTY*CONVERTIONFACTOR),0) ,@PRAMOUNT = ISNULL( SUM(PRAMOUNT) ,0) 
	  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET PURCHASE_REQUEST_MADE= @PRQTY    WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='Q'
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET PURCHASE_REQUEST_MADE= @PRAMOUNT WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='L'

	  -- CANCELLED QTY / AMOUNT 

	  SET @CANCELLED= 0 
	  SELECT @CANCELLED  = ISNULL( SUM(CANCELLEDQTY) ,0)
	  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET CANCELLED = @CANCELLED WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE  
 
	  -- REJECTED QTY / AMOUNT 
	  SET @REJECTED= 0 
	  SELECT @REJECTED  =ISNULL( SUM(REJECTQTY) ,0)
	  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET REJECTED = @REJECTED WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE  

	  -- ORDERED QTY / AMOUNT 
	  SET @ORDQTY  = 0
	  SET @ORDAMOUNT = 0
	  SELECT @ORDQTY =ISNULL(SUM(ORDQTY*CONVERTIONFACTOR),0),@ORDAMOUNT = ISNULL(SUM(ORDAMOUNT) ,0)
	  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET ORDERED = @ORDQTY    WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='Q'
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET ORDERED = @ORDAMOUNT WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='L'


	  -- DELIVERED QTY / AMOUNT 
	  SET @DELIVERYQTY  = 0
	  SET @DELIVERYAMOUNT = 0
	  SELECT @DELIVERYQTY = ISNULL(SUM(DELIVEREDQTY*CONVERTIONFACTOR),0),@DELIVERYAMOUNT = ISNULL(SUM(DELIVERYAMOUNT) ,0)
	  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET DELIVERY = @DELIVERYQTY    WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='Q'
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET DELIVERY = @DELIVERYAMOUNT WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='L'

	  -- SHORT CLOSURE 
	  SET @COMPLETED  = 0
	  SELECT @COMPLETED =ISNULL(SUM(BUDGETORDCOMPDIFF) ,0)
	  FROM BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET COMPLETED = @COMPLETED WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE 

	  -- OPEN PR
	  SET @OPENPRQTY = 0 
	  SET @OPENPRAMOUNT = 0 
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET OPENPR = @OPENPRQTY     WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  SELECT @OPENPRQTY=ISNULL(SUM(PRQTY*CONVERTIONFACTOR),0), @OPENPRAMOUNT=ISNULL(SUM(PRAMOUNT),0) 
	  FROM  BT.BUDGETMATERIALMOVEMENTDETAIL WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND ORDID IS NULL AND PRSTATUS IN (32,163)
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET OPENPR = @OPENPRQTY    WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='Q'
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD  SET OPENPR = @OPENPRAMOUNT WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='L'
	

	  -- AVAILABLE FOR WEB BASED PR 
	  SET @WEBBASEDPRQTY=0
	  SET @WEBBASEDPRAMOUNT=0
	  SELECT @MONTHLYBUDGERTID=MonthlyMaterialBudgetCode, @WEBBASEDPRQTY = CUMULATIVEQTY , @WEBBASEDPRAMOUNT=BUDGETAMOUNT 
	  FROM BT.MONTHLYMATERIALBUDGET WHERE PROJECTCODE = @PROJECTID AND TOOLCODE=@TOOLCODE 
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET  FORPURCHASE_WEBPR =@WEBBASEDPRQTY    WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='Q'
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET  FORPURCHASE_WEBPR =@WEBBASEDPRAMOUNT WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE AND CATEGORY='L'
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET  MONTHLYBUDGETID =  @MONTHLYBUDGERTID WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE

	  -- LAST TWO CRITICAL COLUMNS
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET TOTALQTYCONSUMED = ORDERED + OPENPR - COMPLETED - CANCELLED  WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET BALANCEQTYFORPURCHASE = RELEASED - TOTALQTYCONSUMED WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE

	  -- CROSS CHECKINGS 
	  -- A.   TENDER TABLE TOTAL QTY MUST BE EQUAL TO RELEASE QTY  -   
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET C1_TENDERQTY_RELEASEQTY = 0 WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET C1_TENDERQTY_RELEASEQTY = 1 WHERE TENDERTABLEQTY<>RELEASED AND  PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	 
	  -- B.   TENDER TABLE ORDERED QTY MUST BE EQUAL TO CONSUMED QTY 
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET C2_TENDERORDER_CONSUMED = 0 WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET C2_TENDERORDER_CONSUMED = 1 WHERE TENDERTABLEORDEREDQTY<>TOTALQTYCONSUMED AND  PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	
	  -- C.   WEB BASED PR QTY AVAILABLE MUST BE EQUAL TO BALANCE QTY FOR PURCHASE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET C3_WEBPRQTY_BALANCEFORPURCHASE = 0 WHERE PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	  UPDATE BT.BUDGETMATERAILMOVEMENTHEAD SET C3_WEBPRQTY_BALANCEFORPURCHASE = 1 WHERE FORPURCHASE_WEBPR<>BALANCEQTYFORPURCHASE AND  PROJECTCODE=@PROJECTID AND TOOLCODE=@TOOLCODE
	
	
	FETCH NEXT FROM ITEMLIST INTO @HEADERID,@TOOLCODE
   END
   CLOSE ITEMLIST
   DEALLOCATE ITEMLIST 

  FETCH NEXT FROM PROJECTLIST INTO @PROJECTID,@PROJECTCODE,@PROJECTNAME,@BSPROJECTID,@BORGID  
END
CLOSE PROJECTLIST
DEALLOCATE PROJECTLIST 

IF @TOREPLACE=0
BEGIN
	SELECT PROJECTCODE,TOOLCODE,MAJORHEAD,TOOLNAME,CATEGORY,UOM,TENDERTABLEQTY,RELEASED
	FROM BT.BUDGETMATERAILMOVEMENTHEAD WHERE C1_TENDERQTY_RELEASEQTY=1 AND PROJECTCODE=@PROJECTID  ORDER BY TOOLCODE 

	SELECT PROJECTCODE,TOOLCODE,MAJORHEAD,TOOLNAME,CATEGORY,UOM,TENDERTABLEQTY,TENDERTABLEORDEREDQTY,TENDERTABLEFORORDERING,TOTALQTYCONSUMED
	FROM BT.BUDGETMATERAILMOVEMENTHEAD WHERE C2_TENDERORDER_CONSUMED=1 AND PROJECTCODE=@PROJECTID  ORDER BY TOOLCODE 

	SELECT PROJECTCODE,TOOLCODE,MAJORHEAD,TOOLNAME,CATEGORY,UOM,RELEASED,FORPURCHASE_WEBPR,TOTALQTYCONSUMED,BALANCEQTYFORPURCHASE 
	FROM BT.BUDGETMATERAILMOVEMENTHEAD WHERE C3_WEBPRQTY_BALANCEFORPURCHASE=1  AND PROJECTCODE=@PROJECTID  ORDER BY TOOLCODE 
END


IF @TOREPLACE=1 
BEGIN

		DECLARE @TID INT
		DECLARE TENDERTABLEUPDATE CURSOR FOR SELECT RELEASED,TENDERITEMID FROM BT.BUDGETMATERAILMOVEMENTHEAD WHERE 
		C1_TENDERQTY_RELEASEQTY = 1 AND PROJECTCODE=@PROJECTID 
		OPEN TENDERTABLEUPDATE
		FETCH NEXT FROM TENDERTABLEUPDATE INTO @RELEASEDQTY ,@TID
		WHILE @@FETCH_STATUS=0
		BEGIN
		  UPDATE  TENDERITEMS SET QTY=@RELEASEDQTY WHERE ITEMID=@TID 
		  FETCH NEXT FROM TENDERTABLEUPDATE INTO @RELEASEDQTY ,@TID
		END
		CLOSE TENDERTABLEUPDATE
		DEALLOCATE TENDERTABLEUPDATE


		DECLARE @TOTALQTYCONSUMED DECIMAL(18,4) 
		DECLARE TENDERTABLEUPDATE CURSOR FOR SELECT TOTALQTYCONSUMED,TENDERITEMID FROM BT.BUDGETMATERAILMOVEMENTHEAD 
		WHERE C2_TENDERORDER_CONSUMED = 1 AND PROJECTCODE=@PROJECTID 
		OPEN TENDERTABLEUPDATE
		FETCH NEXT FROM TENDERTABLEUPDATE INTO @TOTALQTYCONSUMED ,@TID
		WHILE @@FETCH_STATUS=0
		BEGIN
		  UPDATE  TENDERITEMS SET ORDEREDQTY=@TOTALQTYCONSUMED,ORDEREDAMOUNT=@TOTALQTYCONSUMED*RATE WHERE ITEMID=@TID 
		  FETCH NEXT FROM TENDERTABLEUPDATE INTO @TOTALQTYCONSUMED ,@TID
		END
		CLOSE TENDERTABLEUPDATE
		DEALLOCATE TENDERTABLEUPDATE




		DECLARE @BALANCEQTYFORPURCHASE DECIMAL(18,4) 
		DECLARE @MBUDGETID INT
		DECLARE @HID INT

		DECLARE TENDERTABLEUPDATE CURSOR FOR SELECT HEADERID, BALANCEQTYFORPURCHASE,MONTHLYBUDGETID FROM BT.BUDGETMATERAILMOVEMENTHEAD 
		WHERE C3_WEBPRQTY_BALANCEFORPURCHASE = 1 AND PROJECTCODE=@PROJECTID 
		OPEN TENDERTABLEUPDATE
		FETCH NEXT FROM TENDERTABLEUPDATE INTO @HID,@BALANCEQTYFORPURCHASE,@MBUDGETID
		WHILE @@FETCH_STATUS=0
		BEGIN
		  UPDATE  BT.MONTHLYMATERIALBUDGET SET CUMULATIVEQTY =@BALANCEQTYFORPURCHASE,BUDGETAMOUNT=0 
		  WHERE MONTHLYMATERIALBUDGETCODE=@MBUDGETID AND CATEGORYTYPE='Q'
		  UPDATE  BT.MONTHLYMATERIALBUDGET SET CUMULATIVEQTY =0                     ,BUDGETAMOUNT=@BALANCEQTYFORPURCHASE 
		  WHERE MONTHLYMATERIALBUDGETCODE=@MBUDGETID AND CATEGORYTYPE='L'

		  UPDATE  BT.BUDGETMATERAILMOVEMENTHEAD SET FORPURCHASE_WEBPR = @BALANCEQTYFORPURCHASE,C3_WEBPRQTY_BALANCEFORPURCHASE = 0 WHERE HEADERID=@HID 

		  FETCH NEXT FROM TENDERTABLEUPDATE INTO @HID,@BALANCEQTYFORPURCHASE,@MBUDGETID
		END
		CLOSE TENDERTABLEUPDATE
		DEALLOCATE TENDERTABLEUPDATE

END 