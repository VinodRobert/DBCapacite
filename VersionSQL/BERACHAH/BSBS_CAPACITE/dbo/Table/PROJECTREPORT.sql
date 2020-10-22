/****** Object:  Table [dbo].[PROJECTREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PROJECTREPORT](
	[BorgID] [int] NOT NULL,
	[YEAR] [char](4) NOT NULL,
	[Period] [int] NOT NULL,
	[Contract] [int] NOT NULL,
	[Activity] [int] NOT NULL,
	[Ledger] [int] NOT NULL,
	[oEst] [money] NOT NULL,
	[VarApp] [money] NOT NULL,
	[VarUnApp] [money] NOT NULL,
	[oCost] [money] NOT NULL,
	[oCostApp] [money] NOT NULL,
	[oCostUnApp] [money] NOT NULL,
	[oCostInt] [money] NOT NULL,
	[ProvCTC] [money] NOT NULL,
	[CostToDate] [money] NOT NULL,
	[GainLoss] [money] NOT NULL,
	[ProjID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_BorgID]  DEFAULT ((-1)) FOR [BorgID]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_YEAR]  DEFAULT ('') FOR [YEAR]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_Period]  DEFAULT (1) FOR [Period]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_Contract]  DEFAULT ((-1)) FOR [Contract]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_Activity]  DEFAULT ((-1)) FOR [Activity]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_Ledger]  DEFAULT ((-1)) FOR [Ledger]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_oEst]  DEFAULT (0) FOR [oEst]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_VarApp]  DEFAULT (0) FOR [VarApp]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_VarUnApp]  DEFAULT (0) FOR [VarUnApp]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_oCost]  DEFAULT (0) FOR [oCost]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_oCostApp]  DEFAULT (0) FOR [oCostApp]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_oCostUnApp]  DEFAULT (0) FOR [oCostUnApp]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_oCostInt]  DEFAULT (0) FOR [oCostInt]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_ProvCTC]  DEFAULT (0) FOR [ProvCTC]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_CostToDate]  DEFAULT (0) FOR [CostToDate]
ALTER TABLE [dbo].[PROJECTREPORT] ADD  CONSTRAINT [DF_PROJECTREPORT_GainLoss]  DEFAULT (0) FOR [GainLoss]