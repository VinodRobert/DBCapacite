/****** Object:  Procedure [BI].[spDropNegativeDelivery]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [BI].[spDropNegativeDelivery](@DLVRID INT)
AS
  UPDATE DELIVERIES SET ALLOCATED=1 , RECONQTY = DLVRQTY WHERE DLVRID=@DLVRID 
 