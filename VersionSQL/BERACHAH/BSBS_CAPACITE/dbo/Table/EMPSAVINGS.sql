/****** Object:  Table [dbo].[EMPSAVINGS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPSAVINGS](
	[PAYROLLID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[BFBALANCE] [decimal](18, 2) NOT NULL,
	[DEDUAMOUNT] [decimal](18, 2) NOT NULL,
	[SAVINGID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EDSHID] [int] NOT NULL,
	[DESCRIPTION] [nvarchar](75) NOT NULL,
	[EDSID] [int] NOT NULL,
	[REFNO] [nvarchar](20) NOT NULL,
	[DATECREATED] [datetime] NOT NULL,
 CONSTRAINT [PK_EMPSAVINGS] PRIMARY KEY CLUSTERED 
(
	[SAVINGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_EMPSAVINGS_REFNO] UNIQUE NONCLUSTERED 
(
	[REFNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_EMPSAVINGS] ON [dbo].[EMPSAVINGS]
(
	[PAYROLLID] ASC,
	[EMPNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[EMPSAVINGS] ADD  CONSTRAINT [DF_EMPSAVINGS_SAVBALANCE]  DEFAULT (0) FOR [BFBALANCE]
ALTER TABLE [dbo].[EMPSAVINGS] ADD  CONSTRAINT [DF_EMPSAVINGS_DEDUAMOUNT]  DEFAULT (0) FOR [DEDUAMOUNT]
ALTER TABLE [dbo].[EMPSAVINGS] ADD  CONSTRAINT [DF_EMPSAVINGS_DESCRIPTION]  DEFAULT ('') FOR [DESCRIPTION]
ALTER TABLE [dbo].[EMPSAVINGS] ADD  CONSTRAINT [DF_EMPSAVINGS_REFNO]  DEFAULT ('') FOR [REFNO]
ALTER TABLE [dbo].[EMPSAVINGS] ADD  CONSTRAINT [DF_EMPSAVINGS_DATECREATED]  DEFAULT (getdate()) FOR [DATECREATED]
ALTER TABLE [dbo].[EMPSAVINGS]  WITH CHECK ADD  CONSTRAINT [FK_EMPSAVINGS_EDSETS] FOREIGN KEY([EDSID])
REFERENCES [dbo].[EDSETS] ([EDSID])
ALTER TABLE [dbo].[EMPSAVINGS] CHECK CONSTRAINT [FK_EMPSAVINGS_EDSETS]
ALTER TABLE [dbo].[EMPSAVINGS]  WITH CHECK ADD  CONSTRAINT [FK_EMPSAVINGS_EMPLOYEES] FOREIGN KEY([PAYROLLID], [EMPNUMBER])
REFERENCES [dbo].[EMPLOYEES] ([PAYROLLID], [EMPNUMBER])
ALTER TABLE [dbo].[EMPSAVINGS] CHECK CONSTRAINT [FK_EMPSAVINGS_EMPLOYEES]