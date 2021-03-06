/****** Object:  Table [dbo].[EFTFORMATDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EFTFORMATDETAIL](
	[EDID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EHID] [int] NOT NULL,
	[NAME] [nvarchar](255) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NOT NULL,
	[DATATYPE] [nvarchar](10) NOT NULL,
	[DATASIZE] [nvarchar](10) NOT NULL,
	[DATAFILL] [varchar](1) NOT NULL,
	[DATAFILLTYPE] [varchar](5) NOT NULL,
	[TYPE] [char](2) NOT NULL,
	[VALUE] [nvarchar](55) NOT NULL,
	[SEQ] [int] NOT NULL,
	[FORMAT] [nvarchar](250) NOT NULL,
	[VALIDATION] [nvarchar](250) NOT NULL,
	[CONDITION] [nvarchar](250) NOT NULL,
	[XMLTAG] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_EFTFORMATDETAIL] PRIMARY KEY CLUSTERED 
(
	[EDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_EHID]  DEFAULT ((-1)) FOR [EHID]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_NAME]  DEFAULT ('') FOR [NAME]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_DATATYPE]  DEFAULT ('') FOR [DATATYPE]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_DATASIZE]  DEFAULT ('') FOR [DATASIZE]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_DATAFILL]  DEFAULT ('') FOR [DATAFILL]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_DATAFILLTYPE]  DEFAULT ('NONE') FOR [DATAFILLTYPE]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_TYPE]  DEFAULT ('D') FOR [TYPE]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_VALUE]  DEFAULT ('') FOR [VALUE]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_SEQ]  DEFAULT ((-1)) FOR [SEQ]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_FORMAT]  DEFAULT ('') FOR [FORMAT]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_VALIDATION]  DEFAULT ('') FOR [VALIDATION]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_CONDITION]  DEFAULT ('') FOR [CONDITION]
ALTER TABLE [dbo].[EFTFORMATDETAIL] ADD  CONSTRAINT [DF_EFTFORMATDETAIL_XMLTAG]  DEFAULT ('') FOR [XMLTAG]