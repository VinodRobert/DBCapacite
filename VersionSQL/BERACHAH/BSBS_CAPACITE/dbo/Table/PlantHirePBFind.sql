/****** Object:  Table [dbo].[PlantHirePBFind]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHirePBFind](
	[UserID] [int] NOT NULL,
	[FGroup] [int] NULL,
	[FCat] [int] NULL,
	[FFromPlt] [char](10) NULL,
	[FToPlt] [char](10) NULL,
	[FFromBatchNum] [int] NULL,
	[FToBatchNum] [int] NULL,
	[FFromDate] [datetime] NULL,
	[FToDate] [datetime] NULL,
	[FFromDays] [int] NULL,
	[FToDays] [int] NULL,
	[FUser] [int] NULL,
	[FOrderBy] [int] NULL,
	[FFindBalancing] [bit] NULL,
	[FFindPosted] [bit] NULL,
 CONSTRAINT [PK_PlantHirePBFind] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHirePBFind] ADD  CONSTRAINT [DF_PlantHirePBFind_FFromDate]  DEFAULT (NULL) FOR [FFromDate]
ALTER TABLE [dbo].[PlantHirePBFind] ADD  CONSTRAINT [DF_PlantHirePBFind_FToDate]  DEFAULT (NULL) FOR [FToDate]
ALTER TABLE [dbo].[PlantHirePBFind] ADD  CONSTRAINT [DF_PlantHirePBFind_FShowAll]  DEFAULT ((0)) FOR [FFindBalancing]
ALTER TABLE [dbo].[PlantHirePBFind] ADD  CONSTRAINT [DF_PlantHirePBFind_FFindPosted]  DEFAULT ((0)) FOR [FFindPosted]