/****** Object:  Table [BT].[OverheadSpread]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[OverheadSpread](
	[OverheadSpreadID] [bigint] NOT NULL,
	[OverheadCode] [int] NULL,
	[GLCode] [varchar](10) NULL,
	[YearPeriodCode] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
 CONSTRAINT [PK_OverheadSpread] PRIMARY KEY CLUSTERED 
(
	[OverheadSpreadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]