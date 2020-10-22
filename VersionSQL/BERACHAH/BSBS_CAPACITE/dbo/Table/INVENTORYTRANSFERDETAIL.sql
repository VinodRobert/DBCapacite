/****** Object:  Table [dbo].[INVENTORYTRANSFERDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[INVENTORYTRANSFERDETAIL](
	[DID] [int] IDENTITY(1,1) NOT NULL,
	[HID] [int] NOT NULL,
	[STKID] [int] NOT NULL,
	[QTY] [numeric](18, 4) NOT NULL,
	[RATE] [money] NOT NULL,
 CONSTRAINT [PK_INVENTORYTRANSFERDETAIL] PRIMARY KEY CLUSTERED 
(
	[DID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[INVENTORYTRANSFERDETAIL] ADD  CONSTRAINT [DF_INVENTORYTRANSFERDETAIL_HID]  DEFAULT ((-1)) FOR [HID]
ALTER TABLE [dbo].[INVENTORYTRANSFERDETAIL] ADD  CONSTRAINT [DF_INVENTORYTRANSFERDETAIL_STKID]  DEFAULT ((-1)) FOR [STKID]
ALTER TABLE [dbo].[INVENTORYTRANSFERDETAIL] ADD  CONSTRAINT [DF_INVENTORYTRANSFERDETAIL_QTY]  DEFAULT (N'0') FOR [QTY]
ALTER TABLE [dbo].[INVENTORYTRANSFERDETAIL] ADD  CONSTRAINT [DF_INVENTORYTRANSFERDETAIL_RATE]  DEFAULT ((0)) FOR [RATE]