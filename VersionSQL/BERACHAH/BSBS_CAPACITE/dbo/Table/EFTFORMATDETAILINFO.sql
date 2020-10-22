/****** Object:  Table [dbo].[EFTFORMATDETAILINFO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EFTFORMATDETAILINFO](
	[EDIID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EHID] [int] NOT NULL,
	[NAME] [nvarchar](255) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NOT NULL,
	[VALUE] [nvarchar](255) NOT NULL,
	[EFTID] [int] NOT NULL,
	[OPTIONS] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_EFTFORMATDETAILINFO] PRIMARY KEY CLUSTERED 
(
	[EDIID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[EFTFORMATDETAILINFO] ADD  CONSTRAINT [DF_EFTFORMATDETAILINFO_EHID]  DEFAULT ((-1)) FOR [EHID]
ALTER TABLE [dbo].[EFTFORMATDETAILINFO] ADD  CONSTRAINT [DF_EFTFORMATDETAILINFO_NAME]  DEFAULT ('') FOR [NAME]
ALTER TABLE [dbo].[EFTFORMATDETAILINFO] ADD  CONSTRAINT [DF_EFTFORMATDETAILINFO_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[EFTFORMATDETAILINFO] ADD  CONSTRAINT [DF_EFTFORMATDETAILINFO_VALUE]  DEFAULT ('') FOR [VALUE]
ALTER TABLE [dbo].[EFTFORMATDETAILINFO] ADD  CONSTRAINT [DF_EFTFORMATDETAILINFO_EFTID]  DEFAULT ((-1)) FOR [EFTID]
ALTER TABLE [dbo].[EFTFORMATDETAILINFO] ADD  CONSTRAINT [DF_EFTFORMATDETAILINFO_OPTIONS]  DEFAULT ('') FOR [OPTIONS]