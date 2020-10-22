/****** Object:  Table [dbo].[JobCardTechs]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobCardTechs](
	[JTID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JTName] [nvarchar](50) NULL,
	[JTDesc] [nvarchar](500) NULL,
	[JTRate] [money] NULL,
	[JTUnit] [char](10) NULL,
	[JTRateType] [nvarchar](50) NULL,
 CONSTRAINT [PK_JobCardTechs] PRIMARY KEY CLUSTERED 
(
	[JTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]