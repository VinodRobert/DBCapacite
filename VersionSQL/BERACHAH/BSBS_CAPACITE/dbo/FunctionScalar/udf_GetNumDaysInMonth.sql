/****** Object:  Function [dbo].[udf_GetNumDaysInMonth]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[udf_GetNumDaysInMonth] ( @PERIODNO INT )
RETURNS INT
AS
BEGIN
DECLARE @DAYS INT
SET @DAYS = CASE WHEN @PERIODNO
IN ('2','4','5','7','9','10','12')THEN 31
WHEN @PERIODNO IN (1,3,6,8) THEN 30
ELSE 28

--WHEN MONTH(@PERIODNO) IN (11) THEN 28
END
RETURN @DAYS
END