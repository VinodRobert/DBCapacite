/****** Object:  Table [dbo].[PlantServiceDesc]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantServiceDesc](
	[PltServID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PltServDesc] [char](210) NOT NULL,
	[PltRID] [int] NOT NULL,
 CONSTRAINT [PK_PlantServiceDesc] PRIMARY KEY CLUSTERED 
(
	[PltServID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]