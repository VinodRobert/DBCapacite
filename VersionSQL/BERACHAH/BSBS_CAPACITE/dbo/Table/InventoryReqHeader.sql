/****** Object:  Table [dbo].[InventoryReqHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[InventoryReqHeader](
	[ReqHeadID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ReqNumber] [nvarchar](10) NOT NULL,
	[ContrNumber] [nvarchar](10) NOT NULL,
	[StkStore] [char](15) NOT NULL,
	[TransDate] [datetime] NULL,
	[BorgID] [int] NOT NULL,
 CONSTRAINT [PK_InventoryReqHeader] PRIMARY KEY CLUSTERED 
(
	[ReqHeadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[InventoryReqHeader] ADD  CONSTRAINT [DF_InventoryReqHeader_TransDate]  DEFAULT (getdate()) FOR [TransDate]
ALTER TABLE [dbo].[InventoryReqHeader]  WITH CHECK ADD  CONSTRAINT [FK_InventoryReqHeader_CONTRACTS] FOREIGN KEY([ContrNumber])
REFERENCES [dbo].[CONTRACTS] ([CONTRNUMBER])
ALTER TABLE [dbo].[InventoryReqHeader] CHECK CONSTRAINT [FK_InventoryReqHeader_CONTRACTS]