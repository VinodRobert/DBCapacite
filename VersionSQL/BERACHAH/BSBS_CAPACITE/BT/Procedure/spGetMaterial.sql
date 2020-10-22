/****** Object:  Procedure [BT].[spGetMaterial]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BT].[spGetMaterial](@PROJECTID INT,@TEMPLATECODE  VARCHAR(15) )
AS
UPDATE BT.MonthlyMaterialBudget set categorytype=upper(categorytype)


IF @TEMPLATECODE = '9000000000' 
 BEGIN
    SELECT * INTO #TEMP1 FROM BS.STATIONARYMASTER ORDER BY MATERIALCODE 
	UPDATE #TEMP1 SET CONVERSIONFATCTOR=LASTPURCHASERATE
	--SELECT * FROM #TEMP1 
 END
ELSE
 BEGIN
    SELECT MMD.MATERIALCODE, MMD.MATERIALNAME , MMD.UOM , MMD.STOCKID, MMD.CONVERSIONFATCTOR,MMD.LASTPURCHASERATE ,MMD.TEMPLATECODE 
    INTO #TEMP0 
    FROM 
         BT.MasterMaterialDetail MMD
    WHERE 
        TEMPLATECODE IN (SELECT TOOLCODE FROM BT.MonthlyMaterialBudget WHERE PROJECTCODE=@PROJECTID  AND TOOLCODE=@TEMPLATECODE )

    ALTER TABLE #TEMP0 ADD BUDGETTYPE VARCHAR(25)
	UPDATE #TEMP0 SET BUDGETTYPE = BTM.categorytype FROM BT.MonthlyMaterialBudget BTM
	INNER JOIN #TEMP0 ON #TEMP0.TEMPLATECODE=BTM.TOOLCODE 
	WHERE BTM.PROJECTCODE=@PROJECTID AND BTM.TOOLCODE=@TEMPLATECODE 

	UPDATE #TEMP0 SET CONVERSIONFATCTOR = CONVERSIONFATCTOR*LASTPURCHASERATE WHERE BUDGETTYPE='L' 
    DECLARE @CATEGORYTYPE VARCHAR(1)
    SELECT @CATEGORYTYPE = UPPER(CATEGORYTYPE) FROM BT.MonthlyMaterialBudget WHERE PROJECTCODE=@PROJECTID  AND TOOLCODE=@TEMPLATECODE
	



    DELETE FROM #TEMP0 WHERE MATERIALCODE=''

	SELECT MATERIALCODE, MATERIALNAME , UOM , STOCKID, CONVERSIONFATCTOR,LASTPURCHASERATE FROM #TEMP0 WHERE LASTPURCHASERATE>0


  END