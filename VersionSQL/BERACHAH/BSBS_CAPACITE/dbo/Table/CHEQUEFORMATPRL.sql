/****** Object:  Table [dbo].[CHEQUEFORMATPRL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CHEQUEFORMATPRL](
	[Description] [char](35) NULL,
	[XCoord] [decimal](18, 0) NULL,
	[YCoord] [decimal](18, 0) NULL,
	[BorgID] [int] NULL,
	[PageWidth] [decimal](18, 0) NULL,
	[PageHeight] [decimal](18, 0) NULL,
	[Font] [int] NULL,
	[Align] [char](20) NULL,
	[OutputTo] [char](55) NULL,
	[TextSize] [decimal](18, 0) NULL,
	[InWords] [bit] NOT NULL,
	[Denomination] [char](15) NOT NULL,
	[OnLine] [decimal](18, 0) NOT NULL,
	[InColumn] [decimal](18, 0) NOT NULL,
	[DATEFORMAT] [char](10) NOT NULL
) ON [PRIMARY]