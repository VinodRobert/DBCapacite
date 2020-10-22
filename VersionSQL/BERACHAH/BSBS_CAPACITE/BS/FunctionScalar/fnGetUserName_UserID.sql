/****** Object:  Function [BS].[fnGetUserName_UserID]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [BS].[fnGetUserName_UserID](@USERID INT)
returns varchar(50)
begin  

 

  declare @USERNAME varchar(50)
  SET @USERNAME=''
  SELECT 
        @USERNAME  = ISNULL(USERNAME,0)
  From 
        USERS
  WHERE
       USERID = @USERID 

  
 
  return @USERNAME

End