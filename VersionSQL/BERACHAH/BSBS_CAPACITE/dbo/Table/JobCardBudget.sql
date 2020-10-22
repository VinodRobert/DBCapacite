/****** Object:  Table [dbo].[JobCardBudget]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobCardBudget](
	[JobBID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JobCardID] [int] NOT NULL,
	[LedgerCode] [char](10) NOT NULL,
	[JobBDescription] [char](200) NOT NULL,
	[JobBUnit] [char](10) NOT NULL,
	[JobBQuantity] [numeric](18, 0) NOT NULL,
	[JobBRate] [money] NOT NULL,
	[JobBCurrency] [char](10) NOT NULL,
	[JobBVattype] [char](10) NOT NULL,
	[JobBVatAmount] [money] NOT NULL,
	[JobBAmount] [money] NOT NULL,
	[JobBTAmount] [money] NOT NULL,
 CONSTRAINT [PK_JobCardBudget] PRIMARY KEY CLUSTERED 
(
	[JobBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JobCardBudget]  WITH CHECK ADD  CONSTRAINT [FK_JobCardBudget_JobCardHeader] FOREIGN KEY([JobCardID])
REFERENCES [dbo].[JobCardHeader] ([JobCardID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[JobCardBudget] CHECK CONSTRAINT [FK_JobCardBudget_JobCardHeader]
ALTER TABLE [dbo].[JobCardBudget]  WITH CHECK ADD  CONSTRAINT [FK_JobCardBudget_LEDGERCODES] FOREIGN KEY([LedgerCode])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[JobCardBudget] CHECK CONSTRAINT [FK_JobCardBudget_LEDGERCODES]