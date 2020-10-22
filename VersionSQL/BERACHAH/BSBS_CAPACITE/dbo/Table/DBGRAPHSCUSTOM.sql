/****** Object:  Table [dbo].[DBGRAPHSCUSTOM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DBGRAPHSCUSTOM](
	[customID] [int] IDENTITY(1,1) NOT NULL,
	[graphID] [bigint] NOT NULL,
	[UserID] [int] NOT NULL,
	[customName] [nvarchar](50) NOT NULL,
	[customKey] [nvarchar](250) NOT NULL,
	[customValue] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_DBGRAPHSCUSTOM_1] PRIMARY KEY CLUSTERED 
(
	[customID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_DBGRAPHSCUSTOM_1] UNIQUE NONCLUSTERED 
(
	[graphID] ASC,
	[UserID] ASC,
	[customName] ASC,
	[customKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]