/****** Object:  Procedure [BS].[spDeleteHireRequisitions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spDeleteHireRequisitions(@REQNO VARCHAR(10))
AS
DELETE  FROM ReqPlantHireReturns	WHERE IDR IN (SELECT ID FROM ReqPlantHireReturnsHead WHERE HIREHNUMBER= @REQNO)
DELETE  FROM ReqPlantHireReturnsHead WHERE HIREHNUMBER=@REQNO  
DELETE  FROM PlantHireDetail WHERE HIREHNUMBER=@REQNO
DELETE  FROM PlantHireHeader WHERE HIREHNUMBER=@REQNO


 