/****** Object:  Table [dbo].[CREDITORSRECON]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CREDITORSRECON](
	[CRecID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ORGID] [int] NOT NULL,
	[Year] [nchar](4) NOT NULL,
	[Period] [int] NOT NULL,
	[Pdate] [datetime] NOT NULL,
	[Transref] [char](10) NOT NULL,
	[Description] [char](255) NOT NULL,
	[Currency] [nvarchar](3) NOT NULL,
	[Amount] [money] NOT NULL,
	[Credno] [char](10) NOT NULL,
	[Age] [int] NOT NULL,
	[TransID] [int] NOT NULL,
	[HomeCurrAmount] [money] NOT NULL,
	[ConversionRate] [money] NOT NULL,
	[ReconStatus] [int] NOT NULL,
	[StatBal] [money] NOT NULL,
	[OnStat] [bit] NOT NULL,
	[StatementDate] [datetime] NULL,
	[ReconGroup] [nvarchar](50) NULL,
	[Comment] [nvarchar](250) NULL,
	[MatchRef] [char](10) NULL,
	[PaidThisPeriod] [money] NULL,
	[PaidToDate] [money] NULL,
	[TransType] [char](10) NULL,
	[COMMENTSOP] [nvarchar](250) NOT NULL,
	[AMOUNTTOPAYSOP] [money] NULL,
	[PAIDTODATESOP] [money] NULL,
 CONSTRAINT [PK_CREDITORSRECON] PRIMARY KEY CLUSTERED 
(
	[CRecID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_ORGID]  DEFAULT ('-1') FOR [ORGID]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Year]  DEFAULT ('') FOR [Year]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Period]  DEFAULT ('-1') FOR [Period]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Pdate]  DEFAULT (getdate()) FOR [Pdate]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Transref]  DEFAULT ('') FOR [Transref]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Description]  DEFAULT ('') FOR [Description]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Currency]  DEFAULT ('') FOR [Currency]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Amount]  DEFAULT ((0)) FOR [Amount]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Credno]  DEFAULT ('') FOR [Credno]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_Age]  DEFAULT ('-1') FOR [Age]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_TransID]  DEFAULT ('-1') FOR [TransID]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_HomeCurrAmount]  DEFAULT ((0)) FOR [HomeCurrAmount]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_ConversionRate]  DEFAULT ((0)) FOR [ConversionRate]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_ReconStatus]  DEFAULT ('-1') FOR [ReconStatus]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_StatBal]  DEFAULT ((0)) FOR [StatBal]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_OnStat]  DEFAULT ('0') FOR [OnStat]
ALTER TABLE [dbo].[CREDITORSRECON] ADD  CONSTRAINT [DF_CREDITORSRECON_COMMENTSOP]  DEFAULT ('') FOR [COMMENTSOP]