/****** Object:  Table [dbo].[PlantReadingsFlags]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantReadingsFlags](
	[PltFID] [int] NOT NULL,
	[PltFName] [char](40) NOT NULL,
	[PltFDisplay] [char](15) NOT NULL,
 CONSTRAINT [PK_PlantReadingsFlags] PRIMARY KEY CLUSTERED 
(
	[PltFID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]