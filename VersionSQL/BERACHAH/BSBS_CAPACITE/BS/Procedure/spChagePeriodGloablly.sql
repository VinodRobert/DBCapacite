/****** Object:  Procedure [BS].[spChagePeriodGloablly]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [BS].[spChagePeriodGloablly](@ZONEID INT,@NEWPERIOD INT ,@NEWYEAR INT )
AS

 UPDATE BORGS SET PERIOD=@NEWPERIOD, CURRENTYEAR = @NEWYEAR  WHERE
 BORGID IN (SELECT BORGID FROM BORGS WHERE PARENTBORG = @ZONEID ) 
 Return 0