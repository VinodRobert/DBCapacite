/****** Object:  Table [dbo].[ASSETPOSTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ASSETPOSTS](
	[OrgID] [int] NOT NULL,
	[Year] [char](10) NOT NULL,
	[Period] [int] NOT NULL,
	[PDate] [datetime] NULL,
	[BatchRef] [char](10) NOT NULL,
	[TransRef] [char](10) NOT NULL,
	[MatchRef] [char](10) NOT NULL,
	[TransType] [char](10) NOT NULL,
	[Allocation] [char](25) NOT NULL,
	[LedgerCode] [char](10) NOT NULL,
	[Contract] [nvarchar](10) NOT NULL,
	[Activity] [char](10) NOT NULL,
	[Description] [char](255) NOT NULL,
	[ForeignDescription] [char](255) NOT NULL,
	[Currency] [nvarchar](3) NOT NULL,
	[Debit] [money] NOT NULL,
	[Credit] [money] NOT NULL,
	[VatDebit] [money] NOT NULL,
	[VatCredit] [money] NOT NULL,
	[Credno] [char](10) NOT NULL,
	[Store] [char](20) NOT NULL,
	[Plantno] [char](30) NULL,
	[Stockno] [char](20) NOT NULL,
	[Quantity] [numeric](23, 4) NOT NULL,
	[Unit] [char](10) NOT NULL,
	[Rate] [money] NOT NULL,
	[ReqNo] [char](55) NOT NULL,
	[OrderNo] [char](55) NOT NULL,
	[Age] [int] NOT NULL,
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[SubConTran] [char](20) NOT NULL,
	[VATType] [char](2) NOT NULL,
	[HomeCurrAmount] [money] NULL,
	[ConversionDate] [datetime] NULL,
	[ConversionRate] [money] NOT NULL,
	[PaidFor] [bit] NOT NULL,
	[PaidToDate] [money] NOT NULL,
	[PaidThisPeriod] [money] NOT NULL,
	[WhtThisPeriod] [money] NOT NULL,
	[DiscThisPeriod] [money] NOT NULL,
	[ReconStatus] [int] NOT NULL,
	[UserID] [char](10) NULL,
	[DivID] [int] NOT NULL,
	[ForexVal] [money] NOT NULL,
	[HeadID] [char](10) NULL,
	[XGLCODE] [char](10) NOT NULL,
	[XVATA] [money] NOT NULL,
	[XVATT] [char](2) NOT NULL,
	[DOCNUMBER] [nchar](50) NULL,
	[WHTID] [int] NULL,
	[FBID] [int] NULL,
	[TERM] [int] NULL,
	[SYSDATE] [datetime] NULL,
	[RECEIVEDDATE] [datetime] NULL,
	[ORIGTRANSID] [int] NULL,
	[HCTODATE] [numeric](18, 4) NULL,
	[TRANGRP] [int] NULL,
	[ROLLEDFWD] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [OrgID]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('2000') FOR [Year]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((1)) FOR [Period]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [BatchRef]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [TransRef]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [MatchRef]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [TransType]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('Balance Sheet') FOR [Allocation]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((9999)) FOR [LedgerCode]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Contract]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Activity]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Description]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('') FOR [ForeignDescription]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('ZAR') FOR [Currency]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0.00)) FOR [Debit]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0.00)) FOR [Credit]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0.00)) FOR [VatDebit]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0.00)) FOR [VatCredit]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Credno]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('') FOR [Store]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Plantno]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Stockno]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [Quantity]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [Unit]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [Rate]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [ReqNo]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [OrderNo]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [Age]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (' ') FOR [SubConTran]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('Z') FOR [VATType]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [HomeCurrAmount]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((1)) FOR [ConversionRate]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [PaidFor]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [PaidToDate]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [PaidThisPeriod]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [WhtThisPeriod]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [DiscThisPeriod]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [ReconStatus]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('Admin') FOR [UserID]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((3)) FOR [DivID]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [ForexVal]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('') FOR [XGLCODE]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0.00)) FOR [XVATA]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ('Z') FOR [XVATT]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((-1)) FOR [WHTID]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((-1)) FOR [FBID]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT ((0)) FOR [TERM]
ALTER TABLE [dbo].[ASSETPOSTS] ADD  DEFAULT (getdate()) FOR [SYSDATE]