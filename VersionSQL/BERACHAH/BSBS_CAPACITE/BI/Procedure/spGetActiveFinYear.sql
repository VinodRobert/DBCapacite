/****** Object:  Procedure [BI].[spGetActiveFinYear]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [BI].[spGetActiveFinYear]
AS

DECLARE @CURRENTYEAR INT
DECLARE @CURRENTPERIOD INT
DECLARE @CURRENTPERIODNAME VARCHAR(20)

SELECT @CURRENTYEAR=CURRENTYEAR,@CURRENTPERIOD=PERIOD  FROM BORGS WHERE BORGID=2 
SELECT @CURRENTPERIODNAME = PERIODDESC FROM PERIODMASTER WHERE PERIODID=@CURRENTPERIOD

SELECT @CURRENTYEAR,@CURRENTPERIOD,@CURRENTPERIODNAME

 
 