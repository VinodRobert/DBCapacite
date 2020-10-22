/****** Object:  Procedure [dbo].[prc_Save_UserGridSettings]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Save the grid configuration data
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[prc_Save_UserGridSettings] (
@TableName NVARCHAR(250),
@UserID BIGINT,
@Columns NVARCHAR(MAX) = '',
@ColumnFilters NVARCHAR(MAX) = '',
@SortColumns NVARCHAR(MAX) = '',
@PageNumber INT = 1,
@RowsPerPage INT = 50,
@Uri NVARCHAR(250),
@GridInstanceID NVARCHAR(250)
)

AS 

BEGIN 

	IF EXISTS(SELECT * FROM dbo.[GC_UserGridSettings] WHERE UserID = @UserID AND TableName = @TableName AND [Uri] = @Uri AND [GridInstanceID] = @GridInstanceID) 
		BEGIN 
			UPDATE dbo.[GC_UserGridSettings] SET
				[Columns] = @Columns,
				[ColumnFilters] = @ColumnFilters,
				[SortColumns] = @SortColumns,
				[PageNumber] = @PageNumber ,
				[RowsPerPage] = @RowsPerPage,
				[Uri] = @Uri,
				[GridInstanceID] = @GridInstanceID
			WHERE UserID = @UserID AND TableName = @TableName AND [Uri] = @Uri AND [GridInstanceID] = @GridInstanceID
		END
	ELSE
		BEGIN 
			INSERT INTO dbo.[GC_UserGridSettings] 
				([TableName],[UserID],[Columns],[ColumnFilters],[SortColumns],[PageNumber],[RowsPerPage], [Uri], [GridInstanceID])
			VALUES
				(@TableName,@UserID,@Columns,@ColumnFilters,@SortColumns,@PageNumber,@RowsPerPage, @Uri, @GridInstanceID)

		END


END 
		
		