/****** Object:  Function [BS].[fnGetParty]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [BS].[fnGetParty](@CredNo varchar(10))
returns varchar(50)
begin  

  set @CredNo = RTRIM(@CredNo)

  declare @Party varchar(150)

  SELECT 
        @Party  = ISNULL(SubName,0)
  From 
        SubContractors
  WHERE
        SubNumber = @CredNo


  SELECT 
        @Party = isnull(CredName,0) 
  From 
        Creditors
  WHERE
        CredNumber = @CredNo


  SELECT 
        @Party = isnull(DebtName,0)
  From 
        Debtors
  WHERE
        DebtNumber = @CredNo


  if (@Party='0')
     set @Party =  'Not Applicable'
 
  return @Party

End