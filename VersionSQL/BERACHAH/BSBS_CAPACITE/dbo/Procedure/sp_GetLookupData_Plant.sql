/****** Object:  Procedure [dbo].[sp_GetLookupData_Plant]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Returns the plant lookup data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- 2020-6-30 RiaanE
-- Added attributes
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_Plant] (
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
	@Columns NVARCHAR(MAX) = '',
  @Attrcols NVARCHAR(MAX) = '',
  @AttrTableName NVARCHAR(55) = '',
  @AttrQuery NVARCHAR(MAX) = '',
  @PagerSQL NVARCHAR(MAX) = '',
  @TotalRecords BIGINT = -1,
  @TotalPages BIGINT = -1
  
  -- ======= Start Attributes
  SET @AttrTableName = 'PLANTANDEQ';
  
  SET @Attrcols = STUFF((SELECT distinct ',' + QUOTENAME(c.ATTRIBUTE) 
		FROM ATTRIBDEFINITION c where TABLENAME = @AttrTableName AND ISSEARCH = 1
		FOR XML PATH(''), TYPE
		).value('.', 'NVARCHAR(MAX)') 
		,1,1,'');
    
   if isnull(@Attrcols, '') <> ''
   BEGIN
   SET @AttrQuery = 'SELECT ' + @Attrcols + ',[COLKEY] FROM 
            (
                SELECT y.*
                FROM ATTRIBVALUE t
                CROSS APPLY 
                (
                    VALUES (t.ATTRIBUTE,CONVERT(NVARCHAR(150),t.[VALUE]),t.COLKEY)
                ) y (ATTRIBUTE, [VALUE], COLKEY)
				where TABLENAME = ''' + @AttrTableName + '''
           ) x
            PIVOT 
            (
                MAX([VALUE])
                FOR ATTRIBUTE IN (' + @Attrcols + ',Data)               
            ) p';
   END;
   -- ======= End Attributes

	SELECT @SortString=ISNULL(@SortString,''),@SearchFilters=ISNULL(@SearchFilters,'');

	SET @ExecSql = 'SELECT penumber, pename, pestatus, borgid, borgname, catname ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + ',' + @Attrcols + ',[COLKEY] ';
  END; 
  
  SET @ExecSql = @ExecSql + 'FROM (SELECT PLANTANDEQ.PeNumber penumber, PLANTANDEQ.PeName pename, PLANTANDEQ.PeStatus pestatus, PLANTANDEQ.BorgId borgid, Borgs.BorgName borgname, PLANTCATEGORIES.CatName catname ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + ',' + @Attrcols + ',[COLKEY] ';
  END;
	SET @ExecSql = @ExecSql + 'FROM PLANTANDEQ LEFT OUTER JOIN PLANTCATEGORIES ON PLANTANDEQ.CatID = PLANTCATEGORIES.CatID 
	' + 'INNER JOIN BORGS ON PLANTANDEQ.BORGID=BORGS.BORGID ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + 'LEFT OUTER JOIN (' + @AttrQuery + ') PRES on PRES.[COLKEY] = PLANTANDEQ.PeNumber ';
  END;
	SET @ExecSql = @ExecSql + 'where PLANTANDEQ.PESTATUS < 2) PLNT where 1=1 ';	
  
  SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[PeNumber]')
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
		
		