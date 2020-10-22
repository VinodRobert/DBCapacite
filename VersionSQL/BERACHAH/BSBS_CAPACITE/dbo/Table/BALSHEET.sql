/****** Object:  Table [dbo].[BALSHEET]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BALSHEET](
	[BSID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BSCODE] [char](10) NOT NULL,
	[BSDETAIL] [char](1) NOT NULL,
	[BSDESC] [char](55) NOT NULL,
 CONSTRAINT [PK_BALSHEET] PRIMARY KEY CLUSTERED 
(
	[BSCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BALSHEET] ADD  CONSTRAINT [DF_BALSHEET_BSCODE]  DEFAULT ('') FOR [BSCODE]
ALTER TABLE [dbo].[BALSHEET] ADD  CONSTRAINT [DF_BALSHEET_BSDETAIL]  DEFAULT ('') FOR [BSDETAIL]
ALTER TABLE [dbo].[BALSHEET] ADD  CONSTRAINT [DF_BALSHEET_BSDESC]  DEFAULT ('') FOR [BSDESC]