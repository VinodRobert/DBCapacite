/****** Object:  Table [dbo].[PLANTCATEGORIES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANTCATEGORIES](
	[CatID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CatNumber] [char](10) NOT NULL,
	[CatName] [char](55) NOT NULL,
	[CatRate1] [money] NOT NULL,
	[CatRate2] [money] NOT NULL,
	[CatRate3] [money] NOT NULL,
	[CatRate4] [money] NOT NULL,
	[CatRate5] [money] NOT NULL,
	[CatDesc1] [char](25) NOT NULL,
	[CatDesc2] [char](25) NULL,
	[CatDesc3] [char](25) NULL,
	[CatDesc4] [char](25) NULL,
	[CatDesc5] [char](25) NULL,
	[CatUnit1] [char](10) NOT NULL,
	[CatUnit2] [char](10) NULL,
	[CatUnit3] [char](10) NULL,
	[CatUnit4] [char](10) NULL,
	[CatUnit5] [char](10) NULL,
	[SMRUnit] [char](10) NULL,
	[CatFunc1] [nvarchar](200) NULL,
	[CatFunc2] [nvarchar](200) NULL,
	[CatFunc3] [nvarchar](200) NULL,
	[CatFunc4] [nvarchar](200) NULL,
	[HireRDayMin] [numeric](18, 1) NULL,
	[HireRWeekMin] [numeric](18, 1) NULL,
	[HireRMonthMin] [numeric](18, 1) NULL,
	[CatExpectedHrPerDay] [numeric](18, 1) NULL,
	[CatActWorkHr1] [bit] NOT NULL,
	[CatActWorkHr2] [bit] NOT NULL,
	[CatActWorkHr3] [bit] NOT NULL,
	[CatActWorkHr4] [bit] NOT NULL,
	[CatActWorkHr5] [bit] NOT NULL,
	[CatIsFixed1] [bit] NOT NULL,
	[CatIsFixed2] [bit] NOT NULL,
	[CatIsFixed3] [bit] NOT NULL,
	[CatIsFixed4] [bit] NOT NULL,
	[CatIsFixed5] [bit] NOT NULL,
	[CatIsBreakdown1] [bit] NOT NULL,
	[CatIsBreakdown2] [bit] NOT NULL,
	[CatIsBreakdown3] [bit] NOT NULL,
	[CatIsBreakdown4] [bit] NOT NULL,
	[CatIsBreakdown5] [bit] NOT NULL,
	[CatIsPenC1] [bit] NOT NULL,
	[CatIsPenC2] [bit] NOT NULL,
	[CatIsPenC3] [bit] NOT NULL,
	[CatIsPenC4] [bit] NOT NULL,
	[CatIsPenC5] [bit] NOT NULL,
	[CatPenToWeekend] [bit] NOT NULL,
	[CatPenToHolidays] [bit] NOT NULL,
	[CatPenAct] [char](10) NULL,
	[CatHaveService] [bit] NULL,
	[CatServWarning] [numeric](18, 4) NULL,
	[CatServCalcType] [char](15) NULL,
	[CatBatchBalance] [bit] NOT NULL,
	[CatServUpdatePerc] [numeric](18, 4) NOT NULL,
	[CatServWarningDays] [int] NOT NULL,
	[PltGroupID] [int] NULL,
	[CATESCALATION1] [bit] NULL,
	[CATESCALATION2] [bit] NULL,
	[CATESCALATION3] [bit] NULL,
	[CATESCALATION4] [bit] NULL,
	[CATESCALATION5] [bit] NULL,
	[CATPRODUSE1] [bit] NOT NULL,
	[CATPRODUSE2] [bit] NOT NULL,
	[CATPRODUSE3] [bit] NOT NULL,
	[CATPRODNAME1] [nvarchar](250) NOT NULL,
	[CATPRODNAME2] [nvarchar](250) NOT NULL,
	[CATPRODNAME3] [nvarchar](250) NOT NULL,
	[CATPRODUNIT1] [nvarchar](10) NOT NULL,
	[CATPRODUNIT2] [nvarchar](10) NOT NULL,
	[CATPRODUNIT3] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_PLANTCATERIES] PRIMARY KEY CLUSTERED 
(
	[CatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_PLANTCATERIES] UNIQUE NONCLUSTERED 
(
	[CatNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatRate1_1]  DEFAULT (0) FOR [CatRate1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatRate2_1]  DEFAULT (0) FOR [CatRate2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatRate3]  DEFAULT (0) FOR [CatRate3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatRate4_1]  DEFAULT (0) FOR [CatRate4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatRate5_1]  DEFAULT (0) FOR [CatRate5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatDesc1_1]  DEFAULT ('') FOR [CatDesc1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatDesc2_1]  DEFAULT ('') FOR [CatDesc2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatDesc3_1]  DEFAULT ('') FOR [CatDesc3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatDesc4_1]  DEFAULT ('') FOR [CatDesc4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatDesc5_1]  DEFAULT ('') FOR [CatDesc5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatUnit1]  DEFAULT ('') FOR [CatUnit1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatUnit2]  DEFAULT ('') FOR [CatUnit2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatUnit3]  DEFAULT ('') FOR [CatUnit3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatUnit4]  DEFAULT ('') FOR [CatUnit4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatUnit5]  DEFAULT ('') FOR [CatUnit5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatFunc1]  DEFAULT (N'iif( ( Q1 + Q2 + Q3 + Q4) < (weekdays - holidays)*minPerDay - Q5 , ((weekdays - holidays)*minPerDay - Q5 ) -  ( Q1 + Q2 + Q3 + Q4)   , 0)') FOR [CatFunc1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatFunc2]  DEFAULT (N'penalty * Rate4') FOR [CatFunc2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatFunc3]  DEFAULT (N'Q1 + Q2 + Q3 + Q4') FOR [CatFunc3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATERIES_CatFunc4]  DEFAULT (N'(weekdays - holidays) * utilHrPerDay - Q5') FOR [CatFunc4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (1) FOR [CatActWorkHr1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (1) FOR [CatActWorkHr2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatActWorkHr3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatActWorkHr4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatActWorkHr5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsFixed1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsFixed2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsFixed3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsFixed4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsFixed5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsBreakdown1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsBreakdown2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsBreakdown3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsBreakdown4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsBreakdown5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsPenC1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsPenC2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsPenC3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsPenC4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatIsPenC5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatPenToWeekend]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatPenToHolidays]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  DEFAULT (0) FOR [CatHaveService]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CatBatchBalance]  DEFAULT ((1)) FOR [CatBatchBalance]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CatServUpdatePerc]  DEFAULT ('85') FOR [CatServUpdatePerc]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CatServWarningDays]  DEFAULT ((7)) FOR [CatServWarningDays]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATESCALATION1]  DEFAULT ('FALSE') FOR [CATESCALATION1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATESCALATION2]  DEFAULT ('FALSE') FOR [CATESCALATION2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATESCALATION3]  DEFAULT ('FALSE') FOR [CATESCALATION3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATESCALATION4]  DEFAULT ('FALSE') FOR [CATESCALATION4]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATESCALATION5]  DEFAULT ('FALSE') FOR [CATESCALATION5]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODUSE1]  DEFAULT (N'0') FOR [CATPRODUSE1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODUSE2]  DEFAULT (N'0') FOR [CATPRODUSE2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODUSE3]  DEFAULT (N'0') FOR [CATPRODUSE3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODNAME1]  DEFAULT ('') FOR [CATPRODNAME1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODNAME2]  DEFAULT ('') FOR [CATPRODNAME2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODNAME3]  DEFAULT ('') FOR [CATPRODNAME3]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODUNIT1]  DEFAULT ('') FOR [CATPRODUNIT1]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODUNIT2]  DEFAULT ('') FOR [CATPRODUNIT2]
ALTER TABLE [dbo].[PLANTCATEGORIES] ADD  CONSTRAINT [DF_PLANTCATEGORIES_CATPRODUNIT3]  DEFAULT ('') FOR [CATPRODUNIT3]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATEGORIES_PlantGroups] FOREIGN KEY([PltGroupID])
REFERENCES [dbo].[PlantGroups] ([PltGroupID])
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATEGORIES_PlantGroups]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATERIES_PlantUnits] FOREIGN KEY([SMRUnit])
REFERENCES [dbo].[PlantUnits] ([PltUnitID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATERIES_PlantUnits]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATERIES_PlantUnits1] FOREIGN KEY([CatUnit1])
REFERENCES [dbo].[PlantUnits] ([PltUnitID])
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATERIES_PlantUnits1]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATERIES_PlantUnits2] FOREIGN KEY([CatUnit2])
REFERENCES [dbo].[PlantUnits] ([PltUnitID])
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATERIES_PlantUnits2]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATERIES_PlantUnits3] FOREIGN KEY([CatUnit3])
REFERENCES [dbo].[PlantUnits] ([PltUnitID])
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATERIES_PlantUnits3]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATERIES_PlantUnits4] FOREIGN KEY([CatUnit4])
REFERENCES [dbo].[PlantUnits] ([PltUnitID])
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATERIES_PlantUnits4]
ALTER TABLE [dbo].[PLANTCATEGORIES]  WITH CHECK ADD  CONSTRAINT [FK_PLANTCATERIES_PlantUnits5] FOREIGN KEY([CatUnit5])
REFERENCES [dbo].[PlantUnits] ([PltUnitID])
ALTER TABLE [dbo].[PLANTCATEGORIES] CHECK CONSTRAINT [FK_PLANTCATERIES_PlantUnits5]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERPLANTCATEGORIES ON PLANTCATEGORIES
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'PLANTCATEGORIES'
set @primaryKey = 'CatID'
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

		
ALTER TABLE [dbo].[PLANTCATEGORIES] ENABLE TRIGGER [LOGMASTERPLANTCATEGORIES]