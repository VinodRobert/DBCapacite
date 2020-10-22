/****** Object:  Function [BS].[fnGetUserName]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [BS].[fnGetUserName](@LOGINID varchar(10))
returns varchar(50)
begin  

  set @LOGINID = RTRIM(@LOGINID)

  declare @USERNAME varchar(50)
  SET @USERNAME=''
  SELECT 
        @USERNAME  = ISNULL(USERNAME,0)
  From 
        USERS
  WHERE
       LOGINID = @LOGINID

  
 
  return @USERNAME

End