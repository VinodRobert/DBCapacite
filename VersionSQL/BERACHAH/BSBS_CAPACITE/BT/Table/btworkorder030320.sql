/****** Object:  Table [BT].[btworkorder030320]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[btworkorder030320](
	[WorkOrderID] [int] NOT NULL,
	[ProjectCode] [int] NULL,
	[BOQCode] [varchar](10) NULL,
	[MinorWorkHeadID] [varchar](15) NOT NULL,
	[UOM] [varchar](10) NOT NULL,
	[TOTALQTY] [decimal](18, 4) NOT NULL,
	[Rate] [decimal](18, 4) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
	[MajorRevision] [int] NULL,
	[MinorRevision] [int] NULL,
	[ReleaseStatus] [int] NULL,
	[TenderItemID] [bigint] NULL
) ON [PRIMARY]