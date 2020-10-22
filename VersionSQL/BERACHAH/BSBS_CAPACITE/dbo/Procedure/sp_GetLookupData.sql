/****** Object:  Procedure [dbo].[sp_GetLookupData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-22-2020
-- Description:	Returns the lookup data for type
-- NOTES:
-- 2020-06-22 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData] (
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
@AttribTable NVARCHAR(55) = '',
@AttribName NVARCHAR(55) = '',
@ContractNumber NVARCHAR(10) = '-1',
@Module NVARCHAR(4) = '',
@AllowTrans NVARCHAR(250) = '|'
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

	IF ISNULL(@TableName, '') <> ''
		BEGIN
			IF @TableName = 'LEDGERCODES'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_LedgerCodes @PageNo, @RowCountPerPage, @Allocation, @SortString, @SearchFilters, @SessionOrgID, @ContextOrg, @Module, @UserID, @ContractNumber'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @Allocation NVARCHAR(100), @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX), @SessionOrgID BIGINT, @ContextOrg BIGINT, @Module NVARCHAR(4), @UserID BIGINT, @ContractNumber NVARCHAR(10)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @Allocation = @Allocation, @SortString = @SortString, @SearchFilters = @SearchFilters, @SessionOrgID = @SessionOrgID, @ContextOrg = @ContextOrg, @Module = @Module, @UserID = @UserID, @ContractNumber = @ContractNumber
				END
			ELSE IF @TableName = 'ACTIVITIES'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Activities @PageNo, @RowCountPerPage, @SortString, @SearchFilters, @SessionOrgID, @ContextOrg, @Module, @UserID, @ContractNumber'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX), @SessionOrgID BIGINT, @ContextOrg BIGINT, @Module NVARCHAR(4), @UserID BIGINT, @ContractNumber NVARCHAR(10)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters, @SessionOrgID = @SessionOrgID, @ContextOrg = @ContextOrg, @Module = @Module, @UserID = @UserID, @ContractNumber = @ContractNumber
				END
			ELSE IF @TableName = 'CREDITORS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Creditors @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'CONTRACTS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Contracts @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'CREDCAT'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_CredCat @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'PROJECTS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Projects @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'DIVISIONS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Divisions @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'PLANTANDEQ'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Plant @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'ORGS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Organisations @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'DEBTORS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Debtors @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'SUBCONTRACTORS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Subcontractors @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'ASSETS'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Assets @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'WHT'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_WHT @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
			ELSE IF @TableName = 'VAT'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_VAT @PageNo, @RowCountPerPage, @SortString, @SearchFilters, @SessionOrgID'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX), @SessionOrgID BIGINT',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters, @SessionOrgID = @SessionOrgID
				END
      ELSE IF @TableName = 'ATTRIBUTES'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_Attributes @PageNo, @RowCountPerPage, @SortString, @SearchFilters, @AttribTable, @AttribName'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX), @AttribTable NVARCHAR(55), @AttribName NVARCHAR(55)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters, @AttribTable = @AttribTable, @AttribName = @AttribName
				END
      ELSE IF @TableName = 'CLASSIFICATIONCODES'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_ClassificationCodes @PageNo, @RowCountPerPage, @SortString, @SearchFilters'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters
				END
      ELSE IF @TableName = 'TRANSTYPES'
				BEGIN
					SET @ExecSQL = 'dbo.sp_GetLookupData_TransTypes @PageNo, @RowCountPerPage, @SortString, @SearchFilters, @SessionOrgID, @AllowTrans'
					--PRINT @ExecSQL
					EXECUTE sp_executesql @ExecSQL, N'@PageNo INT, @RowCountPerPage INT, @SortString NVARCHAR(MAX), @SearchFilters NVARCHAR(MAX), @SessionOrgID BIGINT, @AllowTrans NVARCHAR(250)',
					@PageNo = @PageNo, @RowCountPerPage = @RowCountPerPage, @SortString = @SortString, @SearchFilters = @SearchFilters, @SessionOrgID = @SessionOrgID, @AllowTrans = @AllowTrans
				END
			ELSE
				BEGIN
					RAISERROR ( 'Master lookup table name was not found.',1,1);
				END
		END
	ELSE
		BEGIN
			RAISERROR ( 'Master lookup table name was not supplied.',1,1);
		END 
	SET NOCOUNT OFF;

END
		
		