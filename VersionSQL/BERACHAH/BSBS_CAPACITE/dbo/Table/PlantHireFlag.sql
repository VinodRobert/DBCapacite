/****** Object:  Table [dbo].[PlantHireFlag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireFlag](
	[HireFID] [int] NOT NULL,
	[HireFName] [char](25) NOT NULL,
 CONSTRAINT [PK_PlantHireFalg] PRIMARY KEY CLUSTERED 
(
	[HireFID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]