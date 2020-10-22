/****** Object:  Table [dbo].[JobCardDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobCardDetail](
	[JobDDetialId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JobDCardID] [int] NOT NULL,
	[JobDDescription] [char](200) NOT NULL,
	[LedgerCodeDetail] [char](10) NULL,
	[JobDDate] [datetime] NOT NULL,
	[JobDUnit] [char](10) NOT NULL,
	[JobDQuantity] [decimal](18, 4) NOT NULL,
	[JobDRate] [money] NOT NULL,
	[JobDDiscount] [money] NOT NULL,
	[JobDCurrency] [char](10) NOT NULL,
	[JobDVattype] [char](19) NOT NULL,
	[JobDVatamount] [money] NOT NULL,
	[JobDAmount] [money] NOT NULL,
	[JobDTAmount] [money] NOT NULL,
	[JobDActNumber] [char](10) NULL,
	[JobDPosted] [bit] NOT NULL,
	[JTID] [int] NULL,
	[JobDFromWhere] [char](15) NOT NULL,
	[DLVRID] [int] NULL,
	[JobDTechnician] [nvarchar](50) NULL,
	[LCID] [int] NULL,
	[JobDOnHoldQ] [decimal](18, 2) NOT NULL,
	[JobDToPostAmt] [money] NOT NULL,
	[JobDPostedAmt] [money] NOT NULL,
	[DEPTINVOICENUMBER] [char](10) NULL,
	[HISTORYDATESTAMP] [datetime] NULL,
 CONSTRAINT [PK_JobCardDetail] PRIMARY KEY CLUSTERED 
(
	[JobDDetialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF_JobCardDetail_JobDQuantity]  DEFAULT ('0') FOR [JobDQuantity]
ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF__JobCardDe__JobDP__080C0D4A]  DEFAULT ((0)) FOR [JobDPosted]
ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF__JobCardDe__JobDF__1471E42F]  DEFAULT ('Job Card') FOR [JobDFromWhere]
ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF_JobCardDetail_JobDOnHoldQ]  DEFAULT ((0)) FOR [JobDOnHoldQ]
ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF_JobCardDetail_JobDPostQ]  DEFAULT ((0)) FOR [JobDToPostAmt]
ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF_JobCardDetail_JobDPostedAmt]  DEFAULT ((0)) FOR [JobDPostedAmt]
ALTER TABLE [dbo].[JobCardDetail] ADD  CONSTRAINT [DF_JobCardDetail_DEPTINVOICENUMBER]  DEFAULT ('') FOR [DEPTINVOICENUMBER]
ALTER TABLE [dbo].[JobCardDetail]  WITH CHECK ADD  CONSTRAINT [FK_JobCardDetail_ACTIVITIES] FOREIGN KEY([JobDActNumber])
REFERENCES [dbo].[ACTIVITIES] ([ActNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[JobCardDetail] CHECK CONSTRAINT [FK_JobCardDetail_ACTIVITIES]
ALTER TABLE [dbo].[JobCardDetail]  WITH CHECK ADD  CONSTRAINT [FK_JobCardDetail_JobCardHeader] FOREIGN KEY([JobDCardID])
REFERENCES [dbo].[JobCardHeader] ([JobCardID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[JobCardDetail] CHECK CONSTRAINT [FK_JobCardDetail_JobCardHeader]
ALTER TABLE [dbo].[JobCardDetail]  WITH CHECK ADD  CONSTRAINT [FK_JobCardDetail_JobCardTechs] FOREIGN KEY([JTID])
REFERENCES [dbo].[JobCardTechs] ([JTID])
ALTER TABLE [dbo].[JobCardDetail] CHECK CONSTRAINT [FK_JobCardDetail_JobCardTechs]
ALTER TABLE [dbo].[JobCardDetail]  WITH CHECK ADD  CONSTRAINT [FK_JobCardDetail_LEDGERCODES] FOREIGN KEY([LedgerCodeDetail])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ON UPDATE CASCADE
ALTER TABLE [dbo].[JobCardDetail] CHECK CONSTRAINT [FK_JobCardDetail_LEDGERCODES]