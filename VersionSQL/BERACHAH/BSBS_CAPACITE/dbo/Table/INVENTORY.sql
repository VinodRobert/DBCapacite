/****** Object:  Table [dbo].[INVENTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[INVENTORY](
	[StkStore] [char](15) NOT NULL,
	[StkCode] [char](20) NOT NULL,
	[StkDesc] [char](250) NULL,
	[StkUnit] [char](8) NULL,
	[StkBin] [char](10) NULL,
	[StkQuantity] [numeric](18, 4) NOT NULL,
	[StkCostRate] [money] NOT NULL,
	[MUMethod] [int] NULL,
	[MUValue] [numeric](18, 4) NOT NULL,
	[StkSellRate] [money] NOT NULL,
	[StkGLCode] [char](10) NULL,
	[StkMaxBal] [numeric](18, 0) NOT NULL,
	[StkMinBal] [numeric](18, 0) NOT NULL,
	[BorgID] [int] NOT NULL,
	[StkID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ToJoinI] [int] NOT NULL,
	[StkHireRate] [money] NOT NULL,
	[StkStatus] [int] NOT NULL,
	[STKSTKTAKE] [numeric](18, 4) NOT NULL,
	[STKSHEET] [char](10) NOT NULL,
	[STKWEIGHT] [numeric](18, 4) NOT NULL,
	[STKWEIGHTUNIT] [char](10) NOT NULL,
	[STKSELLUNIT] [char](10) NOT NULL,
	[STKSELLCONV] [numeric](18, 4) NOT NULL,
	[STKBUYUNIT] [char](10) NOT NULL,
	[STKBUYCONV] [numeric](18, 4) NOT NULL,
	[STKSUPPCODE] [char](10) NOT NULL,
	[STKBUYCOST] [money] NOT NULL,
	[STKBUYDATE] [datetime] NULL,
	[STKSELLDATE] [datetime] NULL,
	[STKSELECT] [char](5) NOT NULL,
	[StkSuppProdCode] [char](20) NOT NULL,
	[OB1] [numeric](18, 4) NOT NULL,
	[OB2] [numeric](18, 4) NOT NULL,
	[OB3] [numeric](18, 4) NOT NULL,
	[OB4] [numeric](18, 4) NOT NULL,
	[OB5] [numeric](18, 4) NOT NULL,
	[OB6] [numeric](18, 4) NOT NULL,
	[OB7] [numeric](18, 4) NOT NULL,
	[OB8] [numeric](18, 4) NOT NULL,
	[OB9] [numeric](18, 4) NOT NULL,
	[OB10] [numeric](18, 4) NOT NULL,
	[OB11] [numeric](18, 4) NOT NULL,
	[OB12] [numeric](18, 4) NOT NULL,
	[OPENINGBALANCE] [numeric](18, 4) NOT NULL,
	[STKDEFGL] [char](10) NOT NULL,
	[StkDefAct] [char](10) NOT NULL,
	[StkConvertFlag] [bit] NOT NULL,
	[SerialType] [int] NOT NULL,
	[STKSTKTAKERATE] [decimal](18, 4) NOT NULL,
	[STKSHEETRATE] [nvarchar](10) NOT NULL,
	[DIVID] [int] NOT NULL,
	[STKSTARTQTY] [decimal](18, 4) NOT NULL,
	[STKSTARTRATE] [decimal](18, 4) NOT NULL,
	[STKHIREADJUST] [decimal](18, 4) NOT NULL,
	[STKHIRESHEET] [nvarchar](10) NOT NULL,
	[DEFINVVATID] [char](2) NOT NULL,
 CONSTRAINT [PK_INVENTORY_2] PRIMARY KEY CLUSTERED 
(
	[StkStore] ASC,
	[StkCode] ASC,
	[BorgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_INVENTORY] UNIQUE NONCLUSTERED 
(
	[StkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_INVENTORY_BorgID] ON [dbo].[INVENTORY]
(
	[BorgID] ASC
)
INCLUDE([StkStore],[StkCode],[StkQuantity],[StkID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_INVENTORY_StlCode_BorgID] ON [dbo].[INVENTORY]
(
	[StkCode] ASC,
	[BorgID] ASC
)
INCLUDE([StkStore],[StkDesc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkQuantity]  DEFAULT ((0)) FOR [StkQuantity]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkCostRate]  DEFAULT ((0)) FOR [StkCostRate]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_MUMethod]  DEFAULT ((4)) FOR [MUMethod]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_MUValue]  DEFAULT ('0') FOR [MUValue]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkSellRate]  DEFAULT ((0)) FOR [StkSellRate]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkMaxBal]  DEFAULT ((0)) FOR [StkMaxBal]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkMinBal]  DEFAULT ((0)) FOR [StkMinBal]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_BorgID]  DEFAULT ((0)) FOR [BorgID]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_ToJoinI]  DEFAULT ((11)) FOR [ToJoinI]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkHireRate]  DEFAULT ((0)) FOR [StkHireRate]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__StkSt__1E12BF07]  DEFAULT ((0)) FOR [StkStatus]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKST__4B380934]  DEFAULT ((0)) FOR [STKSTKTAKE]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKSH__4C2C2D6D]  DEFAULT ('') FOR [STKSHEET]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKWE__4D2051A6]  DEFAULT ((0)) FOR [STKWEIGHT]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKWE__4E1475DF]  DEFAULT ('') FOR [STKWEIGHTUNIT]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKSE__4F089A18]  DEFAULT ('') FOR [STKSELLUNIT]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKSE__4FFCBE51]  DEFAULT ((1)) FOR [STKSELLCONV]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKBU__50F0E28A]  DEFAULT ('') FOR [STKBUYUNIT]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKBU__51E506C3]  DEFAULT ((1)) FOR [STKBUYCONV]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKSU__52D92AFC]  DEFAULT ('') FOR [STKSUPPCODE]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKBU__53CD4F35]  DEFAULT ((0)) FOR [STKBUYCOST]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKSE__54C1736E]  DEFAULT ('') FOR [STKSELECT]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__StkSu__55B597A7]  DEFAULT ('') FOR [StkSuppProdCode]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB1__56A9BBE0]  DEFAULT ((0)) FOR [OB1]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB2__579DE019]  DEFAULT ((0)) FOR [OB2]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB3__58920452]  DEFAULT ((0)) FOR [OB3]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB4__5986288B]  DEFAULT ((0)) FOR [OB4]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB5__5A7A4CC4]  DEFAULT ((0)) FOR [OB5]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB6__5B6E70FD]  DEFAULT ((0)) FOR [OB6]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB7__5C629536]  DEFAULT ((0)) FOR [OB7]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB8__5D56B96F]  DEFAULT ((0)) FOR [OB8]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB9__5E4ADDA8]  DEFAULT ((0)) FOR [OB9]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB10__5F3F01E1]  DEFAULT ((0)) FOR [OB10]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB11__6033261A]  DEFAULT ((0)) FOR [OB11]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OB12__61274A53]  DEFAULT ((0)) FOR [OB12]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__OPENI__621B6E8C]  DEFAULT ((0)) FOR [OPENINGBALANCE]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF__INVENTORY__STKDE__76226739]  DEFAULT ('') FOR [STKDEFGL]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkDefAct]  DEFAULT ('') FOR [StkDefAct]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_StkConvertFlag]  DEFAULT ((0)) FOR [StkConvertFlag]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_SERIALTYPE]  DEFAULT ('0') FOR [SerialType]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_STKSTKTAKERATE]  DEFAULT ('0') FOR [STKSTKTAKERATE]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_STKSHEETRATE]  DEFAULT ('') FOR [STKSHEETRATE]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_DIVID]  DEFAULT ('-1') FOR [DIVID]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_STKSTARTQTY]  DEFAULT ((-1)) FOR [STKSTARTQTY]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_STKSTARTRATE]  DEFAULT ((-1)) FOR [STKSTARTRATE]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_STKHIREADJUST]  DEFAULT ((0)) FOR [STKHIREADJUST]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_STKHIRESHEET]  DEFAULT ('') FOR [STKHIRESHEET]
ALTER TABLE [dbo].[INVENTORY] ADD  CONSTRAINT [DF_INVENTORY_DEFINVVATID]  DEFAULT ('') FOR [DEFINVVATID]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERINVENTORY ON INVENTORY
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'INVENTORY'
set @primaryKey = 'STKID'
set @ignoreList = 'OB1, OB2, OB3, OB4, OB5, OB6, OB7, OB8, OB9, OB10, OB11, OB12, OPENINGBALANCE, STKSELLRATE, STKSHEET, STKSTKTAKE, STKBUYCOST, STKBUYDATE, STKSELLDATE, STKSTKTAKERATE, STKSHEETRATE, STKSTARTQTY, STKSTARTRATE, STKHIREADJUST, STKHIRESHEET'

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
 
select STKSTORE, STKCODE, STKDESC, STKUNIT, STKQUANTITY, STKCOSTRATE, STKBIN, MUMETHOD, MUVALUE, STKGLCODE, STKMAXBAL, STKMINBAL, BORGID, STKID, TOJOINI, STKSTATUS, STKWEIGHT, STKWEIGHTUNIT, STKSELLUNIT, STKSELLCONV, STKBUYUNIT, STKBUYCONV, STKSUPPCODE, STKSELECT, STKSUPPPRODCODE,  STKDEFGL, STKDEFACT, STKCONVERTFLAG, SERIALTYPE, DIVID, STKHIRERATE, DEFINVVATID into #inserted from INSERTED
select STKSTORE, STKCODE, STKDESC, STKUNIT, STKQUANTITY, STKCOSTRATE, STKBIN, MUMETHOD, MUVALUE, STKGLCODE, STKMAXBAL, STKMINBAL, BORGID, STKID, TOJOINI, STKSTATUS, STKWEIGHT, STKWEIGHTUNIT, STKSELLUNIT, STKSELLCONV, STKBUYUNIT, STKBUYCONV, STKSUPPCODE, STKSELECT, STKSUPPPRODCODE,  STKDEFGL, STKDEFACT, STKCONVERTFLAG, SERIALTYPE, DIVID, STKHIRERATE, DEFINVVATID into #deleted from DELETED

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

		
ALTER TABLE [dbo].[INVENTORY] ENABLE TRIGGER [LOGMASTERINVENTORY]
EXEC sp_settriggerorder @triggername=N'[dbo].[LOGMASTERINVENTORY]', @order=N'First', @stmttype=N'UPDATE'
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


-- =============================================
-- Author:		Okker Botes
-- Create date: 02/02/2009
-- Description:	Update stock selling rate
-- =============================================
CREATE TRIGGER [updatesellrate]    ON [INVENTORY]   
FOR UPDATE    AS   
DECLARE @MuMethod int  
declare @stkID int  

SELECT @MuMethod= inventory.[MUMETHOD], @stkid = inventory.[stkid] 
from [INVENTORY] 
  inner join inserted on inventory.stkid = inserted.stkid  

if @MuMethod=0  BEGIN    
	UPDATE [INVENTORY] set STKSELLRATE=ROUND(STKCOSTRATE+(STKCOSTRATE*([MUVALUE]/100)),4)	    
	where STKID = @stkID	  
END  

if @MuMethod=1  BEGIN    
	UPDATE [INVENTORY] set STKSELLRATE=ROUND(STKCOSTRATE+[MUVALUE],4)	    
	where STKID = @stkID	 
END	  

if @MuMethod=2  BEGIN    
	UPDATE [INVENTORY] set STKSELLRATE=ROUND(STKCOSTRATE-(STKCOSTRATE*([MUVALUE]/100)),4)	    
	where STKID = @stkID	  
END	  

if @MuMethod=3  BEGIN    
	UPDATE [INVENTORY] set STKSELLRATE=ROUND(STKCOSTRATE-[MUVALUE],4)	    
	where STKID = @stkID	  
END
		
		
ALTER TABLE [dbo].[INVENTORY] ENABLE TRIGGER [updatesellrate]