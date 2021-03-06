/****** Object:  Table [dbo].[CHEQUEFORMAT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CHEQUEFORMAT](
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
	[InColumn] [numeric](18, 0) NOT NULL,
	[DATEFORMAT] [char](10) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CHQSTYLE] [nvarchar](15) NOT NULL,
	[CHQSTYLEID] [int] NOT NULL,
	[ONONELINE] [bit] NOT NULL,
	[CHID] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_InWords]  DEFAULT (0) FOR [InWords]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_Denomination]  DEFAULT ('Rand') FOR [Denomination]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_OnLine]  DEFAULT (10) FOR [OnLine]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_InColumn]  DEFAULT (10) FOR [InColumn]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_DATEFORMAT]  DEFAULT ('') FOR [DATEFORMAT]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_CHQSTYLE]  DEFAULT ('') FOR [CHQSTYLE]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_CHQSTYLEID]  DEFAULT ('0') FOR [CHQSTYLEID]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  CONSTRAINT [DF_CHEQUEFORMAT_ONONELINE]  DEFAULT ('0') FOR [ONONELINE]
ALTER TABLE [dbo].[CHEQUEFORMAT] ADD  DEFAULT ((-1)) FOR [CHID]