/****** Object:  Table [dbo].[TRANSACTIONSARC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TRANSACTIONSARC](
	[OrgID] [int] NOT NULL,
	[Year] [char](10) NOT NULL,
	[Period] [int] NOT NULL,
	[PDate] [datetime] NULL,
	[BatchRef] [char](10) NOT NULL,
	[TransRef] [char](10) NOT NULL,
	[MatchRef] [char](10) NOT NULL,
	[TransType] [char](10) NOT NULL,
	[Allocation] [char](25) NULL,
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
	[Store] [char](10) NOT NULL,
	[Plantno] [char](10) NOT NULL,
	[Stockno] [char](20) NOT NULL,
	[Quantity] [numeric](23, 4) NOT NULL,
	[Unit] [char](10) NOT NULL,
	[Rate] [money] NOT NULL,
	[ReqNo] [char](55) NOT NULL,
	[OrderNo] [char](55) NOT NULL,
	[Age] [int] NOT NULL,
	[TransID] [int] NOT NULL,
	[SubConTran] [char](20) NOT NULL,
	[VATType] [char](2) NOT NULL,
	[HomeCurrAmount] [money] NULL,
	[ConversionDate] [datetime] NULL,
	[ConversionRate] [money] NOT NULL,
	[PaidFor] [bit] NOT NULL,
	[PaidToDate] [money] NOT NULL,
	[PaidThisPeriod] [money] NOT NULL,
	[DiscToDate] [money] NOT NULL,
	[DiscThisPeriod] [money] NOT NULL,
	[ReconStatus] [int] NOT NULL,
	[UserID] [char](10) NULL,
	[DivID] [int] NOT NULL,
	[ForexVal] [money] NOT NULL,
	[HeadID] [char](10) NULL,
	[Log] [datetime] NOT NULL
) ON [PRIMARY]