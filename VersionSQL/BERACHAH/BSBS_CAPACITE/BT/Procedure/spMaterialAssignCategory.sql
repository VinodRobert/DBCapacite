/****** Object:  Procedure [BT].[spMaterialAssignCategory]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [BT].[spMaterialAssignCategory](@MATERIALCODE VARCHAR(25),@TOOLCODE VARCHAR(25),@STORECODE VARCHAR(25),@CONVERSIONFACTOR DECIMAL(18,2))
AS
DECLARE @TEMPLATEID INT
SELECT @TEMPLATEID = INDEXCODE FROM BT.MasterMaterialBudget WHERE TEMPLATECODE=@TOOLCODE 
DECLARE @MATERIALNAME VARCHAR(255)
DECLARE @UOM VARCHAR(15)
DECLARE @STKID INT 

SELECT @MATERIALNAME = STKDESC , @UOM = STKUNIT , @STKID = STKID
FROM INVENTORY WHERE STKCODE=@MATERIALCODE AND STKSTORE=@STORECODE 

INSERT INTO BT.MASTERMATERIALDETAIL(TEMPLATEID,MATERIALCODE,TEMPLATECODE,MATERIALNAME,UOM,STOCKID,CONVERSIONFATCTOR,LASTPURCHASERATE) 
VALUES (@TEMPLATEID,@MATERIALCODE,@TOOLCODE,@MATERIALNAME,@UOM,@STKID,@CONVERSIONFACTOR,0)