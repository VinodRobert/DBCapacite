/****** Object:  Procedure [BS].[REPEATDEPS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.REPEATDEPS
AS
EXEC [BS].[POSTDEPRECIATION] 2017, 7
EXEC [BS].[POSTDEPRECIATION] 2017, 8
EXEC [BS].[POSTDEPRECIATION] 2017, 9