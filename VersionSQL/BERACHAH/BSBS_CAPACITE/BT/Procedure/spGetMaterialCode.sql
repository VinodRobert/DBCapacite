/****** Object:  Procedure [BT].[spGetMaterialCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spGetMaterialCode](@PROJECTCODE INT)
AS
SELECT DISTINCT MATERIALMASTERCODE FROM BT.MATERIAL WHERE BT.MATERIAL.ProjectCode=@PROJECTCODE 