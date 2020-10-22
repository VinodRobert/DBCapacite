/****** Object:  Function [BS].[fnGetDescriptionOppositeLeg]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [BS].[fnGetDescriptionOppositeLeg] (@TRANSID int)
returns varchar(35)
BEGIN 
   IF @TRANSID = 0 
      RETURN SPACE(1)

  
  SET @TRANSID = @TRANSID - 1
  declare @OppositeDescription varchar(200)
  DECLARE @CONTRACTCODE VARCHAR(10)
  SET @OppositeDescription = SPACE(10)
  SELECT
      @CONTRACTCODE = ISNULL(CONTRACT ,0) 
  FROM 
     TRANSACTIONS 
  WHERE
     TRANSID = @TRANSID AND TRANSTYPE = 'JNL'

  IF @CONTRACTCODE <>'0' 
    SELECT 
        @OppositeDescription  ='('+LTRIM(RTRIM(CONTRNAME))+')'
    From 
        CONTRACTS 
    WHERE
        CONTRNUMBER = @CONTRACTCODE 
  
  return LTRIM(RTRIM( @OppositeDescription))

End