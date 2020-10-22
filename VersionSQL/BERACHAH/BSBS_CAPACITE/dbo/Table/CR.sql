/****** Object:  Table [dbo].[CR]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CR](
	[SLNO] [int] NULL,
	[OrgID] [int] NOT NULL,
	[Year] [char](10) NOT NULL,
	[PDate] [datetime] NULL,
	[TransRef] [char](10) NOT NULL,
	[LedgerCode] [char](10) NOT NULL,
	[Description] [char](255) NOT NULL,
	[Debit] [money] NOT NULL,
	[Credit] [money] NOT NULL,
	[Credno] [char](10) NOT NULL,
	[TransID] [int] NOT NULL,
	[PaidFor] [bit] NOT NULL,
	[PaidToDate] [money] NOT NULL,
	[PaidThisPeriod] [money] NOT NULL,
	[WhtThisPeriod] [money] NOT NULL,
	[DiscThisPeriod] [money] NOT NULL,
	[ReconStatus] [int] NOT NULL,
	[CredNumber] [char](10) NOT NULL,
	[CredName] [char](55) NULL,
	[CredAddress1] [char](55) NULL,
	[CredAddress2] [char](55) NULL,
	[CredAddress3] [char](55) NULL,
	[CredPcode] [char](20) NULL,
	[CredContact] [char](55) NULL,
	[CURRID] [int] NULL,
	[DECIMALS] [int] NULL
) ON [PRIMARY]