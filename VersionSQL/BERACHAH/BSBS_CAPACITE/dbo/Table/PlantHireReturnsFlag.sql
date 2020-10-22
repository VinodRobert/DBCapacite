/****** Object:  Table [dbo].[PlantHireReturnsFlag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireReturnsFlag](
	[HireRPostFlagID] [int] NOT NULL,
	[HireRPostFlagDesc] [char](30) NULL,
 CONSTRAINT [PK_PlantHireReturnsFlag] PRIMARY KEY CLUSTERED 
(
	[HireRPostFlagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]