/****** Object:  Procedure [dbo].[prc_InsertGridColumns]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Insert grid table configuration data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[prc_InsertGridColumns] (@TableName NVARCHAR(250)) 

AS

BEGIN

IF NOT EXISTS (SELECT * FROM [gc_GridColumns] WHERE TableName = @TableName) 
	BEGIN
		INSERT INTO [GC_GridColumns]
		SELECT 
				T.[Name] TableName,
				ROW_NUMBER() OVER (ORDER BY C.column_id) [ColumnID],
				LOWER(C.[name])  [Field],
				LOWER(C.[name])  [Alias],
				CASE WHEN COLUMNPROPERTY(T.[object_id], C.[name], 'isIdentity') = 1 THEN 0 ELSE 1 END Visible,
				CASE WHEN COLUMNPROPERTY(T.[object_id], C.[name], 'isIdentity') = 1 THEN 0 ELSE 1 END Editable,
				1 Updatable,
				C.[name] [DefaultName],
				CASE 
					WHEN C.[name] = 'Percentage' 
					THEN 'PercentComplete' 
				ELSE
					CASE ST.[name] 
					WHEN 'bigint' THEN 'Integer'
					WHEN 'nvarchar' THEN 'Text'
					WHEN 'date' THEN 'Date'
					WHEN 'datetime' THEN 'Date'
					WHEN 'datetimeoffset' THEN 'DateTimeOffset'
					WHEN 'decimal' THEN 'Decimal'
					WHEN 'float' THEN 'Decimal'
					WHEN 'image' THEN 'other'
					WHEN 'int' THEN 'Integer'
					WHEN 'money' THEN 'Decimal'
					WHEN 'bit' THEN 'CheckBox'
					ELSE 'other' END 
				END [DataType],
				'' [LookupName],
				'' [LookupTargetID],
				'' [SelectFilterField],
				0 [AutoComplete],
				0 MinLength,C.max_length [MaxLength],
				COLUMNPROPERTY(T.[object_id], C.[name], 'isIdentity') [DefaultSort], '' [DataProcedure]
			FROM SYS.OBJECTS T 
			INNER JOIN SYS.COLUMNS C ON C.[object_id]=T.[object_id]
			INNER JOIN [MASTER]..SYSTYPES ST ON C.system_type_id = ST.xusertype	 
			WHERE T.Name = @TableName 
			ORDER BY C.column_id
		END
	ELSE 
		BEGIN
			SELECT 'Table Already Exists in GC_GridColumns'
		END 

END
		
		