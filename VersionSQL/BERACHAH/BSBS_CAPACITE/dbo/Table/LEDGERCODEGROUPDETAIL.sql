/****** Object:  Table [dbo].[LEDGERCODEGROUPDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LEDGERCODEGROUPDETAIL](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HID] [int] NOT NULL,
	[TYPE] [nvarchar](3) NOT NULL,
	[TID] [int] NOT NULL,
 CONSTRAINT [PK_LEDGERCODEGROUPDETAIL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LEDGERCODEGROUPDETAIL] ADD  CONSTRAINT [DF_LEDGERCODEGROUPDETAIL_HID]  DEFAULT ((-1)) FOR [HID]
ALTER TABLE [dbo].[LEDGERCODEGROUPDETAIL] ADD  CONSTRAINT [DF_LEDGERCODEGROUPDETAIL_TYPE]  DEFAULT ('') FOR [TYPE]
ALTER TABLE [dbo].[LEDGERCODEGROUPDETAIL] ADD  CONSTRAINT [DF_LEDGERCODEGROUPDETAIL_TID]  DEFAULT ((-1)) FOR [TID]