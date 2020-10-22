/****** Object:  Table [BT].[Projects]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[Projects](
	[ProjectID] [int] NOT NULL,
	[ProjectCode] [varchar](10) NULL,
	[BorgID] [int] NULL,
	[ProjectName] [varchar](100) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Duration] [int] NULL,
	[BeginYearPeriodCode] [int] NULL,
	[EndYearPeriodCode] [int] NULL,
	[Status] [int] NULL,
	[BSProjectID] [int] NULL,
	[BSContractID] [int] NULL,
	[BSDeliveryID] [int] NULL,
	[BSStoreName] [varchar](25) NULL,
	[BSStoreLedgerCode] [varchar](10) NULL,
	[BSStoreLedgerID] [int] NULL,
	[CTCRevisionID] [int] NULL,
	[CTCRevisionDate] [datetime] NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [BT].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_YearPeriodMaster] FOREIGN KEY([BeginYearPeriodCode])
REFERENCES [BT].[YearPeriodMaster] ([YearPeriodID])
ALTER TABLE [BT].[Projects] CHECK CONSTRAINT [FK_Projects_YearPeriodMaster]
ALTER TABLE [BT].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_YearPeriodMaster1] FOREIGN KEY([EndYearPeriodCode])
REFERENCES [BT].[YearPeriodMaster] ([YearPeriodID])
ALTER TABLE [BT].[Projects] CHECK CONSTRAINT [FK_Projects_YearPeriodMaster1]