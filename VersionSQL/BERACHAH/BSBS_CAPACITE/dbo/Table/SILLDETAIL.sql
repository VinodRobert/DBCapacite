/****** Object:  Table [dbo].[SILLDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SILLDETAIL](
	[SillID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SillOrg] [int] NOT NULL,
	[SillNumber] [int] NOT NULL,
	[SillYear] [char](10) NOT NULL,
	[SillPeriod] [int] NOT NULL,
	[SillDate] [datetime] NOT NULL,
	[SillTransRef] [char](10) NOT NULL,
	[SillNotes] [char](255) NOT NULL,
	[SillLedgerCode] [char](10) NOT NULL,
	[SillContract] [char](10) NOT NULL,
	[SillActivity] [char](10) NOT NULL,
	[SillDivision] [int] NULL,
	[SillPlantNo] [char](10) NULL,
	[SillOB] [money] NULL,
	[SillMonth1] [money] NULL,
	[SillMonth2] [money] NULL,
	[SillMonth3] [money] NULL,
	[SillMonth4] [money] NULL,
	[SillMonth5] [money] NULL,
	[SillMonth6] [money] NULL,
	[SillMonth7] [money] NULL,
	[SillMonth8] [money] NULL,
	[SillMonth9] [money] NULL,
	[SillMonth10] [money] NULL,
	[SillMonth11] [money] NULL,
	[SillMonth12] [money] NULL,
	[SillCB] [money] NULL,
	[SillYTD] [money] NULL,
	[SillCTD] [money] NULL,
	[SillLOG] [datetime] NOT NULL,
	[SillUser] [char](25) NULL,
 CONSTRAINT [PK_SILLDETAIL] PRIMARY KEY CLUSTERED 
(
	[SillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillOrg]  DEFAULT ('1') FOR [SillOrg]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillNumber]  DEFAULT ((1)) FOR [SillNumber]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillYear]  DEFAULT ('') FOR [SillYear]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillPeriod]  DEFAULT ((1)) FOR [SillPeriod]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillDate]  DEFAULT (getdate()) FOR [SillDate]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillTransRef]  DEFAULT ('') FOR [SillTransRef]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillNotes]  DEFAULT ('') FOR [SillNotes]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillLedgerCode]  DEFAULT ('') FOR [SillLedgerCode]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillContract]  DEFAULT ('') FOR [SillContract]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillActivity]  DEFAULT ('') FOR [SillActivity]
ALTER TABLE [dbo].[SILLDETAIL] ADD  CONSTRAINT [DF_SILLDETAIL_SillLOG]  DEFAULT (getdate()) FOR [SillLOG]
ALTER TABLE [dbo].[SILLDETAIL]  WITH CHECK ADD  CONSTRAINT [FK_SILLDETAIL_SILLHEADER] FOREIGN KEY([SillNumber])
REFERENCES [dbo].[SILLHEADER] ([SillNumber])
ALTER TABLE [dbo].[SILLDETAIL] CHECK CONSTRAINT [FK_SILLDETAIL_SILLHEADER]