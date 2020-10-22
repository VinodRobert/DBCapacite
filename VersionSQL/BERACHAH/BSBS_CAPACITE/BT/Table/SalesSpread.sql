/****** Object:  Table [BT].[SalesSpread]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[SalesSpread](
	[SalesSpreadID] [bigint] NOT NULL,
	[SalesCode] [int] NULL,
	[ProjectCode] [int] NULL,
	[BOQNumber] [varchar](20) NULL,
	[YearPeriodCode] [int] NULL,
	[Qty] [decimal](18, 4) NULL,
	[Rate] [decimal](18, 2) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
	[MAJORREVISION] [int] NULL,
	[MINORREVISION] [int] NULL,
 CONSTRAINT [PK_SalesSpread] PRIMARY KEY CLUSTERED 
(
	[SalesSpreadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [BT].[SalesSpread]  WITH NOCHECK ADD  CONSTRAINT [FK_SalesSpread_Sales] FOREIGN KEY([SalesCode])
REFERENCES [BT].[Sales] ([SalesID])
ALTER TABLE [BT].[SalesSpread] CHECK CONSTRAINT [FK_SalesSpread_Sales]
ALTER TABLE [BT].[SalesSpread]  WITH NOCHECK ADD  CONSTRAINT [FK_SalesSpread_YearPeriodMaster] FOREIGN KEY([YearPeriodCode])
REFERENCES [BT].[YearPeriodMaster] ([YearPeriodID])
ALTER TABLE [BT].[SalesSpread] CHECK CONSTRAINT [FK_SalesSpread_YearPeriodMaster]