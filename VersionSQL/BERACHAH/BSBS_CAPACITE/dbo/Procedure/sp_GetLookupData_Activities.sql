/****** Object:  Procedure [dbo].[sp_GetLookupData_Activities]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 06-11-2020
-- Description:	Returns the activities lookup data 
-- NOTES:
-- 2020-06-11 RiaanE
--  Added the procedure
-- 2020-06-30 RiaanE
-- Added attributes
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetLookupData_Activities] (
@PageNo INT = 1, 
@RowCountPerPage INT = 50, 
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
  @Attrcols NVARCHAR(MAX) = '',
  @AttrTableName NVARCHAR(55) = '',
  @AttrQuery NVARCHAR(MAX) = '',
  @PagerSQL NVARCHAR(MAX) = '',
  @TotalRecords BIGINT = -1,
  @TotalPages BIGINT = -1,
  @useLedgerCodeGroups bit = 0,
  @BorgForeignD bit = 0,
	@UserAllowIC bit = 0,
	@lcgBorg BIGINT = -1,
  @contrid INT
  
  IF @Module = 'ACC'
		BEGIN
			select @useLedgerCodeGroups = USELEDGERCODEGROUPSACC from BORGS where BORGID = @SessionOrgID;
		END;
	ELSE IF @Module = 'POS'
		BEGIN
			select @useLedgerCodeGroups = USELEDGERCODEGROUPS from BORGS where BORGID = @SessionOrgID;
		END;
  
  -- ======= Start Attributes
  SET @AttrTableName = 'ACTIVITIES';
  
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

	SET @ExecSql = 'SELECT DISTINCT(rtrim(ltrim(ACTIVITIES.ACTNUMBER))) actnumber, rtrim(ltrim(ACTIVITIES.ACTNAME)) actname, ACTSTATUS AS actstatus ';
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + ',' + @Attrcols + ',[COLKEY] ';
  END;
  
  IF(@useLedgerCodeGroups = 1)
		BEGIN
			SET @lcgBorg = case when @BorgForeignD = 1 or @UserAllowIC = 1 then @ContextOrg else @SessionOrgID end;
      SET @ExecSql = @ExecSql + 'FROM ACTIVITIESALLOWED as ACTIVITIES ';
		END;
	ELSE
		BEGIN
			SET @ExecSql = @ExecSql + 'FROM ACTIVITIES ';
		END;
  
  if isnull(@Attrcols, '') <> ''
  BEGIN
		SET @ExecSql = @ExecSql + 'LEFT OUTER JOIN (' + @AttrQuery + ') PRES on PRES.[COLKEY] = ACTIVITIES.ActID ';
  END;
  
	SET @ExecSql = @ExecSql + 'where ACTSTATUS < 2 AND isnull(ACTIVITIES.ACTNUMBER, '''') <> '''' ';	
  
  IF(@useLedgerCodeGroups = 1)
		BEGIN
      SET @ExecSql = @ExecSql + 'AND SYS = ''' + @Module + ''' ';
		END;
    
  IF(@useLedgerCodeGroups = 1 AND @ContractNumber <> '')
		BEGIN
			SELECT TOP 1 @contrid = CONTRID FROM CONTRACTS WHERE CONTRNUMBER = @ContractNumber;
      SET @ExecSql = @ExecSql + 'AND CONTRID = ' + CAST(@contrid as NVARCHAR(50)) + ' ';
		END;
		
	SET @SkipRow = (@PageNo - 1) * @RowCountPerPage
	
	SET @ResultSQL = @ExecSql +  @SearchFilters
  
  --This is to establish the page numbers and record count
	SET @PagerSQL = CAST(N' SELECT @TotalPages = CEILING(COUNT(*) / CAST(' + CAST(@RowCountPerPage AS VARCHAR(200)) + ' AS DECIMAL(18,2))) 
	,@TotRecords = COUNT(*) FROM  (' + @ResultSQL + ') ROWCNT ' as NVARCHAR(MAX));
	EXECUTE sp_executesql @PagerSQL, N'@TotalPages BIGINT OUTPUT, @TotRecords BIGINT OUTPUT', @TotalPages = @TotalPages OUTPUT, @TotRecords = @TotalRecords OUTPUT

	SET @ExecSql = @ResultSQL + ' ORDER BY ' + ISNULL(NULLIF(@SortString,''),'[ACTNUMBER]')
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
		
		