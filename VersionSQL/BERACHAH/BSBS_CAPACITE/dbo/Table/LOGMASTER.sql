/****** Object:  Table [dbo].[LOGMASTER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LOGMASTER](
	[LOGID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[USERID] [int] NOT NULL,
	[BORGID] [int] NOT NULL,
	[APPLICATION] [nvarchar](3) NOT NULL,
	[LOGDATETIME] [datetime] NOT NULL,
	[TABLENAME] [nvarchar](50) NOT NULL,
	[ACTION] [nvarchar](50) NOT NULL,
	[PRIMARYKEY] [nvarchar](250) NOT NULL,
	[DETAILS] [text] NOT NULL,
	[PAGE] [nvarchar](250) NOT NULL,
	[INFO] [nvarchar](250) NOT NULL,
	[VERSION] [nvarchar](15) NOT NULL,
	[SYSTEM_USER] [nvarchar](55) NULL,
 CONSTRAINT [PK_LOGMASTER] PRIMARY KEY CLUSTERED 
(
	[LOGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_BORGID]  DEFAULT ((-1)) FOR [BORGID]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_APPLICATION]  DEFAULT ('') FOR [APPLICATION]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_LOGDATETIME]  DEFAULT (getdate()) FOR [LOGDATETIME]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_TABLENAME]  DEFAULT ('') FOR [TABLENAME]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_ACTION]  DEFAULT ('') FOR [ACTION]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_PRIMARYKEY]  DEFAULT ('') FOR [PRIMARYKEY]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_DETAILS]  DEFAULT ('') FOR [DETAILS]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_PAGE]  DEFAULT ('') FOR [PAGE]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_INFO]  DEFAULT ('') FOR [INFO]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_VERSION]  DEFAULT ('') FOR [VERSION]
ALTER TABLE [dbo].[LOGMASTER] ADD  CONSTRAINT [DF_LOGMASTER_SYSTEM_USER]  DEFAULT (suser_sname()) FOR [SYSTEM_USER]