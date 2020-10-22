/****** Object:  Procedure [EC].[spFillEngineeringCodesSales]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [EC].[spFillEngineeringCodesSales](@RECONID INT ) 
AS

BEGIN 

    
    DECLARE @ORGID INT
	DECLARE @SUBCONNUMBER INT 
	DECLARE @CODE VARCHAR(15)
	DECLARE @NEWCODE VARCHAR(15)
	
	DECLARE @TOTALWORKDONEVALUE DECIMAL(18,2)
	DECLARE @NEWRECONID INT 


	SELECT @ORGID=ORGID , @SUBCONNUMBER=SUBCONNUMBER, @CODE=CODE FROM DEBTRECONS WHERE RECONID=@RECONID 

 

	CREATE TABLE #TEMP0(ACTNUMBER INT,ACTIVITY VARCHAR(200),AMOUNT DECIMAL(18,2)) 
	INSERT INTO #TEMP0(ACTNUMBER,ACTIVITY,AMOUNT) 
	SELECT ACTNUMBER,ACTIVITYNAME AS ACTNAME,0 FROM EC.ENGINEERINGCODEMASTER WHERE CATEGORY='SALES'

	
	SELECT @TOTALWORKDONEVALUE =MVALUE  FROM DEBTRECONDETAIL  WHERE   RECONID=@RECONID  AND VARCODE='TGB'
	
	 
	
	IF @TOTALWORKDONEVALUE < 0 
	   BEGIN
	       SELECT  RECONID 
		   INTO #RECONLIST 
		   FROM   DEBTRECONS
		   WHERE  ORGID=@ORGID AND SUBCONNUMBER=@SUBCONNUMBER 
		   --AND CODE=@CODE 
		   
		   SELECT @NEWRECONID = RECONID 
		   FROM DEBTRECONDETAIL 
		   WHERE MVALUE =ABS(@TOTALWORKDONEVALUE) AND RECONID IN (SELECT RECONID FROM #RECONLIST) 

		   UPDATE [EC].[SALESDETAILS]  SET REVERSALRECONID=@RECONID WHERE RECONID=@NEWRECONID 

	       SET @RECONID = @NEWRECONID 

	
	   END
	 
	UPDATE #TEMP0 
	SET AMOUNT = BIE.AMOUNT 
	FROM [EC].[SALESDETAILS]   BIE 
	LEFT OUTER JOIN #TEMP0  ON #TEMP0.ACTNUMBER = BIE.ACTIVITYCODE WHERE BIE.RECONID=@RECONID 

	UPDATE #TEMP0 SET AMOUNT = AMOUNT * -1.0 WHERE @TOTALWORKDONEVALUE <0 

	SELECT * FROM #TEMP0 ORDER BY ACTIVITY 
END

 