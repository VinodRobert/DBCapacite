/****** Object:  Table [dbo].[JobCardTechRates]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobCardTechRates](
	[JTRID] [int] IDENTITY(1,1) NOT NULL,
	[JTRType] [nvarchar](50) NOT NULL,
	[JTRDesc] [nvarchar](500) NULL
) ON [PRIMARY]