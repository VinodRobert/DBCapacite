/****** Object:  Table [dbo].[POLICYSETTINGS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[POLICYSETTINGS](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MINPLEN] [int] NOT NULL,
	[MINPUPC] [int] NOT NULL,
	[MINPNUM] [int] NOT NULL,
	[MINPSPC] [int] NOT NULL,
	[USEPE] [bit] NOT NULL,
	[USEPP] [bit] NOT NULL,
	[MAXPATTEMPTCOUNT] [int] NOT NULL,
	[MAXPATTEMPTWINDOW] [int] NOT NULL,
	[FORCEPCHANGEPERIOD] [int] NOT NULL,
	[DEFAULTLOCKOUTMINUTES] [int] NOT NULL,
	[PASSWORDHISTORYSIZE] [int] NOT NULL,
	[USELOCKOUT] [bit] NOT NULL,
	[USEPASSWORDRESET] [bit] NOT NULL,
 CONSTRAINT [PK_POLICYSETTINGS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_MINPLEN]  DEFAULT ((-1)) FOR [MINPLEN]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_MINPUPC]  DEFAULT ((-1)) FOR [MINPUPC]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_MINPNUM]  DEFAULT ((-1)) FOR [MINPNUM]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_MINPSPC]  DEFAULT ((-1)) FOR [MINPSPC]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_USEPE]  DEFAULT ('0') FOR [USEPE]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_USEPP]  DEFAULT ('0') FOR [USEPP]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_MAXPATTEMPTCOUNT]  DEFAULT ((0)) FOR [MAXPATTEMPTCOUNT]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_MAXPATTEMPTWINDOW]  DEFAULT ((0)) FOR [MAXPATTEMPTWINDOW]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_FORCEPCHANGEPERIOD]  DEFAULT ((0)) FOR [FORCEPCHANGEPERIOD]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_DEFAULTLOCKOUTMINUTES]  DEFAULT ((0)) FOR [DEFAULTLOCKOUTMINUTES]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_PASSWORDHISTORYSIZE]  DEFAULT ((0)) FOR [PASSWORDHISTORYSIZE]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_USELOCKOUT]  DEFAULT (N'0') FOR [USELOCKOUT]
ALTER TABLE [dbo].[POLICYSETTINGS] ADD  CONSTRAINT [DF_POLICYSETTINGS_USEPASSWORDRESET]  DEFAULT (N'0') FOR [USEPASSWORDRESET]