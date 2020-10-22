/****** Object:  Table [dbo].[MRPHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MRPHEADER](
	[MRPID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MRPCODE] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL,
	[DEFSTORE] [char](15) NULL,
	[LOCKHOLDER] [int] NOT NULL,
	[BORGID] [int] NOT NULL,
	[UOM] [nvarchar](8) NOT NULL,
	[STKBIN] [nvarchar](10) NOT NULL,
	[STKMINBAL] [numeric](18, 4) NOT NULL,
	[STKMAXBAL] [numeric](18, 4) NOT NULL,
	[MUMETHOD] [int] NOT NULL,
	[MUVALUE] [numeric](18, 4) NOT NULL,
	[STKGLCODE] [nvarchar](10) NOT NULL,
	[STKDEFGL] [nvarchar](10) NOT NULL,
	[DIVID] [int] NOT NULL,
 CONSTRAINT [PK_MRPHEADER] PRIMARY KEY CLUSTERED 
(
	[MRPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_MPRCODE]  DEFAULT ('') FOR [MRPCODE]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_LOCKER]  DEFAULT ((0)) FOR [LOCKHOLDER]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_UOM]  DEFAULT ('') FOR [UOM]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_StkBin]  DEFAULT ('') FOR [STKBIN]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_STKMINBAL]  DEFAULT ((0)) FOR [STKMINBAL]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_STKMAXBAL]  DEFAULT ((0)) FOR [STKMAXBAL]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_MUMETHOD]  DEFAULT ((0)) FOR [MUMETHOD]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_MUVALUE]  DEFAULT ((0)) FOR [MUVALUE]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_STKGLCODE]  DEFAULT ('') FOR [STKGLCODE]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_STKDEFGL]  DEFAULT ('') FOR [STKDEFGL]
ALTER TABLE [dbo].[MRPHEADER] ADD  CONSTRAINT [DF_MRPHEADER_DIVID]  DEFAULT ('-1') FOR [DIVID]
ALTER TABLE [dbo].[MRPHEADER]  WITH NOCHECK ADD  CONSTRAINT [FK_MRPHEADER_BORGS] FOREIGN KEY([BORGID])
REFERENCES [dbo].[BORGS] ([BORGID])
ALTER TABLE [dbo].[MRPHEADER] CHECK CONSTRAINT [FK_MRPHEADER_BORGS]
ALTER TABLE [dbo].[MRPHEADER]  WITH NOCHECK ADD  CONSTRAINT [FK_MRPHEADER_INVSTORES] FOREIGN KEY([DEFSTORE])
REFERENCES [dbo].[INVSTORES] ([StoreCode])
ALTER TABLE [dbo].[MRPHEADER] CHECK CONSTRAINT [FK_MRPHEADER_INVSTORES]