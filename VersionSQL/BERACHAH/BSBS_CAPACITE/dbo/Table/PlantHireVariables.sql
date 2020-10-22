/****** Object:  Table [dbo].[PlantHireVariables]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireVariables](
	[HireVHrPerDay] [numeric](18, 2) NULL,
	[HireVDayPerWeek] [numeric](18, 1) NULL,
	[HireVDayPerMonth] [numeric](18, 1) NULL,
	[ShowRateInMaster] [bit] NOT NULL,
	[HireVFirstDayOfWeeek] [int] NOT NULL,
	[GriDepCharge] [numeric](18, 2) NULL,
	[GriIsurCharge] [numeric](18, 2) NULL,
	[GriIsurChargeGlPlt] [char](10) NULL,
	[GriIsurChargeGl] [char](10) NULL,
	[GriOverhCharge] [numeric](18, 2) NULL,
	[GriOverhChargeGlPlt] [char](10) NULL,
	[GriOverhChargeGL] [char](10) NULL,
	[GriIntrestCharge] [numeric](18, 2) NULL,
	[GriIntrestChargeGlPlt] [char](10) NULL,
	[GriIntrestChargeGl] [char](10) NULL,
	[GriBreakDownCharge] [numeric](18, 2) NULL,
	[GriBreakDownChargeGlPlt] [char](10) NULL,
	[GriBreakDownChargeGL] [char](10) NULL,
	[BORGID] [int] NOT NULL,
	[ESCALATIONCODE] [nvarchar](11) NULL,
	[CPINDEX] [numeric](18, 4) NOT NULL,
	[ESCGLOBALPERC] [numeric](18, 4) NOT NULL,
	[DAYEND] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[USEMATERIALS] [bit] NOT NULL,
 CONSTRAINT [PK_PLANTHIREVARIABLES] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireVariables] ADD  DEFAULT (1) FOR [ShowRateInMaster]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PlantHireVariables_HireVFirstDayOfWeeek]  DEFAULT ((1)) FOR [HireVFirstDayOfWeeek]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PLANTHIREVARIABLES_BORGID]  DEFAULT ('-1') FOR [BORGID]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PLANTHIREVARIABLES_ESCALATIONCODE]  DEFAULT ('') FOR [ESCALATIONCODE]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PLANTHIREVARIABLES_CPINDEX]  DEFAULT ('0') FOR [CPINDEX]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PLANTHIREVARIABLES_ESCGLOBALPERC]  DEFAULT ('0') FOR [ESCGLOBALPERC]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PLANTHIREVARIABLES_DAYEND]  DEFAULT ((31)) FOR [DAYEND]
ALTER TABLE [dbo].[PlantHireVariables] ADD  CONSTRAINT [DF_PLANTHIREVARIABLES_USEMATERIALS]  DEFAULT (N'0') FOR [USEMATERIALS]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES] FOREIGN KEY([GriIsurChargeGlPlt])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES1] FOREIGN KEY([GriIsurChargeGl])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES1]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES2] FOREIGN KEY([GriOverhChargeGlPlt])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES2]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES3] FOREIGN KEY([GriOverhChargeGL])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES3]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES4] FOREIGN KEY([GriIntrestChargeGlPlt])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES4]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES5] FOREIGN KEY([GriIntrestChargeGl])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES5]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES6] FOREIGN KEY([GriBreakDownChargeGlPlt])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES6]
ALTER TABLE [dbo].[PlantHireVariables]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireVariables_LEDGERCODES7] FOREIGN KEY([GriBreakDownChargeGL])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[PlantHireVariables] CHECK CONSTRAINT [FK_PlantHireVariables_LEDGERCODES7]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERPLANTHIREVARIABLES ON PLANTHIREVARIABLES
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'PLANTHIREVARIABLES'
set @primaryKey = 'ID'
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

		
ALTER TABLE [dbo].[PlantHireVariables] ENABLE TRIGGER [LOGMASTERPLANTHIREVARIABLES]