/****** Object:  Table [dbo].[TAXZIMADDON]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TAXZIMADDON](
	[ZID] [int] IDENTITY(1,1) NOT NULL,
	[DESCR] [nvarchar](50) NOT NULL,
	[ED] [nvarchar](5) NOT NULL,
	[PERC] [decimal](18, 4) NOT NULL
) ON [PRIMARY]