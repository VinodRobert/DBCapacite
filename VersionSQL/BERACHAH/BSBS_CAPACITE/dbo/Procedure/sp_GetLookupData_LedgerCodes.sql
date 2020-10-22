/****** Object:  Procedure [dbo].[sp_GetLookupData_LedgerCodes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Returns the ledger codes lookup data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- 2020-06-30 RiaanE
-- Added attributes
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_LedgerCodes] (
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
@Allocation NVARCHAR(100),
@SortString NVARCHAR(MAX) = '',
@SearchFilters NVARCHAR(MAX) = '',
@SessionOrgID BIGINT = -1,
@ContextOrg BIGINT = -1,
@Module NVARCHAR(4) = '',
@UserID BIGINT = 0,
@ContractNumber NVARCHAR(10) = ''
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
	@useLedgerCodeGroups bit = 0,
	@BorgForeignD bit = 0,
	@UserAllowIC bit = 0,
	@lcgBorg BIGINT = -1,
  @Attrcols NVARCHAR(MAX) = '',
  @AttrTableName NVARCHAR(55) = '',
  @AttrQuery NVARCHAR(MAX) = '',
  @PagerSQL NVARCHAR(MAX) = '',
  @TotalRecords BIGINT = -1,
  @TotalPages BIGINT = -1

	IF @Module = 'ACC'
		BEGIN
			select @useLedgerCodeGroups = USELEDGERCODEGROUPSACC from BORGS where BORGID = @SessionOrgID;
		END;
	ELSE IF @Module = 'POS'
		BEGIN
			select @useLedgerCodeGroups = USELEDGERCODEGROUPS from BORGS where BORGID = @SessionOrgID;
		END;
    
  -- ======= Start Attributes
  SET @AttrTableName = 'LEDGERCODES';
  
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

	-- Get intercompany and user settings
	select @UserAllowIC = U.ALLOWIC, @BorgForeignD = B.FOREIGND   
	FROM USERSINBORG UO 
	INNER JOIN BORGS B on UO.BORGID = B.BORGID 
	INNER JOIN USERS U on U.USERID = UO.USERID 
	LEFT OUTER JOIN CURRENCIES C on C.CURRCODE = B.CURRENCY 
	LEFT OUTER JOIN PERIODSETUP P on P.ORGID = B.BORGID and P.PERIOD = B.PERIOD and P.YEAR = B.CURRENTYEAR 
	LEFT OUTER JOIN PERIODSETUP PS on PS.ORGID = B.BORGID and PS.PERIOD = (B.PERIOD - 1) and PS.YEAR = B.CURRENTYEAR and PS.PEDATE < P.PEDATE 
	where UO.USERID = @UserID and UO.BORGID = @SessionOrgID

	SELECT @SortString=ISNULL(@SortString,''),@SearchFilters=ISNULL(@SearchFilters,'');

	--if alloc = "Stock" or alloc = "Workshop Recovery" then
	IF @Allocation <> 'Contracts,Balance Sheet' and @Allocation <> 'Balance Sheet' and @Allocation <> 'Contracts' and @Allocation <> 'Overheads' and @Allocation <> 'Plant' and @Allocation <> ''
	BEGIN
		SET @ExecSql = 'declare @controlFromGL char(10), @controlToGL char(10) 
		' + 'select @controlFromGL = RTRIM(IsNull(CONTROLFROMGL, '')), @controlToGL = RTRIM(IsNull(CONTROLTOGL, '')) from controlcodes where controlname = N' + @Allocation + ' '
	END

	SET @ExecSql = @ExecSql + 'SELECT DISTINCT(LEDGERCODE) ledgercode, ledgername, RTRIM([ledgeralloc]) as [ledgeralloc], LEDGERSUMMARY ledgersummary, 
		' + 'isnull(CONTROLCODES.CONTROLNAME, '''') controlname, ledgerid ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + ',' + @Attrcols + ',[COLKEY] ';
  END; 

	IF(@useLedgerCodeGroups = 1) and (@Allocation = 'Balance Sheet' or @Allocation = 'Contracts' or @Allocation = 'Overheads' or @Allocation = 'Plant')
		BEGIN
			SET @lcgBorg = case when @BorgForeignD = 1 or @UserAllowIC = 1 then @ContextOrg else @SessionOrgID end;
			SET @ExecSql = @ExecSql + 'from getLedgerCodesInGroup( ' + CONVERT(nvarchar, @lcgBorg) + ', ''' + isnull(@ContractNumber,  '') + ''', -1, '''', '''', '''',  ''' + @Allocation + ''', ''' + @Module + ''') as LEDGERCODES '
		END;
	ELSE
		BEGIN
			SET @ExecSql = @ExecSql + 'from LEDGERCODES '
		END;
    
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + 'LEFT OUTER JOIN (' + @AttrQuery + ') PRES on PRES.[COLKEY] = LEDGERCODES.LEDGERCODE ';
  END;

	SET @ExecSql = @ExecSql + 'OUTER APPLY (SELECT TOP 1 CONTROLCODES.CONTROLNAME FROM CONTROLCODES WHERE LEDGERCODES.LEDGERCODE BETWEEN CONTROLCODES.CONTROLFROMGL AND CONTROLCODES.CONTROLTOGL ORDER BY CONTROLCODES.CONTROLFROMGL) CONTROLCODES 
		' + 'where LEDGERCODES.LEDGERSUMMARY <> 1 
		' + 'AND LEDGERCODES.LEDGERCONTROL <> 1 
		' + 'AND LEDGERCODES.LEDGERSTATUS = 0 '

	--if alloc = "Stock" or alloc = "Workshop Recovery" then
	IF @Allocation <> 'Contracts,Balance Sheet' and @Allocation <> 'Balance Sheet' and @Allocation <> 'Contracts' and @Allocation <> 'Overheads' and @Allocation <> 'Plant' and @Allocation <> ''
	BEGIN
		SET @ExecSql = @ExecSql + 'AND LEDGERCODES.LEDGERCODE between @controlFromGL and @controlToGL '
	END

	IF @Allocation = 'Stock'
	BEGIN
		SET @Allocation = 'Balance Sheet'
	END

	IF @Allocation <> ''
	BEGIN
		IF @Allocation = 'Contracts,Balance Sheet' or @Allocation = 'Balance Sheet' or @Allocation = 'Contracts' or @Allocation = 'Overheads' or @Allocation = 'Plant'
		BEGIN
			SET @ExecSql = @ExecSql + 'and LEDGERCODES.LEDGERALLOC in (N''' + RTRIM(replace(@Allocation,',',''',N''')) + ''') '
		END
	END
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
  
  SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[LEDGERCODE]')
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
		
		