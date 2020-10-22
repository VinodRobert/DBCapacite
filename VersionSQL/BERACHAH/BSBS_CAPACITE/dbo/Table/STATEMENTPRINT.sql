/****** Object:  Table [dbo].[STATEMENTPRINT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STATEMENTPRINT](
	[Description] [char](35) NULL,
	[Type] [char](2) NULL,
	[YCoord] [numeric](18, 0) NULL,
	[XCoord] [numeric](18, 0) NULL,
	[BorgID] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[STATEMENTPRINT] ADD  CONSTRAINT [DF_STATEMENTPRINT_BorgID]  DEFAULT (0) FOR [BorgID]