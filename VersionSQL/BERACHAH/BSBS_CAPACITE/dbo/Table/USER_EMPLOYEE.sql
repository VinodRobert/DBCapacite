/****** Object:  Table [dbo].[USER_EMPLOYEE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[USER_EMPLOYEE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[USERID] [int] NOT NULL,
	[EMPID] [int] NOT NULL,
	[DEFCONTRNUM] [nvarchar](15) NOT NULL,
	[DEFACTNUM] [nvarchar](10) NOT NULL,
	[DEFPLANT] [nvarchar](10) NOT NULL,
	[DEFCOSTALLOC] [nvarchar](25) NOT NULL,
	[OT1] [bit] NOT NULL,
	[OT2] [bit] NOT NULL,
	[OT3] [bit] NOT NULL,
	[OT4] [bit] NOT NULL,
	[OT5] [bit] NOT NULL,
	[OT1DESC] [nvarchar](3) NOT NULL,
	[OT2DESC] [nvarchar](3) NOT NULL,
	[OT3DESC] [nvarchar](3) NOT NULL,
	[OT4DESC] [nvarchar](3) NOT NULL,
	[OT5DESC] [nvarchar](3) NOT NULL,
	[ALLOWCLOCKINGEDIT] [bit] NOT NULL,
	[ALLOWSHIFT] [bit] NOT NULL,
	[EditWDRate] [bit] NOT NULL,
	[DEFNTMHOURS] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_USER_EMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_DEFCONTRNUM]  DEFAULT ('') FOR [DEFCONTRNUM]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_DEFACTNUM]  DEFAULT ('') FOR [DEFACTNUM]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_DEFPLANT]  DEFAULT ('') FOR [DEFPLANT]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_DEFCOSTALLOC]  DEFAULT ('') FOR [DEFCOSTALLOC]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT1]  DEFAULT ('0') FOR [OT1]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT2]  DEFAULT ('0') FOR [OT2]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT3]  DEFAULT ('0') FOR [OT3]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT4]  DEFAULT ('0') FOR [OT4]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT5]  DEFAULT ('0') FOR [OT5]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT1DESC]  DEFAULT ('OT1') FOR [OT1DESC]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT2DESC]  DEFAULT ('OT2') FOR [OT2DESC]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT3DESC]  DEFAULT ('OT3') FOR [OT3DESC]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT4DESC]  DEFAULT ('OT4') FOR [OT4DESC]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_OT5DESC]  DEFAULT ('OT5') FOR [OT5DESC]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_ALLOWCLOCKINGEDIT]  DEFAULT ('0') FOR [ALLOWCLOCKINGEDIT]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_ALLOWSHIFT]  DEFAULT ('0') FOR [ALLOWSHIFT]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  CONSTRAINT [DF_USER_EMPLOYEE_EditWDRate]  DEFAULT ((0)) FOR [EditWDRate]
ALTER TABLE [dbo].[USER_EMPLOYEE] ADD  DEFAULT ((0.00)) FOR [DEFNTMHOURS]