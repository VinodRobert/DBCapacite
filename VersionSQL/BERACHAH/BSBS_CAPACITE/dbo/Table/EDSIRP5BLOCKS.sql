/****** Object:  Table [dbo].[EDSIRP5BLOCKS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EDSIRP5BLOCKS](
	[IRP5BLOCK] [nvarchar](5) NOT NULL,
	[IRP5NAME] [nvarchar](255) NOT NULL,
	[DESCR] [nvarchar](255) NOT NULL,
	[SORTORD] [smallint] NOT NULL,
	[PRLSPEC] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_EDSIRP5BLOCKS] PRIMARY KEY CLUSTERED 
(
	[IRP5BLOCK] ASC,
	[PRLSPEC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EDSIRP5BLOCKS] ADD  CONSTRAINT [DF_EDSIRP5BLOCKS_IRP5NAME]  DEFAULT ('') FOR [IRP5NAME]
ALTER TABLE [dbo].[EDSIRP5BLOCKS] ADD  CONSTRAINT [DF_EDSIRP5BLOCKS_DESCR]  DEFAULT ('') FOR [DESCR]
ALTER TABLE [dbo].[EDSIRP5BLOCKS] ADD  CONSTRAINT [DF_EDSIRP5BLOCKS_SORTORD]  DEFAULT (0) FOR [SORTORD]
ALTER TABLE [dbo].[EDSIRP5BLOCKS] ADD  CONSTRAINT [DF_EDSIRP5BLOCKS_PRLSPEC]  DEFAULT ('South Africa') FOR [PRLSPEC]