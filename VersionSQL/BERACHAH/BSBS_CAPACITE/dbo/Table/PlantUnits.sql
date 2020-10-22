/****** Object:  Table [dbo].[PlantUnits]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantUnits](
	[PltUnitID] [char](10) NOT NULL,
	[PltUnitDec] [char](50) NULL,
 CONSTRAINT [PK_PlantUnits] PRIMARY KEY CLUSTERED 
(
	[PltUnitID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]