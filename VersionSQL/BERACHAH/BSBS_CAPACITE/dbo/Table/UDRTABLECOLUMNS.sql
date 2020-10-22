/****** Object:  Table [dbo].[UDRTABLECOLUMNS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UDRTABLECOLUMNS](
	[CID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TID] [int] NOT NULL,
	[COLUMNNAME] [nvarchar](255) NOT NULL,
	[ALIAS] [nvarchar](255) NOT NULL,
	[EXCLUDE] [bit] NOT NULL,
 CONSTRAINT [PK_UDRTABLECOLUMNS] PRIMARY KEY CLUSTERED 
(
	[CID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UDRTABLECOLUMNS] ADD  CONSTRAINT [DF_UDRTABLECOLUMNS_TID]  DEFAULT ('-1') FOR [TID]
ALTER TABLE [dbo].[UDRTABLECOLUMNS] ADD  CONSTRAINT [DF_UDRTABLECOLUMNS_COLUMNNAME]  DEFAULT ('') FOR [COLUMNNAME]
ALTER TABLE [dbo].[UDRTABLECOLUMNS] ADD  CONSTRAINT [DF_UDRTABLECOLUMNS_ALIAS]  DEFAULT ('') FOR [ALIAS]
ALTER TABLE [dbo].[UDRTABLECOLUMNS] ADD  CONSTRAINT [DF_UDRTABLECOLUMNS_EXCLUDE]  DEFAULT ('0') FOR [EXCLUDE]