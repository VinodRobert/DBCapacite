/****** Object:  Function [BS].[fnGetLedgerName]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [BS].[fnGetLedgerName](@LedgerCode varchar(10))
returns varchar(35)
begin  

  set @LedgerCode = RTRIM(@LedgerCode)

  declare @LedgerName varchar(35)

  SELECT 
        @LedgerName  = LedgerName
  From 
        LedgerCodes
  WHERE
        LedgerCode = @LedgerCode

  return @LedgerName

End