/****** Object:  Procedure [BT].[spGetUniqueMaterialCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spGetUniqueMaterialCode](@PROJECTCODE INT)
AS
SELECT DISTINCT ToolCode FROM BT.MATERIAL WHERE BT.MATERIAL.ProjectCode=@PROJECTCODE 