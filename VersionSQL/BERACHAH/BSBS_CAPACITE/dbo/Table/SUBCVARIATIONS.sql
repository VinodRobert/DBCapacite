/****** Object:  Table [dbo].[SUBCVARIATIONS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCVARIATIONS](
	[ReconID] [int] NOT NULL,
	[VarID] [int] IDENTITY(1,1) NOT NULL,
	[VarDate] [datetime] NULL,
	[VarDesc] [nvarchar](55) NOT NULL,
	[VarApp] [bit] NOT NULL,
	[VarNonApp] [bit] NOT NULL,
	[VarInt] [bit] NOT NULL,
	[VarAmount] [money] NOT NULL,
	[VarRef] [char](10) NOT NULL,
	[VarTrade] [int] NOT NULL,
	[VarContract] [int] NOT NULL,
	[VARREJ] [bit] NOT NULL,
	[ReconHistID] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCVARIATIONS] ADD  CONSTRAINT [DF_SUBCVARIATIONS_VarNonApp]  DEFAULT (0) FOR [VarNonApp]
ALTER TABLE [dbo].[SUBCVARIATIONS] ADD  CONSTRAINT [DF_SUBCVARIATIONS_VarTrade]  DEFAULT ((-1)) FOR [VarTrade]
ALTER TABLE [dbo].[SUBCVARIATIONS] ADD  CONSTRAINT [DF_SUBCVARIATIONS_VarContract]  DEFAULT ((-1)) FOR [VarContract]
ALTER TABLE [dbo].[SUBCVARIATIONS] ADD  DEFAULT ((0)) FOR [VARREJ]
ALTER TABLE [dbo].[SUBCVARIATIONS] ADD  CONSTRAINT [DF_SUBCVARIATIONS_ReconHistID]  DEFAULT ((-1)) FOR [ReconHistID]