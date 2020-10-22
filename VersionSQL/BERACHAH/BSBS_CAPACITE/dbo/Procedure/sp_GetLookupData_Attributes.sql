/****** Object:  Procedure [dbo].[sp_GetLookupData_Attributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-25-2020
-- Description:	Returns the attribute lookup data 
-- NOTES:
-- 2020-06-25 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_Attributes] (
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
@SortString NVARCHAR(MAX) = '',
@SearchFilters NVARCHAR(MAX) = '',
@AttribTable NVARCHAR(55) = '',
@AttribName NVARCHAR(55) = ''
)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets 
	SET NOCOUNT ON;
	DECLARE 
	@SkipRow INT,
	@ResultSQL NVARCHAR(MAX) = '',
	@ExecSQL NVARCHAR(MAX) = '',
	@Columns NVARCHAR(MAX),
  @PagerSQL NVARCHAR(MAX) = '',
  @TotalRecords BIGINT = -1,
  @TotalPages BIGINT = -1

	SELECT @SortString=ISNULL(@SortString,''),@SearchFilters=ISNULL(@SearchFilters,'');

	SET @ExecSql = 'SELECT ATTRIBLOOKUP.AID aid, ATTRIBLOOKUP.VALUE value, ATTRIBLOOKUP.ATTRIBUTE attribute, ATTRIBLOOKUP.TABLENAME tablename FROM ATTRIBLOOKUP 
	' + 'where ATTRIBLOOKUP.TABLENAME = ''' + @AttribTable + ''' and ATTRIBLOOKUP.ATTRIBUTE = ''' + @AttribName + ''' ';	
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[AID]')
				+ ' OFFSET ' + CAST(case when @TotalRecords > @RowCountPerPage then @SkipRow else 0 end AS VARCHAR(20)) + ' ROWS '
				+ ' FETCH NEXT ' +  CAST(@RowCountPerPage AS VARCHAR(20)) + ' ROWS ONLY '
	--PRINT @SearchFilters
	--PRINT @ResultSQL
	--PRINT @execsql
	EXECUTE sp_executesql @ExecSQL
	
	--Return the page numbers and record count
	select @TotalPages TotalPages, @TotalRecords as TotalRecords;
		
	SET NOCOUNT OFF; 


END
		
		