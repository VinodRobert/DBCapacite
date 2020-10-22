/****** Object:  Table [EI].[PINCODEMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EI].[PINCODEMaster](
	[PINIndex] [int] NOT NULL,
	[LowerRange] [int] NULL,
	[UpperRange] [int] NULL,
	[StateName] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PINIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]