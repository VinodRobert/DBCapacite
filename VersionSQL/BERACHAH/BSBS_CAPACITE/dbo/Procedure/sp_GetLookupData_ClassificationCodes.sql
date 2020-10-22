/****** Object:  Procedure [dbo].[sp_GetLookupData_ClassificationCodes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 07-14-2020
-- Description:	Returns the classification codes lookup data 
-- NOTES:
-- 2020-07-14 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_ClassificationCodes] (
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
@SortString NVARCHAR(MAX) = '',
@SearchFilters NVARCHAR(MAX) = ''
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
  
  SET @ExecSql = 'SELECT id, code, [type], [description], tax1, tax2, tax3, tax4 FROM 
  ' + '(SELECT ID as id, CLASSIFICATIONCODES.CODE code, ltrim(rtrim(CLASSIFICATIONCODES.TYPE)) [type], ltrim(rtrim(CLASSIFICATIONCODES.DESCRIPTION)) [description], 
	' + 'case when TAX1USE = 0 then null else TAX1 end tax1, case when TAX2USE = 0 then null else TAX2 end tax2, 
	' + 'case when TAX3USE = 0 then null else TAX3 end tax3, case when TAX4USE = 0 then null else TAX4 end tax4
	' + 'FROM CLASSIFICATIONCODES 
	' + 'WHERE CLASSIFICATIONCODES.STATUS = 1) CCODES where 1=1 ';
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[code]')
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
		
		