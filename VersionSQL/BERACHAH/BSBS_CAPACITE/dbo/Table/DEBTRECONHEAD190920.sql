/****** Object:  Table [dbo].[DEBTRECONHEAD190920]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONHEAD190920](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CODE] [nvarchar](10) NULL,
	[DESCRIPTION] [nvarchar](250) NULL,
	[MASTA] [nvarchar](50) NULL,
	[MASTB] [nvarchar](50) NULL,
	[MASTC] [nvarchar](50) NULL,
	[MASTD] [nvarchar](50) NULL,
	[MASTE] [nvarchar](50) NULL,
	[ACCSPEC] [int] NULL,
	[POST_ON] [int] NULL,
	[NUM] [int] NULL,
	[TAXIE] [int] NULL,
	[ReconHistID] [int] NOT NULL
) ON [PRIMARY]