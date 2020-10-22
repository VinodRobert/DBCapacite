/****** Object:  Table [dbo].[MRPDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MRPDETAIL](
	[MRPDID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MRPID] [int] NOT NULL,
	[STKSTORE] [nvarchar](15) NULL,
	[STKCODE] [nvarchar](50) NULL,
	[QTY] [numeric](18, 4) NOT NULL,
	[COSTRATE] [numeric](18, 4) NOT NULL,
	[PRODUCTION] [numeric](18, 4) NOT NULL,
	[MARKUP] [numeric](18, 4) NOT NULL,
	[CODE] [nvarchar](20) NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL,
	[CID] [int] NULL,
	[MTYPE] [smallint] NOT NULL,
	[UOM] [nvarchar](8) NOT NULL,
	[COSTLC] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_MRPDETAIL] PRIMARY KEY CLUSTERED 
(
	[MRPDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_MRPID]  DEFAULT ((0)) FOR [MRPID]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_StkStore]  DEFAULT ('') FOR [STKSTORE]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_StkCode]  DEFAULT ('') FOR [STKCODE]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_QTY]  DEFAULT ((0)) FOR [QTY]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_COSTRATE]  DEFAULT ('0') FOR [COSTRATE]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_PRODUCTION]  DEFAULT ((1)) FOR [PRODUCTION]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_MARKUP]  DEFAULT ((0)) FOR [MARKUP]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_CODE]  DEFAULT ('') FOR [CODE]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_MRPIDD]  DEFAULT ((0)) FOR [CID]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_MTYPE]  DEFAULT ((1)) FOR [MTYPE]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_UOM]  DEFAULT ('') FOR [UOM]
ALTER TABLE [dbo].[MRPDETAIL] ADD  CONSTRAINT [DF_MRPDETAIL_COSTLC]  DEFAULT ('') FOR [COSTLC]