/****** Object:  Procedure [BT].[spSearchCategory]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE PROCEDURE [BT].[spSearchCategory](@MATERIALNAME VARCHAR(50))
AS
SET @MATERIALNAME = LTRIM(RTRIM(@MATERIALNAME)) 

DECLARE @SQL VARCHAR(255)
SET @SQL = 'SELECT BTD.MATERIALNAME MATERIALNAME  , BTM.MATERIALMAJORHEAD CATEGORRY FROM '
SET @SQL = @SQL + ' BT.MasterMaterialBudget BTM  INNER JOIN BT.MASTERMATERIALDETAIL BTD '
SET @SQL = @SQL + ' ON BTM.TEMPLATECODE = BTD.TEMPLATECODE WHERE BTD.MATERIALNAME LIKE  ''%' + @MATERIALNAME + '%'' ORDER BY BTD.MATERIALNAME ' 
 
EXEC(@SQL) 