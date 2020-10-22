/****** Object:  Table [dbo].[EMPSTATUSCODES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPSTATUSCODES](
	[CODE] [nvarchar](5) NOT NULL,
	[DESCR] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_EMPTERMCODES] PRIMARY KEY CLUSTERED 
(
	[CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPSTATUSCODES] ADD  CONSTRAINT [DF_EMPTERMCODES_CODE]  DEFAULT ('') FOR [CODE]
ALTER TABLE [dbo].[EMPSTATUSCODES] ADD  CONSTRAINT [DF_EMPTERMCODES_DESCR]  DEFAULT ('') FOR [DESCR]