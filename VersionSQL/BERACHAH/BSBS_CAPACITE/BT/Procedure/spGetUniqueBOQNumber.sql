/****** Object:  Procedure [BT].[spGetUniqueBOQNumber]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spGetUniqueBOQNumber](@PROJECTCODE INT)
AS
SELECT DISTINCT BOQNUMBER INTO #TEMP0  FROM BT.SALES  WHERE BT.SALES.ProjectCode=@PROJECTCODE 
INSERT INTO #TEMP0 VALUES ('NONBOQ')
INSERT INTO #TEMP0 VALUES ('BOQ-NOQTY')

SELECT * FROM #TEMP0 