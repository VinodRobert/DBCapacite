/****** Object:  Table [dbo].[PLANTANDEQ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANTANDEQ](
	[PeNumber] [char](10) NOT NULL,
	[BorgID] [int] NOT NULL,
	[PeName] [char](35) NULL,
	[PeRegNo] [char](25) NULL,
	[PeChassis] [char](25) NULL,
	[PeEngine] [char](25) NULL,
	[PePurchased] [datetime] NULL,
	[PePPrice] [char](15) NULL,
	[PeOPerator] [char](35) NULL,
	[PeRate1] [char](15) NULL,
	[PeRate2] [char](15) NULL,
	[PeRate3] [char](15) NULL,
	[PeRate4] [char](15) NULL,
	[PeRate5] [char](15) NULL,
	[PeRateDesc1] [char](25) NULL,
	[PeRateDesc2] [char](25) NULL,
	[PeRateDesc3] [char](25) NULL,
	[PeRateDesc4] [char](25) NULL,
	[PeRateDesc5] [char](25) NULL,
	[PeUnit1] [char](5) NULL,
	[PeUnit2] [char](5) NULL,
	[PeUnit3] [char](5) NULL,
	[PeUnit4] [char](5) NULL,
	[PeUnit5] [char](5) NULL,
	[PeLocation] [char](35) NULL,
	[PeTransferDate] [datetime] NULL,
	[TOJOINP] [int] NOT NULL,
	[CurrentSMR] [int] NOT NULL,
	[DivID] [int] NOT NULL,
	[CatID] [int] NOT NULL,
	[PeStatus] [int] NOT NULL,
	[PeUser1] [ntext] NULL,
	[PeUser2] [ntext] NULL,
	[PeUser3] [ntext] NULL,
	[PeUser4] [ntext] NULL,
	[PeUser5] [ntext] NULL,
	[PeUser6] [ntext] NULL,
	[PeUser7] [ntext] NULL,
	[PeUser8] [ntext] NULL,
	[PeUser9] [ntext] NULL,
	[PeUser10] [ntext] NULL,
	[PeUser11] [ntext] NULL,
	[PeUser12] [ntext] NULL,
	[PeUser13] [ntext] NULL,
	[PeUser14] [ntext] NULL,
	[PeUser15] [ntext] NULL,
	[PeUser16] [ntext] NULL,
	[PeUser17] [ntext] NULL,
	[PeUser18] [ntext] NULL,
	[PeUser19] [ntext] NULL,
	[PeUser20] [ntext] NULL,
	[PeUser21] [ntext] NULL,
	[PeServiceDate] [datetime] NULL,
	[PeServiceSMR] [numeric](18, 4) NULL,
	[ServID] [int] NULL,
	[PeServiceFromWhere] [char](15) NULL,
	[PeServiceHeadID] [char](10) NULL,
	[PeLastSMR] [numeric](18, 4) NULL,
	[PeLastDate] [datetime] NULL,
	[PeLastFromWhere] [char](15) NULL,
	[PeLastHeadID] [char](10) NULL,
	[PeServiceUnit] [char](10) NULL,
	[PeServiceNextSMR] [numeric](18, 4) NULL,
	[PeServiceFromWhereID] [int] NULL,
	[PeLastFromWhereID] [int] NULL,
	[PeServiceLogID] [int] NULL,
	[PeLastLogID] [int] NULL,
	[FUELCONSUMPTIONMIN] [numeric](18, 4) NOT NULL,
	[FUELCONSUMPTIONMAX] [numeric](18, 4) NOT NULL,
	[FUELCAPASITY] [numeric](18, 4) NOT NULL,
	[stockRequirementStore] [char](15) NOT NULL,
	[PEID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_PLANTANDEQ] PRIMARY KEY NONCLUSTERED 
(
	[PeNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [IX_PLANTANDEQ] ON [dbo].[PLANTANDEQ]
(
	[PeNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_BorgID]  DEFAULT (0) FOR [BorgID]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_TOJOINP]  DEFAULT (10) FOR [TOJOINP]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_CurrentSMR]  DEFAULT (0) FOR [CurrentSMR]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_DivID]  DEFAULT ((-1)) FOR [DivID]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_CatID]  DEFAULT ((-1)) FOR [CatID]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF__PLANTANDE__PeSta__1D1E9ACE]  DEFAULT (0) FOR [PeStatus]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_FUELCONSUMPTIONMIN]  DEFAULT ('0') FOR [FUELCONSUMPTIONMIN]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_FUELCONSUMPTIONMAX]  DEFAULT ('0') FOR [FUELCONSUMPTIONMAX]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_FUELCAPASITY]  DEFAULT ('0') FOR [FUELCAPASITY]
ALTER TABLE [dbo].[PLANTANDEQ] ADD  CONSTRAINT [DF_PLANTANDEQ_stockRequirementStore]  DEFAULT ('') FOR [stockRequirementStore]
ALTER TABLE [dbo].[PLANTANDEQ]  WITH CHECK ADD  CONSTRAINT [FK_PLANTANDEQ_PlantReadingsFlags] FOREIGN KEY([PeServiceFromWhereID])
REFERENCES [dbo].[PlantReadingsFlags] ([PltFID])
ALTER TABLE [dbo].[PLANTANDEQ] CHECK CONSTRAINT [FK_PLANTANDEQ_PlantReadingsFlags]
ALTER TABLE [dbo].[PLANTANDEQ]  WITH CHECK ADD  CONSTRAINT [FK_PLANTANDEQ_PlantReadingsFlags1] FOREIGN KEY([PeLastFromWhereID])
REFERENCES [dbo].[PlantReadingsFlags] ([PltFID])
ALTER TABLE [dbo].[PLANTANDEQ] CHECK CONSTRAINT [FK_PLANTANDEQ_PlantReadingsFlags1]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERPLANTANDEQ ON PLANTANDEQ
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'PLANTANDEQ'
set @primaryKey = 'PeNumber'
set @ignoreList = 'PeUser1, PeUser2, PeUser3, PeUser4, PeUser5, PeUser6, PeUser7, PeUser8, PeUser9, PeUser10, PeUser11, PeUser12, PeUser13, PeUser14, PeUser15, PeUser16, PeUser17, PeUser18, PeUser19, PeUser20, PeUser21, CurrentSMR, SLHeadID, stockRequirementStore'

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
 
select PEID,PeNumber,BorgID,PeName,PeRegNo,PeChassis,PeEngine,PePurchased,PePPrice,PeOPerator,PeRate1,PeRate2,PeRate3,PeRate4,PeRate5,PeRateDesc1,PeRateDesc2,PeRateDesc3,PeRateDesc4,PeRateDesc5,PeUnit1,PeUnit2,PeUnit3,PeUnit4,PeUnit5,PeLocation,PeTransferDate,TOJOINP,DivID,CatID,PeStatus,PeServiceDate,PeServiceSMR,ServID,PeServiceFromWhere,PeServiceHeadID,PeLastSMR,PeLastDate,PeLastFromWhere,PeLastHeadID,PeServiceUnit,PeServiceNextSMR,PeServiceFromWhereID,PeLastFromWhereID,PeServiceLogID,PeLastLogID,FUELCONSUMPTIONMIN,FUELCONSUMPTIONMAX,FUELCAPASITY into #inserted from INSERTED
select PEID,PeNumber,BorgID,PeName,PeRegNo,PeChassis,PeEngine,PePurchased,PePPrice,PeOPerator,PeRate1,PeRate2,PeRate3,PeRate4,PeRate5,PeRateDesc1,PeRateDesc2,PeRateDesc3,PeRateDesc4,PeRateDesc5,PeUnit1,PeUnit2,PeUnit3,PeUnit4,PeUnit5,PeLocation,PeTransferDate,TOJOINP,DivID,CatID,PeStatus,PeServiceDate,PeServiceSMR,ServID,PeServiceFromWhere,PeServiceHeadID,PeLastSMR,PeLastDate,PeLastFromWhere,PeLastHeadID,PeServiceUnit,PeServiceNextSMR,PeServiceFromWhereID,PeLastFromWhereID,PeServiceLogID,PeLastLogID,FUELCONSUMPTIONMIN,FUELCONSUMPTIONMAX,FUELCAPASITY into #deleted from DELETED

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

		
ALTER TABLE [dbo].[PLANTANDEQ] ENABLE TRIGGER [LOGMASTERPLANTANDEQ]