/****** Object:  Table [dbo].[SVNUMBERCACHE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SVNUMBERCACHE](
	[SVNCID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SVNID] [int] NOT NULL,
	[SVN] [nvarchar](50) NOT NULL,
	[INUSE] [bit] NOT NULL,
	[THETIME] [datetime] NOT NULL,
 CONSTRAINT [PK_SVNUMBERCACHE] PRIMARY KEY CLUSTERED 
(
	[SVNCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SVNUMBERCACHE] ADD  CONSTRAINT [DF_SVNUMBERCACHE_SVN]  DEFAULT ('') FOR [SVN]
ALTER TABLE [dbo].[SVNUMBERCACHE] ADD  CONSTRAINT [DF_SVNUMBERCACHE_INUSE]  DEFAULT (N'1') FOR [INUSE]
ALTER TABLE [dbo].[SVNUMBERCACHE] ADD  CONSTRAINT [DF_SVNUMBERCACHE_THETIME]  DEFAULT (getdate()) FOR [THETIME]