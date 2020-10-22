/****** Object:  Function [dbo].[fn_spellNumber]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[fn_spellNumber](@SpellNumber DECIMAL(18,2),@SpellType VARCHAR(10) = 'UK',@AddComma     BIT = 1) 
RETURNS VARCHAR(MAX) 
BEGIN 
 
  DECLARE @RUPEE AS BIGINT
  DECLARE @PAISA AS INT

  SET @RUPEE = FLOOR(@SPELLNUMBER)
  SET @PAISA = CONVERT( INT, (@SPELLNUMBER - @RUPEE )*100 )
  
  DECLARE @INWORDS VARCHAR(MAX) 

  DECLARE @RUPEE_IN_WORDS VARCHAR(MAX)
  DECLARE @PAISA_IN_WORDS VARCHAR(MAX)

  SELECT @RUPEE_IN_WORDS = [dbo].[fn_ToWords](@RUPEE,'UK',0) 
  SET @INWORDS = LTRIM(RTRIM(@RUPEE_IN_WORDS))

  IF @PAISA > 0 
   BEGIN
     SELECT @PAISA_IN_WORDS = [dbo].[fn_ToWords](@PAISA,'UK',0)
     SET @INWORDS =  @INWORDS + ' And Paisa ' + LTRIM(RTRIM(@PAISA_IN_WORDS)) + ' Only '
   END
  ELSE
   BEGIN
     SET @INWORDS = @INWORDS + ' Only '
   END
 
  RETURN (@INWORDS) 
END 
 