/****** Object:  Table [dbo].[DBGRAPHS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DBGRAPHS](
	[graphID] [bigint] IDENTITY(1,1) NOT NULL,
	[graphName] [nvarchar](50) NOT NULL,
	[chartTitle] [nvarchar](250) NOT NULL,
	[canvasID] [nvarchar](50) NOT NULL,
	[chartType] [nvarchar](10) NOT NULL,
	[multiaxis] [bit] NOT NULL,
	[singledata] [bit] NOT NULL,
	[stacked] [bit] NOT NULL,
	[fill] [bit] NOT NULL,
	[periodOnly] [bit] NOT NULL,
	[filterOption] [nvarchar](50) NOT NULL,
	[hasAccruals] [bit] NOT NULL,
	[incAccruals] [bit] NOT NULL,
	[thousands] [bit] NOT NULL,
	[UserID] [int] NOT NULL,
	[BOrgID] [int] NOT NULL,
	[DashBoard] [nvarchar](250) NOT NULL,
	[db_default] [bit] NOT NULL,
 CONSTRAINT [PK_DBGRAPHS] PRIMARY KEY CLUSTERED 
(
	[graphID] ASC,
	[graphName] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]