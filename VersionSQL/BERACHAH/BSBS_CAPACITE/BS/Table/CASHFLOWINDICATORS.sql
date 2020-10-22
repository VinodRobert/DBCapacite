/****** Object:  Table [BS].[CASHFLOWINDICATORS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[CASHFLOWINDICATORS](
	[POSTIONINDEX] [int] NULL,
	[COLINDEX] [int] NULL,
	[INDEXCODE] [int] NULL,
	[CATEGORY] [int] NULL,
	[COLID] [varchar](10) NULL,
	[DESCRIPTION] [varchar](50) NULL,
	[FONTID] [int] NULL,
	[AMOUNT] [decimal](18, 2) NULL
) ON [PRIMARY]