/****** Object:  Function [dbo].[fn_SplitCols]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 04-29-2020
-- Description:	Split list of column names
-- NOTES:
--  
-- =============================================
CREATE FUNCTION [dbo].[fn_SplitCols]
(
@str VARCHAR(MAX), 	
@delim VARCHAR(2)

)
RETURNS 
@tmptbl TABLE (colid INT,colname VARCHAR(250))
AS
BEGIN
	DECLARE @listcnt INT,@i INT
	--remove the deminitor to deternine the number of iterances
	SET @listcnt = LEN(@STR)-LEN(REPLACE(@STR,@delim,'')) + 1
	--initiate loop from 1
	SET @i  =1 ;

	WHILE @i < @listcnt 
		BEGIN
			INSERT INTO @tmptbl (colid,colname) 
			VALUES 
			(@i,SUBSTRING(@str,1,CHARINDEX(@delim,@str)-1))
			--remove the string just written to the table
			SET @str = SUBSTRING(@str,CHARINDEX(@delim,@str)+1,LEN(@str)-CHARINDEX(@delim,@str)+1)
				
			SET @i = @i + 1
		END 
		--insert the last item still remaining
		INSERT INTO @tmptbl (colid,colname) 
			VALUES 
			(@i,@str)
	
	RETURN 
END
		
		