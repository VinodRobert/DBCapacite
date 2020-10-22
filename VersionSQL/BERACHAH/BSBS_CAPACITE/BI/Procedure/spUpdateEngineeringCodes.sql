/****** Object:  Procedure [BI].[spUpdateEngineeringCodes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BI].[spUpdateEngineeringCodes](@RECONID INT ,@ACTNUMBER VARCHAR(15),@AMOUNT DECIMAL(18,2) ) 
AS
BEGIN
  DECLARE @BORGID INT
  DECLARE @LEDGERCODE VARCHAR(15) 
  DECLARE @CODE VARCHAR(10)
  SELECT @BORGID = ORGID,@CODE = CODE FROM DEBTRECONS WHERE RECONID=@RECONID 
  IF @CODE IN ('16.20' ,'16.22')
     SET @LEDGERCODE = '4010009'
  ELSE IF @CODE IN ('16.21' ,'16.23')
          SET @LEDGERCODE = '4010000' 
  
  DELETE FROM EC.SALESDETAILS  
  WHERE ORGID=@BORGID AND RECONID=@RECONID AND ACTIVITYCODE =@ACTNUMBER 

  INSERT INTO EC.SALESDETAILS  (ORGID,RECONID,LEDGERCODE  , ACTIVITYCODE ,AMOUNT,REVERSALRECONID,TRANGRP) 
  SELECT @BORGID,@RECONID,@LEDGERCODE,@ACTNUMBER,@AMOUNT,0,-1
END

 