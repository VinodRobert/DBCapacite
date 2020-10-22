/****** Object:  Table [dbo].[InventoryReqTrans]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[InventoryReqTrans](
	[ReqTransID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ReqHeadID] [bigint] NOT NULL,
	[StkCode] [char](20) NOT NULL,
	[LedgerCode] [char](10) NOT NULL,
	[ActNumber] [char](10) NOT NULL,
	[DelNumber] [nchar](10) NOT NULL,
	[ReqQ] [numeric](18, 4) NOT NULL,
	[DelQ] [numeric](18, 4) NOT NULL,
	[IssueQ] [numeric](18, 4) NOT NULL,
 CONSTRAINT [PK_InventoryReqTrans] PRIMARY KEY CLUSTERED 
(
	[ReqTransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[InventoryReqTrans] ADD  CONSTRAINT [DF_InventoryReqTrans_ReqQ]  DEFAULT ((0)) FOR [ReqQ]
ALTER TABLE [dbo].[InventoryReqTrans] ADD  CONSTRAINT [DF_InventoryReqTrans_DelQ]  DEFAULT ((0)) FOR [DelQ]
ALTER TABLE [dbo].[InventoryReqTrans] ADD  CONSTRAINT [DF_InventoryReqTrans_IssueQ]  DEFAULT ((0)) FOR [IssueQ]
ALTER TABLE [dbo].[InventoryReqTrans]  WITH CHECK ADD  CONSTRAINT [FK_InventoryReqTrans_ACTIVITIES] FOREIGN KEY([ActNumber])
REFERENCES [dbo].[ACTIVITIES] ([ActNumber])
ALTER TABLE [dbo].[InventoryReqTrans] CHECK CONSTRAINT [FK_InventoryReqTrans_ACTIVITIES]
ALTER TABLE [dbo].[InventoryReqTrans]  WITH CHECK ADD  CONSTRAINT [FK_InventoryReqTrans_InventoryReqHeader] FOREIGN KEY([ReqHeadID])
REFERENCES [dbo].[InventoryReqHeader] ([ReqHeadID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[InventoryReqTrans] CHECK CONSTRAINT [FK_InventoryReqTrans_InventoryReqHeader]
ALTER TABLE [dbo].[InventoryReqTrans]  WITH CHECK ADD  CONSTRAINT [FK_InventoryReqTrans_LEDGERCODES] FOREIGN KEY([LedgerCode])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[InventoryReqTrans] CHECK CONSTRAINT [FK_InventoryReqTrans_LEDGERCODES]