/****** Object:  Procedure [dbo].[prc_GetGridData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-22-2020
-- Description:	Returns the grid data 
-- NOTES:
-- 2020-06-22 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[prc_GetGridData] (
@SchemaName NVARCHAR(250),
@TableName NVARCHAR(250),
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
@SortString NVARCHAR(MAX) = '',
@SearchFilters NVARCHAR(MAX) = '',
@UserID BIGINT = 0,
@Lookup BIT = 0,
@AutoComplete BIT = 0,
@SessionOrgID BIGINT = -1,
@ContextOrg BIGINT = -1,
@Allocation NVARCHAR(100) = '',
@ContractNumber NVARCHAR(10) = '-1',
@Module NVARCHAR(4) = ''
)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets 

	SET NOCOUNT ON;
	DECLARE 
	@SkipRow INT,
	@ExecSQL NVARCHAR(MAX) = '',
	@Columns NVARCHAR(MAX) ,
	@sColumns NVARCHAR(MAX)

	SELECT @SortString=ISNULL(@SortString,''),@SearchFilters=ISNULL(@SearchFilters,'');

	IF @Lookup = 1 
		BEGIN
			
			SELECT @Columns = CASE WHEN LU.[Visible] = 1 THEN ISNULL(@Columns + ', ','')  + '[' + LOWER([Field]) + ']' ELSE @Columns END ,
			@TableName = LU.[TableName],@SchemaName = LU.[SchemaName],
			@SearchFilters = @SearchFilters + CASE WHEN LU.[Filter] <> '' THEN ' AND ' + LU.[Field] + ' = ' + LU.[Filter] ELSE @SearchFilters END
			FROM [GC_Lookups] LU
			WHERE LU.[LookupName] = @TableName 
			ORDER BY LU.[ColumnID]
		END
	ELSE IF @AutoComplete = 1 --With Auto Complete only one column filter and no column name in the paramter. 
		BEGIN
			
			DECLARE 
			@PerFilter NVARCHAR(MAX) = '',
			@SearchFilter NVARCHAR(MAX) = ''

			SELECT @Columns = CASE WHEN LU.[Visible] = 1 THEN ISNULL(@Columns + ', ','')  + '[' + LOWER([Field]) + ']' ELSE @Columns END ,
			@TableName = LU.[TableName],@SchemaName = LU.[SchemaName],
			@SearchFilter = CASE WHEN LU.[ColumnID] = 2 THEN ' AND ' +  LU.[Field] + ' LIKE ''%' + @SearchFilters + '%''' ELSE @SearchFilter END,
			@PerFilter += CASE WHEN LU.[Filter] <> '' THEN ' AND ' + LU.[Field] + ' = ' + LU.[Filter] ELSE @PerFilter  END 
			
			FROM [GU_Lookups] LU
			WHERE LU.[LookupName] = @TableName 
			ORDER BY LU.[ColumnID]

			SET @SearchFilters = ISNULL(@SearchFilter,'') + ISNULL(@PerFilter,'')

		END 
	ELSE
		BEGIN

			SELECT @Columns = ISNULL(@Columns + ', ','')  + CASE WHEN [DataType] IN ('Text','Select','Allocation') THEN 'RTRIM([' + LOWER([Field]) + '])' ELSE '[' + LOWER([Field]) + ']' END +  'AS [' + LOWER([Alias]) + ']'

			FROM [GC_GridColumns]
			WHERE [TableName] = @TableName AND [DataType] <> 'Lookup'
			ORDER BY [ColumnID]

			IF @SortString = '' 
				BEGIN

					SELECT @SortString = ISNULL(NULLIF(@SortString,'') + ', ','')  + '[' + LOWER([Field]) + ']' 
					FROM [GC_GridColumns]
					WHERE [TableName] = @TableName AND [DefaultSort] <> 0 
					ORDER BY [DefaultSort]

				END 

			--If there are any lookup columns then get the description from the lookuptable - Always column 2 on lookup and colum 1 used as id.
			SELECT @Columns += ',ISNULL((SELECT ' + LU.[Field] + ' FROM ' + LU.SchemaName + '.' + LU.[TableName]  + 
			' LUT WHERE LUT.' + (SELECT LUID.field FROM [GC_Lookups] LUID WHERE LUID.LookupName = GC.LookupName AND LUID.ColumnID=1)  
			+ ' = ' + @SchemaName + '.' + @TableName +  '.' + GC.LookupTargetID  + '),'''') ' + GC.[Field]
			FROM [GC_GridColumns] GC
			INNER JOIN  [GC_Lookups] LU ON LU.LookupName = GC.LookupName
			WHERE  GC.DataType = 'Lookup' AND LU.ColumnID = 2 AND GC.TableName = @TableName

		END 
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
	
	SET @ExecSql = 'SELECT 
					' + @Columns + '
				FROM [' + @SchemaName + '].[' + @TableName + '] 
				WHERE 1=1 ' + @SearchFilters +
				' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[ID]')
				+ ' OFFSET ' + CAST(@SkipRow AS VARCHAR(20)) + ' ROWS 
				FETCH NEXT ' +  CAST(@RowCountPerPage AS VARCHAR(20)) + ' ROWS ONLY '
	--PRINT @SearchFilters
	--print @execsql
	EXECUTE sp_executesql @ExecSQL
	
	--This is to establish the page numbers and record count
	SET @ExecSQL = 'SELECT CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	TotalPages,COUNT(*) TotalRecords FROM  [' + @SchemaName + '].[' + @TableName + '] WHERE 1=1 ' + @SearchFilters  
	
	EXECUTE sp_executesql @ExecSQL

	SET NOCOUNT OFF; 

END
		
		