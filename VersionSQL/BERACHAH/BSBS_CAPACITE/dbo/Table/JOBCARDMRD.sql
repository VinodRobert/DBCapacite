/****** Object:  Table [dbo].[JOBCARDMRD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JOBCARDMRD](
	[JCMRDID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JOBCARDID] [int] NOT NULL,
	[BORGID] [int] NOT NULL,
	[MRPID] [int] NOT NULL,
	[QTY] [numeric](18, 4) NOT NULL,
	[USEDQTY] [numeric](18, 4) NOT NULL,
	[COSTRATE] [numeric](18, 4) NOT NULL,
	[CODE] [nvarchar](20) NOT NULL,
	[STKSTORE] [nvarchar](15) NOT NULL,
	[STKCODE] [nvarchar](20) NOT NULL,
	[UOM] [nvarchar](8) NOT NULL,
	[DESCRIPTION] [nvarchar](250) NOT NULL,
	[STATUS] [bit] NOT NULL,
	[POSTDATE] [datetime] NOT NULL,
	[REQNO] [nvarchar](55) NOT NULL,
	[TRANSREF] [nvarchar](10) NOT NULL,
	[BATCHREF] [nvarchar](10) NOT NULL,
	[JOBCARDLEDGERCODE] [nvarchar](10) NOT NULL,
	[LEDGERCODE] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_JOBCARDMRD] PRIMARY KEY CLUSTERED 
(
	[JCMRDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_JOBCARDID]  DEFAULT ('-1') FOR [JOBCARDID]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_BORGID]  DEFAULT ('-1') FOR [BORGID]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_MRPID]  DEFAULT ('-1') FOR [MRPID]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_QTY]  DEFAULT ('0') FOR [QTY]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_USEDQTY]  DEFAULT ('0') FOR [USEDQTY]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_COSTRATE]  DEFAULT ('0') FOR [COSTRATE]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_CODE]  DEFAULT ('') FOR [CODE]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_STKSTORE]  DEFAULT ('') FOR [STKSTORE]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_STKCODE]  DEFAULT ('') FOR [STKCODE]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_UOM]  DEFAULT ('') FOR [UOM]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_STATUS]  DEFAULT ('0') FOR [STATUS]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_POSTDATE]  DEFAULT (getdate()) FOR [POSTDATE]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_REQNO]  DEFAULT ('') FOR [REQNO]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_TRANSREF]  DEFAULT ('') FOR [TRANSREF]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_BATCHREF]  DEFAULT ('') FOR [BATCHREF]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_JOBCARDLEDGERCODE]  DEFAULT ('') FOR [JOBCARDLEDGERCODE]
ALTER TABLE [dbo].[JOBCARDMRD] ADD  CONSTRAINT [DF_JOBCARDMRD_LEDGERCODE]  DEFAULT ('') FOR [LEDGERCODE]