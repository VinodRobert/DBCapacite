/****** Object:  Table [dbo].[TRANSNOTES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TRANSNOTES](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TRANSID] [int] NOT NULL,
	[USERID] [int] NOT NULL,
	[SEQ] [int] NOT NULL,
	[STATUS] [nvarchar](30) NOT NULL,
	[THEDATE] [datetime] NOT NULL,
	[OPENED] [bit] NOT NULL,
	[DESCRIPTION] [text] NOT NULL,
 CONSTRAINT [PK_TRANSNOTES] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_TRANSID]  DEFAULT ('-1') FOR [TRANSID]
ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_USERID]  DEFAULT ('-1') FOR [USERID]
ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_SEQ]  DEFAULT ('-1') FOR [SEQ]
ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_STATUS]  DEFAULT ('') FOR [STATUS]
ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_THEDATE]  DEFAULT (getdate()) FOR [THEDATE]
ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_OPENED]  DEFAULT ('0') FOR [OPENED]
ALTER TABLE [dbo].[TRANSNOTES] ADD  CONSTRAINT [DF_TRANSNOTES_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]