/****** Object:  Table [dbo].[UDRSELDETAILS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UDRSELDETAILS](
	[DID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SID] [int] NOT NULL,
	[COLUMNNAME] [nvarchar](255) NOT NULL,
	[SHOW] [bit] NOT NULL,
	[ALIAS] [nvarchar](255) NOT NULL,
	[SORT] [int] NOT NULL,
	[ORDER] [int] NOT NULL,
	[FILTER1] [nvarchar](25) NOT NULL,
	[FILTERV1] [nvarchar](255) NOT NULL,
	[FILTER2] [nvarchar](25) NOT NULL,
	[FILTERV2] [nvarchar](255) NOT NULL,
	[FILTER3] [nvarchar](25) NOT NULL,
	[FILTERV3] [nvarchar](255) NOT NULL,
	[TOTAL] [bit] NOT NULL,
 CONSTRAINT [PK_UDRSELDETAILS] PRIMARY KEY CLUSTERED 
(
	[DID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_SID]  DEFAULT ('-1') FOR [SID]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_COLUMNNAME]  DEFAULT ('') FOR [COLUMNNAME]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_SHOW]  DEFAULT ('0') FOR [SHOW]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_ALIAS]  DEFAULT ('') FOR [ALIAS]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_SORT]  DEFAULT ('-1') FOR [SORT]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_ORDER]  DEFAULT ('-1') FOR [ORDER]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_FILTER1]  DEFAULT ('') FOR [FILTER1]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_FILTERV1]  DEFAULT ('') FOR [FILTERV1]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_FILTER2]  DEFAULT ('') FOR [FILTER2]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_FILTERV2]  DEFAULT ('') FOR [FILTERV2]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_FILTER3]  DEFAULT ('') FOR [FILTER3]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_FILTERV3]  DEFAULT ('') FOR [FILTERV3]
ALTER TABLE [dbo].[UDRSELDETAILS] ADD  CONSTRAINT [DF_UDRSELDETAILS_TOTAL]  DEFAULT ('0') FOR [TOTAL]