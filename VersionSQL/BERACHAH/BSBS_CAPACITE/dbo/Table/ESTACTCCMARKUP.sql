/****** Object:  Table [dbo].[ESTACTCCMARKUP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ESTACTCCMARKUP](
	[ESTID] [int] NOT NULL,
	[ACTNUMBER] [nvarchar](10) NOT NULL,
	[CCMP1] [decimal](18, 2) NOT NULL,
	[CCMP2] [decimal](18, 2) NOT NULL,
	[CCMP3] [decimal](18, 2) NOT NULL,
	[CCMP4] [decimal](18, 2) NOT NULL,
	[CCMP5] [decimal](18, 2) NOT NULL,
	[CCMP6] [decimal](18, 2) NOT NULL,
	[CCMP7] [decimal](18, 2) NOT NULL,
	[CCMP8] [decimal](18, 2) NOT NULL,
	[CCMP9] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_ESTACTMARKUP] PRIMARY KEY CLUSTERED 
(
	[ESTID] ASC,
	[ACTNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP1]  DEFAULT (0) FOR [CCMP1]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP2]  DEFAULT (0) FOR [CCMP2]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP3]  DEFAULT (0) FOR [CCMP3]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP4]  DEFAULT (0) FOR [CCMP4]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP5]  DEFAULT (0) FOR [CCMP5]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP6]  DEFAULT (0) FOR [CCMP6]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP7]  DEFAULT (0) FOR [CCMP7]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP8]  DEFAULT (0) FOR [CCMP8]
ALTER TABLE [dbo].[ESTACTCCMARKUP] ADD  CONSTRAINT [DF_ESTACTMARKUP_CCMP9]  DEFAULT (0) FOR [CCMP9]