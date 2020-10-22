/****** Object:  Table [dbo].[SITEREQ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SITEREQ](
	[REQID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[REQNAME] [nvarchar](75) NOT NULL,
	[CONTRID] [int] NOT NULL,
	[REQTEXT] [ntext] NOT NULL,
	[ATTACHMENT] [nvarchar](255) NOT NULL,
	[ATTFILESIZE] [numeric](18, 0) NOT NULL,
	[ATTCONTENTTYPE] [nvarchar](75) NOT NULL,
	[ISBORG] [bit] NOT NULL,
	[REPLY] [ntext] NOT NULL,
	[STATUSID] [int] NOT NULL,
	[OLDREPLY] [ntext] NOT NULL,
	[REQDATE] [datetime] NOT NULL,
	[BORGID] [int] NOT NULL,
	[USERID] [int] NOT NULL,
	[TARGETUSERID] [int] NOT NULL,
	[EID] [char](10) NOT NULL,
 CONSTRAINT [PK_SITEREQ] PRIMARY KEY CLUSTERED 
(
	[REQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_REQNAME]  DEFAULT ('') FOR [REQNAME]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_REQTEXT]  DEFAULT ('') FOR [REQTEXT]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_ATTACHEMENT]  DEFAULT ('') FOR [ATTACHMENT]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_FILESIZE]  DEFAULT (0) FOR [ATTFILESIZE]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_ATTCONTENTTYPE]  DEFAULT ('') FOR [ATTCONTENTTYPE]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_ISBORGID]  DEFAULT (0) FOR [ISBORG]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_REPLY_1]  DEFAULT ('') FOR [REPLY]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_STATUSID]  DEFAULT (269) FOR [STATUSID]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_OLDREPLY]  DEFAULT ('') FOR [OLDREPLY]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_REQDATE]  DEFAULT (getdate()) FOR [REQDATE]
ALTER TABLE [dbo].[SITEREQ] ADD  CONSTRAINT [DF_SITEREQ_TARGETUSERID]  DEFAULT ((-1)) FOR [TARGETUSERID]
ALTER TABLE [dbo].[SITEREQ] ADD  DEFAULT ('') FOR [EID]