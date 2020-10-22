/****** Object:  Table [dbo].[EMPFINHISTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPFINHISTORY](
	[PAYROLLID] [int] NOT NULL,
	[PRLNUMBER] [nvarchar](10) NOT NULL,
	[PERIODNO] [smallint] NOT NULL,
	[YEARNO] [smallint] NOT NULL,
	[RUNNO] [smallint] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[NETT] [decimal](19, 4) NOT NULL,
	[COST] [decimal](19, 4) NOT NULL,
	[RSCREMUNERATION] [decimal](14, 2) NOT NULL,
	[RSCAMOUNT] [decimal](19, 2) NOT NULL,
	[PREVPAID] [decimal](19, 4) NOT NULL,
	[EMPUIFABLE] [decimal](18, 2) NOT NULL,
	[RATE1] [decimal](19, 4) NOT NULL,
	[RATE2] [decimal](19, 4) NOT NULL,
	[RATE3] [decimal](19, 4) NOT NULL,
	[TRAVELRATE] [decimal](19, 4) NOT NULL,
	[EDSHID] [int] NOT NULL,
	[LDDUETHISPER] [decimal](18, 2) NOT NULL,
	[LDTAKENTHISPER] [decimal](18, 2) NOT NULL,
	[SDTAKENTHISPER] [decimal](18, 2) NOT NULL,
	[SHIFTSTP] [decimal](18, 2) NOT NULL,
	[DAYSINPERIOD] [decimal](18, 4) NOT NULL,
	[TDSAMOUNT] [money] NOT NULL,
	[DEPENDENTS] [int] NOT NULL,
	[TAXCREDITS] [decimal](18, 4) NOT NULL,
	[TOTNTMONEY] [decimal](18, 4) NOT NULL,
	[TOTOT1MONEY] [decimal](18, 4) NOT NULL,
	[TOTOT2MONEY] [decimal](18, 4) NOT NULL,
	[TOTOT3MONEY] [decimal](18, 4) NOT NULL,
	[TOTOT4MONEY] [decimal](18, 4) NOT NULL,
	[TOTOT5MONEY] [decimal](18, 4) NOT NULL,
	[ARREARSPERIODS] [nvarchar](30) NULL,
	[DAYSWORKED] [decimal](18, 4) NULL,
	[TOTALCTC] [decimal](18, 4) NOT NULL,
	[GROSS] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_EMPFINHISTORY] PRIMARY KEY CLUSTERED 
(
	[PRLNUMBER] ASC,
	[PERIODNO] ASC,
	[YEARNO] ASC,
	[RUNNO] ASC,
	[EMPNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_EMPFINHISTORY_PAYROLLID_PERIODNO_YEARNO_RUNNO_EMPNUMBER] ON [dbo].[EMPFINHISTORY]
(
	[PAYROLLID] ASC,
	[PERIODNO] ASC,
	[YEARNO] ASC,
	[RUNNO] ASC,
	[EMPNUMBER] ASC
)
INCLUDE([RSCREMUNERATION],[RSCAMOUNT],[EMPUIFABLE]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_NETT]  DEFAULT (0) FOR [NETT]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_COST]  DEFAULT (0) FOR [COST]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_RSCREMUNERATION]  DEFAULT (0) FOR [RSCREMUNERATION]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_RSCAMOUNT]  DEFAULT (0) FOR [RSCAMOUNT]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_PREVPAID]  DEFAULT (0) FOR [PREVPAID]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_EMPUIFABLE]  DEFAULT (0) FOR [EMPUIFABLE]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_RATE1]  DEFAULT ((0)) FOR [RATE1]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_RATE2]  DEFAULT ((0)) FOR [RATE2]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_RATE3]  DEFAULT ((0)) FOR [RATE3]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_TRAVELRATE]  DEFAULT ((0)) FOR [TRAVELRATE]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_EDSHID]  DEFAULT ((-1)) FOR [EDSHID]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_LDDUETHISPER]  DEFAULT ((0)) FOR [LDDUETHISPER]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_LDTAKENTHISPER]  DEFAULT ((0)) FOR [LDTAKENTHISPER]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_SDTAKENTHISPER]  DEFAULT ((0)) FOR [SDTAKENTHISPER]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_SHIFTSTP]  DEFAULT ((0)) FOR [SHIFTSTP]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_DAYSINPERIOD]  DEFAULT ((1)) FOR [DAYSINPERIOD]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_TDSAMOUNT]  DEFAULT ((0)) FOR [TDSAMOUNT]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_DEPENDENTS]  DEFAULT ((0)) FOR [DEPENDENTS]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  CONSTRAINT [DF_EMPFINHISTORY_TAXCREDITS]  DEFAULT ((0)) FOR [TAXCREDITS]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTNTMONEY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTOT1MONEY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTOT2MONEY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTOT3MONEY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTOT4MONEY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTOT5MONEY]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [TOTALCTC]
ALTER TABLE [dbo].[EMPFINHISTORY] ADD  DEFAULT ((0)) FOR [GROSS]
ALTER TABLE [dbo].[EMPFINHISTORY]  WITH CHECK ADD  CONSTRAINT [FK_EMPFINHISTORY_EMPLOYEES] FOREIGN KEY([PAYROLLID], [EMPNUMBER])
REFERENCES [dbo].[EMPLOYEES] ([PAYROLLID], [EMPNUMBER])
ALTER TABLE [dbo].[EMPFINHISTORY] CHECK CONSTRAINT [FK_EMPFINHISTORY_EMPLOYEES]
ALTER TABLE [dbo].[EMPFINHISTORY]  WITH CHECK ADD  CONSTRAINT [FK_EMPFINHISTORY_PAYROLLS] FOREIGN KEY([PRLNUMBER])
REFERENCES [dbo].[PAYROLLS] ([PRLNUMBER])
ALTER TABLE [dbo].[EMPFINHISTORY] CHECK CONSTRAINT [FK_EMPFINHISTORY_PAYROLLS]