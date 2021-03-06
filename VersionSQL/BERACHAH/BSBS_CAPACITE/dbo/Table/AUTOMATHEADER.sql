/****** Object:  Table [dbo].[AUTOMATHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AUTOMATHEADER](
	[AMHID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ISACTIVE] [bit] NOT NULL,
	[NAME] [nvarchar](35) NOT NULL,
	[DESCRIPTION] [text] NOT NULL,
	[ORGID] [int] NOT NULL,
	[SEQ] [int] NOT NULL,
	[AQID] [int] NOT NULL,
	[ACID] [int] NOT NULL,
	[ATID] [int] NOT NULL,
	[EMAIL] [nvarchar](255) NOT NULL,
	[TYPE] [nvarchar](15) NOT NULL,
	[FILENAME] [nvarchar](255) NOT NULL,
	[DELIMITER] [nvarchar](10) NOT NULL,
	[TID] [int] NOT NULL,
	[EmailCC] [nvarchar](255) NULL,
	[STATUS] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_AUTOMATHEADER] PRIMARY KEY CLUSTERED 
(
	[AMHID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_ISACTIVE]  DEFAULT ((0)) FOR [ISACTIVE]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_NAME]  DEFAULT ('') FOR [NAME]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_ORGID]  DEFAULT ((-1)) FOR [ORGID]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_SEQ]  DEFAULT ((-1)) FOR [SEQ]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_AQID]  DEFAULT ((-1)) FOR [AQID]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_ACID]  DEFAULT ((-1)) FOR [ACID]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_ATID]  DEFAULT ((-1)) FOR [ATID]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_EMAIL]  DEFAULT ('') FOR [EMAIL]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_TYPE]  DEFAULT ('') FOR [TYPE]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_FILENAME]  DEFAULT ('') FOR [FILENAME]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_DELIMITER]  DEFAULT (',') FOR [DELIMITER]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_TID]  DEFAULT ((-1)) FOR [TID]
ALTER TABLE [dbo].[AUTOMATHEADER] ADD  CONSTRAINT [DF_AUTOMATHEADER_STATUS]  DEFAULT (N'PENDING') FOR [STATUS]