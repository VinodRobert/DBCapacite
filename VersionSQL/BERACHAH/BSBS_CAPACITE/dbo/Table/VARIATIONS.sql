/****** Object:  Table [dbo].[VARIATIONS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VARIATIONS](
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
	[VarTradeNumber] [char](10) NOT NULL,
	[VARREJ] [bit] NOT NULL,
	[ReconHistID] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_ReconID]  DEFAULT ((-1)) FOR [ReconID]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_VarDesc]  DEFAULT ('') FOR [VarDesc]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_VarApp]  DEFAULT (0) FOR [VarApp]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_VarNonApp]  DEFAULT (1) FOR [VarNonApp]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_VarInt]  DEFAULT (0) FOR [VarInt]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_VarAmount]  DEFAULT (0) FOR [VarAmount]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_variations_VarRef]  DEFAULT ('') FOR [VarRef]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_VARIATIONS_VarTrade]  DEFAULT ((-1)) FOR [VarTrade]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_VARIATIONS_VarTradeNumber]  DEFAULT ('') FOR [VarTradeNumber]
ALTER TABLE [dbo].[VARIATIONS] ADD  DEFAULT ((0)) FOR [VARREJ]
ALTER TABLE [dbo].[VARIATIONS] ADD  CONSTRAINT [DF_VARIATIONS_ReconHistID]  DEFAULT ((-1)) FOR [ReconHistID]