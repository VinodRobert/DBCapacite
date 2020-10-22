/****** Object:  Table [dbo].[SUBCRECONS_ARCHIEVE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCRECONS_ARCHIEVE](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[NOWTIME] [datetime] NULL,
	[TRANGRP] [bigint] NULL,
	[OrgID] [int] NULL,
	[SubConNumber] [varchar](10) NULL,
	[Contract] [varchar](10) NULL,
	[Activity] [varchar](10) NULL,
	[ValNo] [numeric](18, 0) NULL,
	[CertNo] [numeric](18, 0) NULL,
	[ContValue] [money] NULL,
	[WorkDoneThisMonth] [money] NULL,
	[AdditionalThisMonth] [money] NULL,
	[VATThisMonth] [money] NULL,
	[AdvanceThisMonth] [money] NULL,
	[RetentionThisMonth] [money] NULL,
	[ContraThisMonth] [money] NULL,
	[WithholdThisMonth] [money] NULL,
	[WithholdPerc] [decimal](18, 3) NULL,
	[AmountDue] [money] NULL,
	[VATPerc] [decimal](18, 4) NULL,
	[VATAmount] [money] NULL,
	[Code] [char](10) NULL,
	[Posted] [bit] NULL,
	[VATno] [char](10) NULL,
	[Remark] [char](200) NULL,
	[GLCode] [char](10) NULL,
	[ReconID] [int] NULL,
	[RetPerc] [decimal](18, 4) NULL,
	[PostDate] [datetime] NULL,
	[PostRef] [char](55) NULL,
	[VatType] [nvarchar](100) NULL,
	[WithholdID] [int] NULL,
	[CERTNOA] [nvarchar](10) NULL,
	[FROMDATE] [datetime] NULL,
	[OVERRIDETAX] [int] NULL,
	[OVERRIDEWHT] [int] NULL,
	[SELFINVOICE] [int] NULL,
	[PACKAGE] [varchar](30) NULL,
	[PROVID2] [bit] NULL,
	[LINKVAR] [bit] NULL,
	[LINKESC] [bit] NULL,
	[LINKMOS] [bit] NULL,
	[LINKCONTRA] [bit] NULL,
	[RETRELEASEDATE] [datetime] NULL,
	[LINKBILL] [bit] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [WorkDoneThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [AdditionalThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [VATThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [AdvanceThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [RetentionThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [ContraThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [WithholdThisMonth]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [WithholdPerc]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [AmountDue]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [VATPerc]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((0)) FOR [Posted]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ((10)) FOR [RetPerc]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ('') FOR [VatType]
ALTER TABLE [dbo].[SUBCRECONS_ARCHIEVE] ADD  DEFAULT ('') FOR [CERTNOA]