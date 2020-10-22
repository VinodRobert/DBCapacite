/****** Object:  Table [dbo].[REMITTANCEPRINT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[REMITTANCEPRINT](
	[Description] [char](35) NULL,
	[XCoord] [numeric](18, 0) NULL,
	[YCoord] [numeric](18, 0) NULL,
	[BorgID] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[REMITTANCEPRINT] ADD  CONSTRAINT [DF_REMITTANCEPRINT_BorgID]  DEFAULT (0) FOR [BorgID]