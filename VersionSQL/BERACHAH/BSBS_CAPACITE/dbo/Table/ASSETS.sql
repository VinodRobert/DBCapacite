/****** Object:  Table [dbo].[ASSETS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ASSETS](
	[AssetID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BorgID] [int] NOT NULL,
	[AssetNumber] [char](15) NULL,
	[AssetName] [char](55) NULL,
	[AssetPDate] [datetime] NULL,
	[AssetPPrice] [money] NOT NULL,
	[AssetInitAllow] [money] NOT NULL,
	[AssetDepMethod] [char](25) NULL,
	[AssetPeriod] [numeric](18, 2) NOT NULL,
	[AssetBookValue] [money] NOT NULL,
	[AssetAccumDep] [money] NOT NULL,
	[AssetMarketValue] [money] NOT NULL,
	[AssetLastPostDate] [datetime] NULL,
	[AssetPost] [bit] NOT NULL,
	[AssetLifeHours] [numeric](18, 0) NOT NULL,
	[AssetHrsToDate] [numeric](18, 0) NOT NULL,
	[AssetDepCode] [char](10) NULL,
	[AssetAlloc] [char](25) NULL,
	[AssetOppCode] [char](10) NULL,
	[AssetOppAlloc] [char](25) NULL,
	[AssetDepProg] [numeric](18, 0) NOT NULL,
	[AssetSalvage] [money] NOT NULL,
	[AssetDepTM] [money] NOT NULL,
	[AssetAdd] [money] NOT NULL,
	[AssetSale] [money] NOT NULL,
	[AssetRevalu] [money] NOT NULL,
	[ToJoinAsset] [int] NOT NULL,
	[AssetLocation] [char](50) NOT NULL,
	[AssetContact] [char](30) NOT NULL,
	[AssetCategory] [nvarchar](110) NOT NULL,
	[AssetAllocDiv] [int] NOT NULL,
	[Usage] [numeric](18, 0) NOT NULL,
	[AssetStatus] [int] NOT NULL,
	[AssetSellDate] [datetime] NULL,
	[AssetSellAmount] [money] NOT NULL,
	[Assetagreeno] [char](25) NOT NULL,
	[Assetinvoice] [char](10) NOT NULL,
	[AssetiDate] [datetime] NULL,
	[AssetoiRate] [numeric](18, 3) NOT NULL,
	[AssetfPeriod] [numeric](18, 0) NOT NULL,
	[AssetisDate] [datetime] NULL,
	[AssetifDate] [datetime] NULL,
	[AssetFees] [money] NOT NULL,
	[AssetFeesOffBS] [money] NOT NULL,
	[AssetIntRebate] [money] NOT NULL,
	[AssetReg] [money] NOT NULL,
	[AssetCap] [money] NOT NULL,
	[AssetDep] [money] NOT NULL,
	[AssetFin] [money] NOT NULL,
	[AssetVAT] [money] NOT NULL,
	[AssetRepDate] [datetime] NULL,
	[AssetFinCharge] [money] NOT NULL,
	[AssetFinPost] [bit] NOT NULL,
	[AssetMonthPay] [money] NOT NULL,
	[AssetFinPay] [money] NOT NULL,
	[AssetCred] [char](10) NOT NULL,
	[AssetFinCom] [char](10) NOT NULL,
	[AssetBank] [char](10) NOT NULL,
	[AssetCostAlloc] [char](10) NOT NULL,
	[AssetIsVATFin] [bit] NOT NULL,
	[AssetPDebt] [money] NOT NULL,
	[AssetTColl] [money] NOT NULL,
	[AssetDefAcc] [char](10) NOT NULL,
	[AssetLDate] [datetime] NULL,
	[AssetIRDate] [datetime] NULL,
	[AssetVATType] [char](2) NOT NULL,
	[AssetDepAcc] [char](10) NOT NULL,
	[AssetRepAcc] [char](10) NOT NULL,
	[ASSETTAXDEPPERCS] [nvarchar](50) NOT NULL,
	[ASSETTAXDEPTYPE] [int] NOT NULL,
	[ASSETTAXYEARS] [char](6) NOT NULL,
	[ASSETTAXPPRICE] [money] NOT NULL,
	[ASSETISIFRS] [bit] NOT NULL,
	[LASTDEPTM] [decimal](18, 4) NOT NULL,
	[ASSETSPLIT] [decimal](18, 4) NOT NULL,
	[INSURANCEVALUE] [money] NOT NULL,
	[ASSETHRSTODATEPREV] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_ASSETS] PRIMARY KEY CLUSTERED 
(
	[AssetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_ASSETS] UNIQUE NONCLUSTERED 
(
	[AssetNumber] ASC,
	[BorgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_BorgID]  DEFAULT ((0)) FOR [BorgID]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetPPrice]  DEFAULT ((0)) FOR [AssetPPrice]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetInitAllow]  DEFAULT ((0)) FOR [AssetInitAllow]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetPeriod]  DEFAULT ((36)) FOR [AssetPeriod]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetBookValue]  DEFAULT ((0)) FOR [AssetBookValue]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetAccumDep]  DEFAULT ((0)) FOR [AssetAccumDep]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetMarketValue]  DEFAULT ((0)) FOR [AssetMarketValue]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetPost]  DEFAULT ((0)) FOR [AssetPost]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetLifeHours]  DEFAULT ((0)) FOR [AssetLifeHours]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetHrsToDate]  DEFAULT ((0)) FOR [AssetHrsToDate]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetDepProg]  DEFAULT ((0)) FOR [AssetDepProg]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetSalvage]  DEFAULT ((0)) FOR [AssetSalvage]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetDepTM]  DEFAULT ((0)) FOR [AssetDepTM]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetAdd]  DEFAULT ((0)) FOR [AssetAdd]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetSale]  DEFAULT ((0)) FOR [AssetSale]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetRevalu]  DEFAULT ((0)) FOR [AssetRevalu]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ToJoinAsset]  DEFAULT ((12)) FOR [ToJoinAsset]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetLocation]  DEFAULT ('') FOR [AssetLocation]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetContact]  DEFAULT ('') FOR [AssetContact]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETCATEGORY]  DEFAULT ('') FOR [AssetCategory]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetAllocDiv]  DEFAULT ((-1)) FOR [AssetAllocDiv]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_Usage]  DEFAULT ((0)) FOR [Usage]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF__ASSETS__AssetSta__1F06E340]  DEFAULT ((0)) FOR [AssetStatus]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF__ASSETS__AssetSel__4C9641C1]  DEFAULT ((0)) FOR [AssetSellAmount]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_Assetagreeno]  DEFAULT ('') FOR [Assetagreeno]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_Assetinvoice]  DEFAULT ('') FOR [Assetinvoice]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetoiRate]  DEFAULT ((0)) FOR [AssetoiRate]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetfPeriod]  DEFAULT ((36)) FOR [AssetfPeriod]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFees]  DEFAULT ((0)) FOR [AssetFees]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFeesOffBS]  DEFAULT ((0)) FOR [AssetFeesOffBS]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetIntRebate]  DEFAULT ((0)) FOR [AssetIntRebate]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetReg]  DEFAULT ((0)) FOR [AssetReg]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetCap]  DEFAULT ((0)) FOR [AssetCap]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetDep]  DEFAULT ((0)) FOR [AssetDep]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFin]  DEFAULT ((0)) FOR [AssetFin]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetVAT]  DEFAULT ((0)) FOR [AssetVAT]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFinCharge]  DEFAULT ((0)) FOR [AssetFinCharge]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFinPost]  DEFAULT ((0)) FOR [AssetFinPost]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetMonthPay]  DEFAULT ((0)) FOR [AssetMonthPay]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFinPay]  DEFAULT ((0)) FOR [AssetFinPay]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetCred]  DEFAULT ('') FOR [AssetCred]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetFinCom]  DEFAULT ('') FOR [AssetFinCom]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetBank]  DEFAULT ('') FOR [AssetBank]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetCostAlloc]  DEFAULT ('') FOR [AssetCostAlloc]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetIsVATFin]  DEFAULT ((0)) FOR [AssetIsVATFin]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetPDebt]  DEFAULT ((0)) FOR [AssetPDebt]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetTColl]  DEFAULT ((0)) FOR [AssetTColl]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetDefAcc]  DEFAULT ('') FOR [AssetDefAcc]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetLDate]  DEFAULT (getdate()) FOR [AssetLDate]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetIRDate]  DEFAULT (getdate()) FOR [AssetIRDate]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetVATType]  DEFAULT ('Z') FOR [AssetVATType]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetDepAcc]  DEFAULT ('') FOR [AssetDepAcc]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_AssetRepAcc]  DEFAULT ('') FOR [AssetRepAcc]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETTAXDEPPERCS]  DEFAULT ((0)) FOR [ASSETTAXDEPPERCS]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETTAXDEPTYPE]  DEFAULT ((0)) FOR [ASSETTAXDEPTYPE]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETTAXYEARS]  DEFAULT ('') FOR [ASSETTAXYEARS]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETTAXPPRICE]  DEFAULT ((0)) FOR [ASSETTAXPPRICE]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETISIFRS]  DEFAULT ('0') FOR [ASSETISIFRS]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_LASTDEPTM]  DEFAULT ('0') FOR [LASTDEPTM]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETSPLIT]  DEFAULT ('0') FOR [ASSETSPLIT]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF__ASSETS__INSURANC__17956E0B]  DEFAULT ('0') FOR [INSURANCEVALUE]
ALTER TABLE [dbo].[ASSETS] ADD  CONSTRAINT [DF_ASSETS_ASSETHRSTODATEPREV]  DEFAULT ('0') FOR [ASSETHRSTODATEPREV]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERASSETS ON ASSETS
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'ASSETS'
set @primaryKey = 'ASSETID'
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
		
ALTER TABLE [dbo].[ASSETS] ENABLE TRIGGER [LOGMASTERASSETS]