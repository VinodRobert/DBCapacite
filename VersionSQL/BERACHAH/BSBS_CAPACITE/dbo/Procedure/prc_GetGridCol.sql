/****** Object:  Procedure [dbo].[prc_GetGridCol]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Returns the grid configuration data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[prc_GetGridCol] (
	@TableName NVARCHAR(250) ,
	@UserId BIGINT,
	@Lookup BIT = 0,
	@LanguageCode NVARCHAR(10) = 'en_za',
	@Uri NVARCHAR(250),
	@GridInstanceID NVARCHAR(250))
	AS 

	BEGIN

				DECLARE @UserColumns NVARCHAR(MAX),
				@sColumns NVARCHAR(MAX) ='' ,
				@sTable NVARCHAR(50) = '',
				@LookupName NVARCHAR(100) = '',
				@sField NVARCHAR(150) = '',
				@ExecSQL NVARCHAR(MAX) = ''


				SELECT @UserColumns = [Columns] FROM GC_UserGridSettings WHERE [TableName] = @TableName AND [UserId] = @UserId AND [Uri] = @Uri AND [GridInstanceID] = @GridInstanceID

				SET @UserColumns = NULLIF(@UserColumns,'')

				IF @Lookup = 1 
					BEGIN
						SELECT 
							LU.ColumnID,
							CASE WHEN @UserColumns IS NULL THEN ROW_NUMBER() OVER (ORDER BY GC.ColumnID) ELSE UCTBL.[UserColID] END [UserColID] ,
							LOWER(LU.Field) Field,
							ISNULL((SELECT CASE @LanguageCode 
								WHEN 'en_au' THEN en_au --English Australia
								WHEN 'af' THEN af -- Afrikaans
								ELSE en_za --Default English SA
								END FROM [GC_Translations] TL WHERE TL.FieldID = GC.ID),LU.[DefaultName] ) [Name],
							CASE WHEN @UserColumns IS NULL THEN LU.DefaultName ELSE ISNULL(UCTBL.[UserColumn],'hidden') END [UserColumn],
							LU.[DataType]
				
						FROM [GC_Lookups] LU
						INNER JOIN [GC_GridColumns] GC ON GC.TableName = LU.TableName AND GC.Field = LU.Field

						LEFT JOIN (SELECT [colname] [UserColumn],[colid] [UserColID] FROM dbo.fn_SplitCols(@UserColumns,',')) UCTBL ON UCTBL.[UserColumn] = LU.[Field]
						WHERE LU.[LookupName] = @TableName AND LU.[Visible] = 1
						ORDER BY LU.ColumnID
						--Get User settings
						SELECT [ColumnFilters] columnFilters ,[SortColumns] sortColumns  ,[PageNumber] pageNumber,[RowsPerPage] rowsperpage FROM [GC_UserGridSettings] WHERE [TableName] = @TableName AND [UserId] = @UserId AND [Uri] = @Uri AND [GridInstanceID] = @GridInstanceID


					END
				ELSE
					BEGIN

						SELECT 
							GC.ColumnID,
							CASE WHEN @UserColumns IS NULL THEN ROW_NUMBER() OVER (ORDER BY GC.ColumnID) ELSE UCTBL.[UserColID] END [UserColID] ,
							LOWER(GC.Field) Field,
							LOWER(GC.Alias) Alias,
							ISNULL((SELECT CASE @LanguageCode 
								WHEN 'en_au' THEN en_au --English Australia
								WHEN 'af' THEN af -- Afrikaans
								ELSE en_za --Default English SA
								END FROM [GC_Translations] TL WHERE TL.FieldID = GC.ID),GC.[DefaultName] ) [Name],
							CASE WHEN @UserColumns IS NULL THEN GC.DefaultName ELSE ISNULL(UCTBL.[UserColumn],'hidden') END [UserColumn],
							[LookupName],[LookupTargetID],[SelectFilterField],[AutoComplete],
							[DataType],[Editable],[Updatable],[MinLength],[MaxLength]
						FROM [GC_GridColumns] GC

						LEFT JOIN (SELECT [colname] [UserColumn],[colid] [UserColID] FROM dbo.fn_SplitCols(@UserColumns,',')) UCTBL ON UCTBL.[UserColumn] = GC.[Field]
						WHERE GC.[TableName] = @TableName AND [Visible] = 1
						ORDER BY GC.ColumnID

						--Get user settings
						SELECT [ColumnFilters] columnFilters ,[SortColumns] sortColumns  ,[PageNumber] pageNumber,[RowsPerPage] rowsperpage 
						FROM [GC_UserGridSettings] WHERE [TableName] = @TableName AND [UserId] = @UserId AND [Uri] = @Uri AND [GridInstanceID] = @GridInstanceID

						--Get all select data from database to load on the columns
						DECLARE lu_cursor CURSOR FOR 
						SELECT RTRIM(GC.LookupName) LookupName ,RTRIM(GC.Field) Field FROM GC_GridColumns GC 
						WHERE GC.TableName = @TableName AND GC.DataType = 'Select'

						OPEN lu_cursor
						FETCH NEXT FROM lu_cursor INTO @LookupName,@sField

						WHILE @@FETCH_STATUS = 0 
						BEGIN

							SELECT @sTable = SE.[TableName] , 
							@sColumns = 'RTRIM(' + SE.[ValueField] + ') AS [value],' +  
							'RTRIM(' + SE.[TextField] + ') AS [text],' + 
							'''' + @sField + ''' AS [field],' + 
							'RTRIM(' + ISNULL(NULLIF(SE.[FilterField],''),'''''') + ') AS [filter]'
							FROM GC_Selects SE WHERE SE.LookupName = @LookupName
							 
							--SELECT @sTable=LU.[TableName],@sColumns =  ISNULL(@sColumns + ', ','')  + 
							--CASE WHEN LU.[DataType] IN ('Text','Select','Allocation') THEN 'RTRIM([' + LOWER(LU.[Field]) + '])' ELSE '[' + LOWER(LU.[Field]) + ']' END 
							--+ ' AS [' + CASE WHEN LU.ColumnID = 1 THEN 'value' WHEN LU.ColumnID = 3 THEN 'filter' ELSE 'text' END + ']'
							--FROM [GC_Lookups] LU  WHERE LU.LookupName = @LookupName AND LU.ColumnID IN ('1','2')

							If ISNULL(@ExecSQL, '') = ''
								BEGIN
									SET @ExecSQL = 'SELECT ' + @sColumns + ' FROM ' + @sTable
								END
							ELSE
								BEGIN
									SET @ExecSQL = ISNULL(@ExecSQL + CHAR(10) + ' UNION ' + CHAR(10) ,'') + 'SELECT ' + @sColumns + ' FROM ' + @sTable
								END

							SET @sColumns = NULL
							FETCH NEXT FROM lu_cursor INTO @LookupName,@sField
						END 

						CLOSE lu_cursor
						DEALLOCATE lu_cursor
            
            SET @ExecSQL = @ExecSQL + ' select distinct ATTRIBUTE as Field, -1 as ColumnID, -1 as UserColID, ATTRIBUTE as Alias, ATTRIBUTE as [Name], ATTRIBUTE as UserColumn, null as LookupName, null as LookupTargetID,
						' + ' '''' as SelectFilterField, 0 as AutoComplete, ''Text'' as DataType, 0 as Editable, 0 as Updatable, 1 as MinLength, COLSIZE as MaxLength
						' + ' from ATTRIBDEFINITION where TABLENAME = ''' + @TableName + ''' AND ISSEARCH = 1 '
            
						--exec PrintString @ExecSQL
						EXECUTE sp_executesql @ExecSQL

					END

	END
		
		