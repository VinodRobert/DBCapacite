/****** Object:  Procedure [dbo].[sp_GetLookupData_VAT]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Returns the asset lookup data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_VAT] (
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
@SortString NVARCHAR(MAX) = '',
@SearchFilters NVARCHAR(MAX) = '',
@SessionOrgID BIGINT = -1
)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets 
	SET NOCOUNT ON;
	DECLARE 
	@SkipRow INT,
	@ResultSQL NVARCHAR(MAX) = '',
	@ExecSQL NVARCHAR(MAX) = '',
	@Columns NVARCHAR(MAX) = '',
  @useVatGroups BIT = 0,
  @PagerSQL NVARCHAR(MAX) = '',
  @TotalRecords BIGINT = -1,
  @TotalPages BIGINT = -1

	SELECT @SortString=ISNULL(@SortString,''),@SearchFilters=ISNULL(@SearchFilters,'');
  
  select @useVatGroups = USEVATGROUPS from BORGS where BORGID = @SessionOrgID;
  
  IF @useVatGroups = 1
		BEGIN
			SET @ExecSql = 'SELECT VATTYPES.VATID vatid, ltrim(rtrim(VATNAME)) vatname, VATTYPES.VATPERC vatperc, VATGROUPS.VATGC vatgc, 
      ' + ' VATGROUPS.NAME vatgroupname, VATGROUPS.ISSURCHARGE issurcharge, VATIN vatin, ISREIMB isreimb 
			' + 'FROM VATTYPES 
			' + 'LEFT OUTER JOIN VATGROUPS 
			' + 'ON VATTYPES.VATGC = VATGROUPS.VATGC 
			' + 'where STATUS = 0 and VATTYPES.BORGID = ' + convert(nvarchar, @SessionOrgID) + ' ';	
		END;
	ELSE
		BEGIN
			SET @ExecSql = 'SELECT VATTYPES.VATID vatid, ltrim(rtrim(VATNAME)) vatname, VATTYPES.VATPERC vatperc, '''' vatgc, 
      ' + ' '''' vatgroupname, 0 issurcharge, VATIN vatin, ISREIMB isreimb 
			' + 'FROM VATTYPES 
			' + 'where STATUS = 0 and VATTYPES.BORGID = ' + convert(nvarchar, @SessionOrgID) + ' ';	
		END;	
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[VATNAME]')
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
		
		