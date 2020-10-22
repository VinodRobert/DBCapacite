/****** Object:  Table [BT].[WorkOrderSpread]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[WorkOrderSpread](
	[WorkOrderSpreadID] [bigint] NOT NULL,
	[WorkOrderCode] [int] NULL,
	[YearPeriodCode] [int] NULL,
	[Qty] [decimal](18, 4) NULL,
	[Rate] [decimal](18, 2) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
	[MajorRevision] [int] NULL,
	[MinorRevision] [int] NULL,
 CONSTRAINT [PK_WorkOrderSpread] PRIMARY KEY CLUSTERED 
(
	[WorkOrderSpreadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]