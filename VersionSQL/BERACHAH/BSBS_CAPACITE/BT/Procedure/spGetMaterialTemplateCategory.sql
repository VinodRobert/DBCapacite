/****** Object:  Procedure [BT].[spGetMaterialTemplateCategory]    Committed by VersionSQL https://www.versionsql.com ******/

--SELECT * FROM BT.MasterMaterialBudget
--SELECT * FROM BT.MasterMaterialDetail

CREATE PROCEDURE BT.spGetMaterialTemplateCategory(@MATERIALNAME VARCHAR(100))
AS
DECLARE @SEARCH VARCHAR(100)
DECLARE @SQL VARCHAR(255)

SET @SEARCH = '%' + LTRIM(RTRIM(@MATERIALNAME)) + '%' 
SET @SQL = 'SELECT D.MATERIALNAME,D.UOM,M.TEMPLATENAME FROM BT.MASTERMATERIALBUDGET M INNER JOIN BT.MASTERMATERIALDETAIL D '
SET @SQL = @SQL + ' ON M.TEMPLATECODE=D.TEMPLATEID WHERE D.MATERIALNAME LIKE ' + CHAR(39) 
SET @SQL = @SQL + @SEARCH +  CHAR(39) 

SELECT @SQL  