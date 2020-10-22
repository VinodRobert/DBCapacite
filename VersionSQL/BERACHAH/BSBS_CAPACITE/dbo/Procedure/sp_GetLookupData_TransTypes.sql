/****** Object:  Procedure [dbo].[sp_GetLookupData_TransTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 07-21-2020
-- Description:	Returns the transaction type lookup data 
-- NOTES:
-- 2020-07-21 RiaanE
--  Added the procedure
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_TransTypes] (
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
@SortString NVARCHAR(MAX) = '',
@SearchFilters NVARCHAR(MAX) = '',
@SessionOrgID BIGINT = -1,
@AllowTrans NVARCHAR(250) = '|'
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
  @PagerSQL NVARCHAR(MAX) = '',
  @TotalRecords BIGINT = -1,
  @TotalPages BIGINT = -1

	SELECT @SortString=ISNULL(@SortString,''),@SearchFilters=ISNULL(@SearchFilters,'');

	SET @ExecSql = 'SELECT T.ID as [id], T.TYPENAME as typename, ltrim(rtrim(T.TYPEDESC)) as typedesc 
	' + ' FROM (
	' + '	SELECT ROW_NUMBER() OVER(ORDER BY TRANSTYPES.TYPENAME) AS ID, 
	' + '	TRANSTYPES.TYPENAME, TRANSTYPES.TYPEDESC,  
	' + '	cast(max(case when CONTROLCODES.ControlName = ''BANK'' then case when isnull(B.BANKLEDGER, '''') = '''' then 0 else 1 end else 1 end) as bit) EXCLUDEONBANK 
	' + '	FROM TRANSTYPES 
	' + '	left outer join CONTROLCODES 
	' + '	on TRANSTYPES.TYPEOPPGLCODE between CONTROLCODES.ControlFromGL and CONTROLCODES.ControlToGL 
	' + '	and CONTROLCODES.ControlName = ''BANK'' 
	' + '	left outer join LEDGERCODES 
	' + '	on TRANSTYPES.TypeOppGlCode = LedgerCodes.LedgerCode 
	' + '	left outer join (SELECT DISTINCT BANKLEDGER, CHEQUEFORMATHEADER.CHID from BANKS 
	' + '			OUTER APPLY (select top 1 CHID from CHEQUEFORMATHEADER WHERE CHEQUEFORMATHEADER.CHID = BANKS.CHID and CHEQUEFORMATHEADER.BORGID in (-1, BANKS.BANKBORGID)) CHEQUEFORMATHEADER 
	' + '			where BANKS.BANKBORGID = ' + CAST(@SessionOrgID as NVARCHAR(100)) + ') B on isnull(B.BANKLEDGER, '''') = case when CONTROLCODES.ControlName = ''BANK'' then TRANSTYPES.TYPEOPPGLCODE else isnull(B.BANKLEDGER, '''') end 
	' + '			GROUP BY TRANSTYPES.TYPENAME, TRANSTYPES.TYPEDESC  
	' + ' ) T 
	' + ' left outer join (
	' + '	select ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS ID, Items
	' + '	from dbo.split(''' + @AllowTrans + ''',''|'') 
	' + ' ) R on T.ID = R.ID 
	' + ' WHERE rtrim(TYPEDESC) <> '''' 
	' + ' AND T.EXCLUDEONBANK = 1 
	' + ' AND isnull(R.items, 1) = ''1'' ';
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[TYPENAME]')
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
		
		