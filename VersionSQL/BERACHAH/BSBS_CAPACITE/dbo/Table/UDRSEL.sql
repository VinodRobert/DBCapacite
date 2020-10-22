/****** Object:  Table [dbo].[UDRSEL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UDRSEL](
	[SID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TID] [int] NOT NULL,
	[UID] [int] NOT NULL,
	[SHARE] [bit] NOT NULL,
	[GROUP1] [nvarchar](255) NOT NULL,
	[GROUP2] [nvarchar](255) NOT NULL,
	[GROUP3] [nvarchar](255) NOT NULL,
	[DESCR] [nvarchar](255) NOT NULL,
	[REPORTNAME] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_UDRSEL] PRIMARY KEY CLUSTERED 
(
	[SID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_TID]  DEFAULT ('-1') FOR [TID]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_UID]  DEFAULT ('-1') FOR [UID]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_SHARE]  DEFAULT ('0') FOR [SHARE]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_GROUP1]  DEFAULT ('') FOR [GROUP1]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_GROUP2]  DEFAULT ('') FOR [GROUP2]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_GROUP3]  DEFAULT ('') FOR [GROUP3]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_DESCR]  DEFAULT ('') FOR [DESCR]
ALTER TABLE [dbo].[UDRSEL] ADD  CONSTRAINT [DF_UDRSEL_REPORTNAME]  DEFAULT ('') FOR [REPORTNAME]