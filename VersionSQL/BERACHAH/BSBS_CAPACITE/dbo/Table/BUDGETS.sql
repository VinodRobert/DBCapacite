/****** Object:  Table [dbo].[BUDGETS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BUDGETS](
	[BorgID] [int] NOT NULL,
	[ContractID] [int] NOT NULL,
	[ContractNo] [nvarchar](10) NOT NULL,
	[ActivityID] [int] NOT NULL,
	[ActivityNo] [char](10) NOT NULL,
	[LedgerID] [int] NOT NULL,
	[LedgerNo] [char](10) NOT NULL,
	[YearNo] [char](10) NOT NULL,
	[Period] [int] NOT NULL,
	[Budget] [money] NOT NULL,
	[BudgetID] [int] IDENTITY(1,1) NOT NULL,
	[OREst] [money] NOT NULL,
	[FFCost] [money] NOT NULL,
	[AIVar] [money] NOT NULL,
	[ACVar] [money] NOT NULL,
	[QTY] [decimal](18, 4) NOT NULL,
	[BUDGETFE] [decimal](18, 4) NOT NULL,
	[QTYFE] [decimal](18, 4) NOT NULL,
	[BUDGETBILLED] [decimal](18, 4) NOT NULL,
	[QTYBILLED] [decimal](18, 4) NOT NULL,
	[BUDGETTP] [decimal](18, 4) NOT NULL,
	[QTYTP] [decimal](18, 4) NOT NULL,
	[SYSDATE] [datetime] NOT NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_BUDGETS_BorgID_ContractID_ActivityID_LedgerID] ON [dbo].[BUDGETS]
(
	[BorgID] ASC,
	[ContractID] ASC,
	[ActivityID] ASC,
	[LedgerID] ASC
)
INCLUDE([YearNo],[Period],[BUDGETTP],[QTYTP]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_ContractNo]  DEFAULT ('') FOR [ContractNo]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_ActivityNo]  DEFAULT ('') FOR [ActivityNo]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_LedgerNo]  DEFAULT ('') FOR [LedgerNo]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_Budget]  DEFAULT (0.00) FOR [Budget]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_OrigRevEst]  DEFAULT (0) FOR [OREst]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_FFCost]  DEFAULT (0) FOR [FFCost]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_AIVar]  DEFAULT (0) FOR [AIVar]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_ACVar]  DEFAULT (0) FOR [ACVar]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_QTY]  DEFAULT ((0)) FOR [QTY]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_BUDGETFE]  DEFAULT ((0)) FOR [BUDGETFE]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_QTYFE]  DEFAULT ((0)) FOR [QTYFE]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_BUDGETBILLED]  DEFAULT ((0)) FOR [BUDGETBILLED]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_QTYBILLED]  DEFAULT ((0)) FOR [QTYBILLED]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_BUDGETTP]  DEFAULT ((0)) FOR [BUDGETTP]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_QTYTP]  DEFAULT ((0)) FOR [QTYTP]
ALTER TABLE [dbo].[BUDGETS] ADD  CONSTRAINT [DF_BUDGETS_SYSDATE]  DEFAULT (getdate()) FOR [SYSDATE]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERBUDGETS ON BUDGETS
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'BUDGETS'
set @primaryKey = 'BUDGETID'
set @ignoreList = ''

declare @action varChar(25)
declare @logUserID int
declare @logDateTime datetime
declare @borgid int
declare @page varChar(100)
declare @info varChar(250)
declare @application varChar(3)
declare @version varChar(15)
declare @context_info int
declare @sqlTblCols nVarChar(max)
declare @sql nVarChar(max)

set @context_info = -1
set @ignoreList = ',' + replace(@ignoreList, ' ', '') + ','
set @action = ''
set @logUserID = -1
set @logDateTime = DATEADD(M, -1, getDate()) 
set @borgid = -1
set @page = ''
set @info = ''
set @application = ''
set @version = ''
set @sqlTblCols = ''
set @sql = ''

if exists(select * from INSERTED)
BEGIN
	if exists(select * from DELETED)
	BEGIN
		set @action = 'UPDATE'
	END
	ELSE
	BEGIN
		set @action = 'INSERT'
	END
END
ELSE
BEGIN
	if exists(select * from DELETED)
	BEGIN
		set @action = 'DELETE'
	END
END
 
select * into #inserted from INSERTED
select * into #deleted from DELETED

SELECT @context_info = cast(replace(cast(CONTEXT_INFO as varchar(128)), char(0) COLLATE SQL_Latin1_General_CP1_CI_AS,'') as int) FROM master.dbo.sysprocesses WHERE spid = @@SPID

select @logUserID = isnull(USERID, -1),
@logDateTime = isnull(LOGDATETIME, DATEADD(M, -1, getDate())),
@borgid = isnull(BORGID, @borgid),
@page = isnull(PAGE, @page),
@info = isnull(INFO, @info),
@application  = isnull(APPLICATION, @application),
@version = isnull(VERSION, @version)
from logcontext 
where LOGID = @context_info
	
delete FROM LOGCONTEXT where LOGID = @context_info
   
if @action = 'UPDATE'
BEGIN		
	Select @sqlTblCols = @sqlTblCols + 'Case when rtrim(cast(IsNull(i.[' + Column_Name + '],0) as varChar(100)))=rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100))) then '''' else ' + '''[' + Column_Name + ']:'' + rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + ''' + ' -> '' + rtrim(cast(IsNull(i.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + ''' + ''' + '', ''' + ' end +'
	from information_schema.columns 
	where TABLE_NAME = @tableName
	and PATINDEX('%,' + COLUMN_NAME + ',%', @ignoreList) = 0
	and DATA_TYPE not like '%text%'
	and DATA_TYPE not like '%image%'
	and DATA_TYPE not like '%binary%' 
		
	set @sqlTblCols = Substring(@sqlTblCols, 1 , len(@sqlTblCols) - 1)

	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', '''+ @primaryKey +' = '' + cast(i.'+ @primaryKey +' as varChar(10)), Substring(' + @sqlTblCols + ', 1 , len(' + @sqlTblCols + ') - 1) '
	set @sql = @sql + 'From #inserted i inner join #deleted d on i.'+ @primaryKey +' = d.'+ @primaryKey +' where isnull(' + @sqlTblCols + ', '''') <> '''' ' 

	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END   

if @action = 'DELETE' or @action = 'INSERT'
BEGIN
	Select @sqlTblCols = @sqlTblCols + '''[' + Column_Name + ']:'' + rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + '', '' + '
	from information_schema.columns 
	where TABLE_NAME = @tableName
	and PATINDEX('%,' + COLUMN_NAME + ',%', @ignoreList) = 0
	and DATA_TYPE not like '%text%'
	and DATA_TYPE not like '%image%'
	and DATA_TYPE not like '%binary%' 
		
	set @sqlTblCols = Substring(@sqlTblCols, 1, len(@sqlTblCols) - 5) + ''''
	
	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', '''+ @primaryKey +' = '' + cast(d.'+ @primaryKey +' as varChar(10)), ' + @sqlTblCols + ' '
	set @sql = @sql + 'From '+ case when @action = 'DELETE' then '#deleted' else '#inserted' end +' d ' 
 
	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END

DROP TABLE #inserted
DROP TABLE #deleted

		
ALTER TABLE [dbo].[BUDGETS] ENABLE TRIGGER [LOGMASTERBUDGETS]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER TR_BUDGETSSNAPSHOT ON BUDGETS
AFTER UPDATE
AS 

SET NOCOUNT ON

insert into BUDGETSSNAPSHOT (BUDGETID, QTY, BUDGET, SYSDATE)
SELECT D.BUDGETID, D.QTY, D.BUDGET, getDate()
FROM INSERTED I inner join DELETED D on I.BUDGETID = D.BUDGETID
WHERE I.QTY <> D.QTY
OR I.BUDGET <> D.BUDGET

		
ALTER TABLE [dbo].[BUDGETS] ENABLE TRIGGER [TR_BUDGETSSNAPSHOT]