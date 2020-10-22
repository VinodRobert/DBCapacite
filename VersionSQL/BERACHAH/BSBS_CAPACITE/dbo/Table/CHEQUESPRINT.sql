/****** Object:  Table [dbo].[CHEQUESPRINT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CHEQUESPRINT](
	[Description] [char](35) NULL,
	[XCoord] [numeric](18, 0) NULL,
	[YCoord] [numeric](18, 0) NULL,
	[BorgID] [int] NULL,
	[PageWidth] [numeric](18, 0) NULL,
	[PageHeight] [numeric](18, 0) NULL,
	[Font] [int] NULL,
	[Align] [char](20) NULL,
	[OutputTo] [char](55) NULL,
	[TextSize] [numeric](18, 0) NULL,
	[InWords] [bit] NOT NULL,
	[Denomination] [char](15) NOT NULL,
	[OnLine] [numeric](18, 0) NOT NULL,
	[InColumn] [numeric](18, 0) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CHEQUESPRINT] ADD  CONSTRAINT [DF_CHEQUESPRINT_InWords]  DEFAULT (0) FOR [InWords]
ALTER TABLE [dbo].[CHEQUESPRINT] ADD  CONSTRAINT [DF_CHEQUESPRINT_Denomination]  DEFAULT ('Rand') FOR [Denomination]
ALTER TABLE [dbo].[CHEQUESPRINT] ADD  CONSTRAINT [DF_CHEQUESPRINT_OnLine]  DEFAULT (10) FOR [OnLine]
ALTER TABLE [dbo].[CHEQUESPRINT] ADD  CONSTRAINT [DF_CHEQUESPRINT_InColumn]  DEFAULT (10) FOR [InColumn]