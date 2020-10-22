/****** Object:  Table [dbo].[RSC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RSC](
	[AreaCode] [nvarchar](10) NOT NULL,
	[AreaName] [nvarchar](50) NOT NULL,
	[LabourPercentage] [decimal](10, 6) NOT NULL,
	[TurnOverPercentage] [decimal](10, 6) NOT NULL,
 CONSTRAINT [PK_RSC] PRIMARY KEY CLUSTERED 
(
	[AreaCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]