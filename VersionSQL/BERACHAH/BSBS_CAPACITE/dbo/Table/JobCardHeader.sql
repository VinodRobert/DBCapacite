/****** Object:  Table [dbo].[JobCardHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobCardHeader](
	[JobCardID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DivID] [int] NOT NULL,
	[JobCard#] [char](10) NOT NULL,
	[JobDescription] [char](210) NOT NULL,
	[JobAllocation] [char](30) NOT NULL,
	[PeNumber] [char](10) NULL,
	[ContractID] [nvarchar](10) NULL,
	[DivIDTo] [int] NULL,
	[DebtNumber] [char](10) NULL,
	[JobStartDate] [datetime] NOT NULL,
	[JabEndDate] [datetime] NULL,
	[JobPosted] [bit] NULL,
	[JobRemove] [bit] NULL,
	[UserID] [char](10) NOT NULL,
	[BorgID] [int] NOT NULL,
	[LedgerCode] [char](10) NULL,
	[JopPlannedService] [bit] NULL,
	[ServID] [int] NULL,
	[JobMarkup] [numeric](18, 4) NOT NULL,
	[JobSMRunit] [char](10) NULL,
	[JobSMReading] [numeric](18, 1) NULL,
	[JobSMRDate] [datetime] NULL,
	[StoreCode] [char](15) NULL,
	[StkCode] [char](20) NULL,
	[JOBAPPROVER] [int] NULL,
	[JOBAPPDATE] [datetime] NULL,
	[JOBPOSTBY] [int] NULL,
	[JOBPOSTDATE] [datetime] NULL,
	[WSRLEDGERCODE] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_JobCardHeader] PRIMARY KEY CLUSTERED 
(
	[JobCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JobCardHeader_JobPosted_1]  DEFAULT (0) FOR [JobPosted]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JobCardHeader_JobRemove]  DEFAULT (0) FOR [JobRemove]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JobCardHeader_JopPlannedService]  DEFAULT (0) FOR [JopPlannedService]
ALTER TABLE [dbo].[JobCardHeader] ADD  DEFAULT (0) FOR [JobMarkup]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JOBCARDHEADER_JOBAPPROVER]  DEFAULT ((-1)) FOR [JOBAPPROVER]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JOBCARDHEADER_JOBAPPDATE]  DEFAULT (getdate()) FOR [JOBAPPDATE]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JOBCARDHEADER_JOBPOSTBY]  DEFAULT ((-1)) FOR [JOBPOSTBY]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JOBCARDHEADER_JOBPOSTDATE]  DEFAULT (getdate()) FOR [JOBPOSTDATE]
ALTER TABLE [dbo].[JobCardHeader] ADD  CONSTRAINT [DF_JOBCARDHEADER_WSRLEDGERCODE]  DEFAULT ('') FOR [WSRLEDGERCODE]
ALTER TABLE [dbo].[JobCardHeader]  WITH CHECK ADD  CONSTRAINT [FK_JobCardHeader_CONTRACTS] FOREIGN KEY([ContractID])
REFERENCES [dbo].[CONTRACTS] ([CONTRNUMBER])
ON UPDATE CASCADE
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_CONTRACTS]
ALTER TABLE [dbo].[JobCardHeader]  WITH CHECK ADD  CONSTRAINT [FK_JobCardHeader_DEBTORS] FOREIGN KEY([DebtNumber])
REFERENCES [dbo].[DEBTORS] ([DebtNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_DEBTORS]
ALTER TABLE [dbo].[JobCardHeader]  WITH CHECK ADD  CONSTRAINT [FK_JobCardHeader_DIVISIONS] FOREIGN KEY([DivID])
REFERENCES [dbo].[DIVISIONS] ([DivID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_DIVISIONS]
ALTER TABLE [dbo].[JobCardHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_JobCardHeader_DIVISIONS1] FOREIGN KEY([DivIDTo])
REFERENCES [dbo].[DIVISIONS] ([DivID])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_DIVISIONS1]
ALTER TABLE [dbo].[JobCardHeader]  WITH CHECK ADD  CONSTRAINT [FK_JobCardHeader_INVSTORES] FOREIGN KEY([StoreCode])
REFERENCES [dbo].[INVSTORES] ([StoreCode])
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_INVSTORES]
ALTER TABLE [dbo].[JobCardHeader]  WITH CHECK ADD  CONSTRAINT [FK_JobCardHeader_LEDGERCODES] FOREIGN KEY([LedgerCode])
REFERENCES [dbo].[LEDGERCODES] ([LedgerCode])
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_LEDGERCODES]
ALTER TABLE [dbo].[JobCardHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_JobCardHeader_PLANTANDEQ] FOREIGN KEY([PeNumber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ON UPDATE CASCADE
NOT FOR REPLICATION 
ALTER TABLE [dbo].[JobCardHeader] CHECK CONSTRAINT [FK_JobCardHeader_PLANTANDEQ]