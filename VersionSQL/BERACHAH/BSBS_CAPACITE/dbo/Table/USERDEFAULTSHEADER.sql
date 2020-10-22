/****** Object:  Table [dbo].[USERDEFAULTSHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[USERDEFAULTSHEADER](
	[HID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[USERID] [int] NOT NULL,
	[ORGID] [int] NOT NULL,
	[PAGE] [nvarchar](100) NOT NULL,
	[NAME] [nvarchar](100) NOT NULL,
	[ISDEFAULT] [bit] NOT NULL,
	[APPLICATION] [nvarchar](3) NOT NULL,
	[SHAREID] [int] NOT NULL,
 CONSTRAINT [PK_USERDEFAULTSHEADER] PRIMARY KEY CLUSTERED 
(
	[HID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_USERID]  DEFAULT ((-1)) FOR [USERID]
ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_ORGID]  DEFAULT ((-1)) FOR [ORGID]
ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_PAGE]  DEFAULT ('') FOR [PAGE]
ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_NAME]  DEFAULT ('') FOR [NAME]
ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_ISDEFAULT]  DEFAULT ('0') FOR [ISDEFAULT]
ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_APPLICATION]  DEFAULT ('') FOR [APPLICATION]
ALTER TABLE [dbo].[USERDEFAULTSHEADER] ADD  CONSTRAINT [DF_USERDEFAULTSHEADER_SHAREID]  DEFAULT ((-1)) FOR [SHAREID]