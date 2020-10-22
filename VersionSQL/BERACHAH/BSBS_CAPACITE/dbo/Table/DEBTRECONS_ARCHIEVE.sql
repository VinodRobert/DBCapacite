/****** Object:  Table [dbo].[DEBTRECONS_ARCHIEVE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONS_ARCHIEVE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NOWTIME] [datetime] NULL,
	[TRANGRP] [int] NULL,
	[OrgID] [int] NOT NULL,
	[SubConNumber] [char](10) NULL,
	[Contract] [int] NULL,
	[Activity] [int] NULL,
	[ValNo] [numeric](18, 0) NULL,
	[Certno] [numeric](18, 0) NULL,
	[ContValue] [money] NULL,
	[WorkDoneThisMonth] [money] NULL,
	[AdvanceThisMonth] [money] NULL,
	[AdditionalThisMonth] [money] NULL,
	[VATThisMonth] [money] NULL,
	[RetentionThisMonth] [money] NULL,
	[ContraThisMonth] [money] NULL,
	[WithholdThisMonth] [money] NULL,
	[WithholdPerc] [numeric](18, 3) NULL,
	[AmountDue] [money] NULL,
	[TotDue] [money] NULL,
	[VATPerc] [decimal](18, 4) NOT NULL,
	[VATAmount] [money] NULL,
	[Paid] [money] NULL,
	[Code] [char](10) NULL,
	[Credno] [char](10) NULL,
	[Posted] [bit] NOT NULL,
	[VATno] [char](10) NULL,
	[Remark] [char](200) NULL,
	[GLCode] [char](10) NULL,
	[ReconID] [int] NOT NULL,
	[PostDate] [datetime] NULL,
	[PostRef] [char](10) NULL,
	[Orderno] [nvarchar](35) NULL,
	[VALDONETOT] [money] NULL,
	[VALDONEPREV] [money] NULL,
	[VALDONETHISMONTH] [money] NULL,
	[RETPERC] [decimal](18, 4) NULL,
	[VatType] [nvarchar](100) NULL,
	[WithholdID] [int] NULL,
	[CERTNOPREV] [numeric](18, 0) NULL,
	[FROMDATE] [datetime] NULL,
	[LEDGER] [char](10) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [AdvanceThisMonth]
ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [Posted]
ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [VALDONETOT]
ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [VALDONEPREV]
ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [VALDONETHISMONTH]
ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [RETPERC]
ALTER TABLE [dbo].[DEBTRECONS_ARCHIEVE] ADD  DEFAULT ('') FOR [VatType]