/****** Object:  Table [dbo].[STDJNL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STDJNL](
	[StdjID] [int] IDENTITY(1,1) NOT NULL,
	[StdPost] [bit] NOT NULL,
	[BorgID] [int] NOT NULL,
	[JnlBatch] [char](10) NOT NULL,
	[JnlRef] [char](10) NOT NULL,
	[JnlDesc] [char](55) NOT NULL,
	[JnlDebAlloc] [char](25) NOT NULL,
	[JnlCredAlloc] [char](25) NOT NULL,
	[JnlDebGlCode] [char](10) NOT NULL,
	[JnlCredGlCode] [char](10) NOT NULL,
	[JnlDebVat] [char](2) NOT NULL,
	[JnlCredVat] [char](2) NOT NULL,
	[JnlDebAmnt] [money] NOT NULL,
	[JnlCredAmnt] [money] NOT NULL,
	[JnlDebVatAmnt] [money] NOT NULL,
	[JnlCredVatAmnt] [money] NOT NULL,
	[JnlDCont] [char](10) NOT NULL,
	[JnlCCont] [char](10) NOT NULL,
	[JnlDAct] [char](10) NOT NULL,
	[JnlCAct] [char](10) NOT NULL,
	[JnlDPlant] [char](10) NOT NULL,
	[JnlCPlant] [char](10) NOT NULL,
	[JnlDCredno] [char](10) NOT NULL,
	[JnlCCredno] [char](10) NOT NULL,
	[JnlDebDivid] [int] NOT NULL,
	[JnlCredDivid] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_StdPost]  DEFAULT (0) FOR [StdPost]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlBatch]  DEFAULT (' ') FOR [JnlBatch]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlRef]  DEFAULT (' ') FOR [JnlRef]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDesc]  DEFAULT (' ') FOR [JnlDesc]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDebAlloc]  DEFAULT (' ') FOR [JnlDebAlloc]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCredAlloc]  DEFAULT (' ') FOR [JnlCredAlloc]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDebGlCode]  DEFAULT (' ') FOR [JnlDebGlCode]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCredGlCode]  DEFAULT (' ') FOR [JnlCredGlCode]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDebVat]  DEFAULT ('Z') FOR [JnlDebVat]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCredVat]  DEFAULT ('Z') FOR [JnlCredVat]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDebAmnt]  DEFAULT (0) FOR [JnlDebAmnt]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCredAmnt]  DEFAULT (0) FOR [JnlCredAmnt]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDebVatAmnt]  DEFAULT (0) FOR [JnlDebVatAmnt]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCredVatAmnt]  DEFAULT (0) FOR [JnlCredVatAmnt]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDCont]  DEFAULT (' ') FOR [JnlDCont]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCCont]  DEFAULT (' ') FOR [JnlCCont]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDAct]  DEFAULT (' ') FOR [JnlDAct]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCAct]  DEFAULT (' ') FOR [JnlCAct]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDPlant]  DEFAULT (' ') FOR [JnlDPlant]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCPlant]  DEFAULT (' ') FOR [JnlCPlant]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDCredno]  DEFAULT (' ') FOR [JnlDCredno]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCCredno]  DEFAULT (' ') FOR [JnlCCredno]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlDebDivid]  DEFAULT ((-1)) FOR [JnlDebDivid]
ALTER TABLE [dbo].[STDJNL] ADD  CONSTRAINT [DF_STDJNL_JnlCredDivid]  DEFAULT ((-1)) FOR [JnlCredDivid]