/****** Object:  Table [dbo].[PAGEUSAGE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PAGEUSAGE](
	[PAGENAME] [nvarchar](100) NOT NULL,
	[SYS] [nvarchar](3) NOT NULL,
	[THEYEAR] [int] NOT NULL,
	[THEMONTH] [int] NOT NULL,
	[COUNTER] [int] NOT NULL,
 CONSTRAINT [PK_PAGEUSAGE] PRIMARY KEY CLUSTERED 
(
	[PAGENAME] ASC,
	[SYS] ASC,
	[THEYEAR] ASC,
	[THEMONTH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PAGEUSAGE] ADD  CONSTRAINT [DF_PAGEUSAGE_PAGENAME]  DEFAULT ('') FOR [PAGENAME]
ALTER TABLE [dbo].[PAGEUSAGE] ADD  CONSTRAINT [DF_PAGEUSAGE_SYS]  DEFAULT ('') FOR [SYS]
ALTER TABLE [dbo].[PAGEUSAGE] ADD  CONSTRAINT [DF_PAGEUSAGE_THEYEAR]  DEFAULT ((-1)) FOR [THEYEAR]
ALTER TABLE [dbo].[PAGEUSAGE] ADD  CONSTRAINT [DF_PAGEUSAGE_THEMONTH]  DEFAULT ((-1)) FOR [THEMONTH]
ALTER TABLE [dbo].[PAGEUSAGE] ADD  CONSTRAINT [DF_PAGEUSAGE_COUNTER]  DEFAULT ((0)) FOR [COUNTER]