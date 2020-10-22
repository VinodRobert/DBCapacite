/****** Object:  Table [BT].[RevisionIDS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[RevisionIDS](
	[PROJECTCODE] [int] NULL,
	[BUDGETSHORTCODE] [varchar](15) NULL,
	[REVISIONID] [decimal](6, 2) NULL,
	[REMARKS] [varchar](500) NULL,
	[REVISIONDATE] [datetime] NULL,
	[APPROVER] [varchar](60) NULL,
	[AMOUNT] [decimal](18, 2) NULL,
	[MAJORREVISION] [int] NULL,
	[MINORREVISION] [int] NULL
) ON [PRIMARY]

ALTER TABLE [BT].[RevisionIDS] ADD  CONSTRAINT [DF__RevisionI__REVIS__34A179DA]  DEFAULT (getdate()) FOR [REVISIONDATE]