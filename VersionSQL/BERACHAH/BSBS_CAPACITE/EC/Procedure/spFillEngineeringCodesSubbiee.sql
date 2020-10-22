/****** Object:  Procedure [EC].[spFillEngineeringCodesSubbiee]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [EC].[spFillEngineeringCodesSubbiee](@ACCBOQDETAILID BIGINT ) 
AS 
BEGIN 
	DECLARE @DESCRIPTION VARCHAR(255)
	DECLARE @HEADERID  BIGINT
	DECLARE @SUBBIEERECONID BIGINT 
	DECLARE @ORDERNO VARCHAR(50)
	DECLARE @ORDERID INT 
	DECLARE @GLCODEID INT
	DECLARE @LINENUMBER INT
	DECLARE @UNIT VARCHAR(15)
	DECLARE @QUANTITY DECIMAL(18,2)
	DECLARE @RATE DECIMAL(18,2) 
	DECLARE @LEDGERCODE VARCHAR(15)

	DECLARE @EXISTING INT 
	SET @EXISTING = 0
	CREATE TABLE #TEMP0(INDEXCODE BIGINT,ACTNUMBER INT,ACTIVITY VARCHAR(200),QUANTITY DECIMAL(18,2)) 
	SELECT @EXISTING = COUNT(*) FROM EC.ENGCODESSUBBIE WHERE ACCBOQDETAILID=@ACCBOQDETAILID 

	IF @EXISTING=0
	 BEGIN
		SELECT @HEADERID = HEADERID ,@DESCRIPTION =SUBSTRING(DESCRIPTION,1,255),@UNIT=UNIT,@QUANTITY=QUANTITY,@RATE=RATE 
		FROM ACCBOQDETAIL WHERE DETAILID=@ACCBOQDETAILID
		SELECT @SUBBIEERECONID = RECONID FROM  ACCBOQHEADER WHERE HEADERID = @HEADERID 
		SELECT @ORDERNO = ORDERNO FROM SUBCRECONS WHERE RECONID=@SUBBIEERECONID 
		SELECT @ORDERID = ORDID FROM ORD WHERE ORDNUMBER=@ORDERNO 
	
		SELECT @GLCODEID =GLCODEID,
			   @LINENUMBER = LINENUMBER
			   FROM ORDITEMS WHERE ORDID=@ORDERID AND UPPER(SUBSTRING(ITEMDESCRIPTION,1,255))=UPPER(@DESCRIPTION) 
		SELECT @LEDGERCODE=LEDGERCODE FROM LEDGERCODES WHERE LEDGERID=@GLCODEID 
 
		INSERT INTO EC.ENGCODESSUBBIE(ACCBOQDETAILID,ORDID,LINENUMBER,LEDGERCODE,ACTIVITYCODE,QTY,RATE,AMOUNT)
		SELECT @ACCBOQDETAILID,@ORDERID,@LINENUMBER,@LEDGERCODE,ACTNUMBER,0,@RATE,0 
		FROM EC.ENGINEERINGCODEMASTER WHERE CATEGORY='SUB CONTRACT'
     END

	INSERT INTO #TEMP0(INDEXCODE,ACTNUMBER,QUANTITY) 
	SELECT ENGCODEINDEX,ACTIVITYCODE,QTY FROM EC.ENGCODESSUBBIE WHERE ACCBOQDETAILID=@ACCBOQDETAILID 

    UPDATE #TEMP0 SET ACTIVITY = ECM.ACTIVITYNAME FROM EC.ENGINEERINGCODEMASTER ECM INNER JOIN #TEMP0 ON #TEMP0.ACTNUMBER=ECM.ACTNUMBER 
	WHERE CATEGORY='SUB CONTRACT'

	SELECT * FROM #TEMP0 ORDER BY ACTIVITY



	
	 
	
	
END

 