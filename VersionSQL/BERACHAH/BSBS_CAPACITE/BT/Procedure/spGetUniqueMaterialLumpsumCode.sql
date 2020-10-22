/****** Object:  Procedure [BT].[spGetUniqueMaterialLumpsumCode]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BT].[spGetUniqueMaterialLumpsumCode](@PROJECTCODE INT)
AS
SELECT DISTINCT GLCODE  FROM BT.MaterialLumpSum BT WHERE BT.ProjectCode=@PROJECTCODE 