/****** Object:  Procedure [BI].[spFetchPositiveDeliveries]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [BI].[spFetchPositiveDeliveries](@BORGID INT,@ORDID INT,@ITEMLINENO INT) 
AS
SELECT  DLVRNO,GRNNO,DLVRQTY,0 AS RECONCILE, DLVRID  FROM DELIVERIES WHERE TBORGID = @BORGID AND ORDID =@ORDID AND ORDITEMLINENO = @ITEMLINENO  AND
ALLOCATED=0 AND DLVRQTY > 0 