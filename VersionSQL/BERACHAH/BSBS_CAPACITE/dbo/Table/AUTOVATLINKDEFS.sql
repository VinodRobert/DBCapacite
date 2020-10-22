/****** Object:  Table [dbo].[AUTOVATLINKDEFS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AUTOVATLINKDEFS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AUTOVATGROUPSID] [int] NOT NULL,
	[MASTERID] [int] NOT NULL,
	[MASTERTYPE] [int] NOT NULL,
	[VATID] [char](2) NOT NULL,
 CONSTRAINT [PK_AUTOVATLINKDEFS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AUTOVATLINKDEFS] ADD  CONSTRAINT [DF_AUTOVATLINKDEFS_AUTOVATGROUPSID]  DEFAULT ((-1)) FOR [AUTOVATGROUPSID]
ALTER TABLE [dbo].[AUTOVATLINKDEFS] ADD  CONSTRAINT [DF_AUTOVATLINKDEFS_MASTERID]  DEFAULT ((-1)) FOR [MASTERID]
ALTER TABLE [dbo].[AUTOVATLINKDEFS] ADD  CONSTRAINT [DF_AUTOVATLINKDEFS_MASTERTYPE]  DEFAULT ((-1)) FOR [MASTERTYPE]
ALTER TABLE [dbo].[AUTOVATLINKDEFS] ADD  CONSTRAINT [DF_AUTOVATLINKDEFS_VATID]  DEFAULT ('') FOR [VATID]