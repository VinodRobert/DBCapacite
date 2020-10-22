/****** Object:  Table [dbo].[INVBULKHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[INVBULKHEADER](
	[HID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BORGID] [int] NOT NULL,
	[USERID] [int] NOT NULL,
	[STORECODE] [nvarchar](15) NOT NULL,
	[REQNUMBER] [nvarchar](10) NOT NULL,
	[TRANDATE] [datetime] NULL,
	[TRANSREF] [nvarchar](10) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NOT NULL,
	[NOTES] [nvarchar](255) NOT NULL,
	[LOGUSERID] [int] NOT NULL,
	[LOGDATETIME] [datetime] NOT NULL,
 CONSTRAINT [PK_INVBULKHEADER] PRIMARY KEY CLUSTERED 
(
	[HID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_BORGID]  DEFAULT ((-1)) FOR [BORGID]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_STORECODE]  DEFAULT ('') FOR [STORECODE]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_REQNUMBER]  DEFAULT ('') FOR [REQNUMBER]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_TRANDATE]  DEFAULT (getdate()) FOR [TRANDATE]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_TRANSREF]  DEFAULT ('') FOR [TRANSREF]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_NOTES]  DEFAULT ('') FOR [NOTES]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_LOGUSERID]  DEFAULT ((-1)) FOR [LOGUSERID]
ALTER TABLE [dbo].[INVBULKHEADER] ADD  CONSTRAINT [DF_INVBULKHEADER_LOGDATETIME]  DEFAULT (getdate()) FOR [LOGDATETIME]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGINVBULKHEADER ON INVBULKHEADER
AFTER UPDATE, INSERT
AS 

SET NOCOUNT ON

declare @columnName nvarchar(500)
declare @keyColumn nvarchar(500)
declare @tableName nvarchar(500)
declare @sSql nvarchar(4000)
declare @primaryKey nvarchar(500)
declare @_ID nvarchar(500)
declare @logUserID int
declare @logDateTime datetime
declare @context_info int

SELECT @tableName = o.name
FROM sysobjects t
JOIN sysobjects o ON t.parent_obj = o.id
WHERE t.id = @@PROCID

set @context_info = -1
set @primaryKey = ''
set @logUserID = -1
set @logDateTime = DATEADD(M, -1, getDate()) 


/*GETS THE PRIMARY KEY COLUMNS*/
SELECT COLUMN_NAME
into #primanyKeys
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE OBJECTPROPERTY(OBJECT_ID(constraint_name), 'IsPrimaryKey') = 1
AND table_name = @tableName

select * into #inserted from INSERTED

set @sSql = 'DECLARE attribCursor CURSOR FOR '
set @sSql = @sSql + 'select '
DECLARE keyCursor CURSOR FOR
select COLUMN_NAME FROM #primanyKeys
OPEN keyCursor
FETCH NEXT FROM keyCursor into @keyColumn
WHILE @@FETCH_STATUS=0
BEGIN	
	if @primaryKey <> '' 
	BEGIN
		set @sSql = @sSql + ' + '' AND '' + '
	END
	set @sSql = @sSql + ''''+ @keyColumn +'='' + '''''''' + cast(rtrim(' + @keyColumn + ') as nvarchar(100)) + '''''''' '
	set @primaryKey = @keyColumn
FETCH NEXT FROM keyCursor into @keyColumn
END   
CLOSE keyCursor
DEALLOCATE keyCursor
set @sSql = @sSql + 'as _ID '
set @sSql = @sSql + 'FROM #inserted '
 
exec sp_executesql @sSql

SELECT @context_info = cast(replace(cast(CONTEXT_INFO as varchar(128)), char(0) COLLATE SQL_Latin1_General_CP1_CI_AS,'') as int) FROM master.dbo.sysprocesses WHERE spid = @@SPID

select @logUserID = isnull(USERID, -1),
@logDateTime = isnull(LOGDATETIME, DATEADD(M, -1, getDate()))
from logcontext 
where LOGID = @context_info
	
delete FROM LOGCONTEXT where LOGID = @context_info
  
OPEN attribCursor
FETCH NEXT FROM attribCursor into @_ID

WHILE @@FETCH_STATUS=0
BEGIN	 
  set @primaryKey = @_ID
  
  if DATEDIFF(s,@logDateTime, getDate()) > 5 or @logDateTime is null
	BEGIN
		set @logUserID= -1
	END

  set @sSql = 'UPDATE INVBULKHEADER SET LOGUSERID = ' + cast(@logUserID as nvarchar(5)) + ', LOGDATETIME = getDate() WHERE ' + @primaryKey + ''
	
  exec sp_executesql @sSql

	FETCH NEXT FROM attribCursor into @_ID
END   

close attribCursor
DEALLOCATE attribCursor

DROP TABLE #inserted
DROP TABLE #primanyKeys

		
ALTER TABLE [dbo].[INVBULKHEADER] ENABLE TRIGGER [LOGINVBULKHEADER]