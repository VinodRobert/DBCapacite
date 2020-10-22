/****** Object:  Procedure [dbo].[sp_GetLookupData_Contracts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Returns the contracts lookup data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- 2020-06-30 RiaanE
-- Added attributes
-- 2020-07-02 RiaanE
-- Added proj number
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_Contracts] (
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
  SET @AttrTableName = 'CONTRACTS';
  
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

	SET @ExecSql = 'SELECT contrid, contrnumber, contrname, projnumber, projname, borgid, borgname, status ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + ',' + @Attrcols + ' ';
  END;
  
  SET @ExecSql = @ExecSql + ' FROM (
  ' + 'SELECT CONTRACTS.CONTRID contrid, CONTRACTS.CONTRNUMBER contrnumber, RTRIM(CONTRACTS.CONTRNAME) contrname, RTRIM(PROJECTS.ProjNumber) projnumber, RTRIM(PROJECTS.PROJNAME) projname, BORGS.BORGID borgid, RTRIM(BORGS.BORGNAME) borgname, CONTRACTS.CONSTATUS status ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + ',' + @Attrcols + ',[COLKEY] ';
  END;
  
	SET @ExecSql = @ExecSql + 'FROM CONTRACTS ';
  
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + 'LEFT OUTER JOIN (' + @AttrQuery + ') PRES on PRES.[COLKEY] = CONTRACTS.CONTRNUMBER ';
  END;
  
	SET @ExecSql = @ExecSql + 'Inner Join PROJECTS ON CONTRACTS.PROJID = PROJECTS.PROJID 
	' + 'Inner Join BORGS ON BORGS.BORGID = PROJECTS.BORGID
	' + 'where CONTRACTS.CONSTATUS = 0) CONTRS where 1=1 ';	
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[CONTRID]')
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
		
		