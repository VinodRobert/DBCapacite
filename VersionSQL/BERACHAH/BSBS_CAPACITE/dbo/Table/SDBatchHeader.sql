/****** Object:  Table [dbo].[SDBatchHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SDBatchHeader](
	[HeaderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SiteRef] [char](50) NOT NULL,
	[BatchRef] [char](50) NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[LockHolder] [int] NOT NULL,
	[LockRequestor] [int] NOT NULL,
	[valid] [bit] NOT NULL,
	[posted] [bit] NOT NULL,
	[totEmployees] [float] NULL,
	[totRecords] [float] NULL,
	[totSickDays] [float] NULL,
	[UseHashEmployees] [bit] NOT NULL,
	[UseHashRecords] [bit] NOT NULL,
	[UseHashSickDays] [bit] NOT NULL,
	[WORKFLOWSTATUS] [int] NOT NULL,
 CONSTRAINT [PK_SDBatchHeader] PRIMARY KEY CLUSTERED 
(
	[HeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF_SDBatchHeader_LockHolder]  DEFAULT (0) FOR [LockHolder]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF_SDBatchHeader_LockRequestor]  DEFAULT (0) FOR [LockRequestor]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF_SDBatchHeader_valid]  DEFAULT (0) FOR [valid]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF_SDBatchHeader_posted]  DEFAULT (0) FOR [posted]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF__SDBATCHHE__UseHa__4C63999C]  DEFAULT (0) FOR [UseHashEmployees]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF__SDBATCHHE__UseHa__4D57BDD5]  DEFAULT (0) FOR [UseHashRecords]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF__SDBATCHHE__UseHa__4E4BE20E]  DEFAULT (0) FOR [UseHashSickDays]
ALTER TABLE [dbo].[SDBatchHeader] ADD  CONSTRAINT [DF_SDBATCHHEADER_WORKFLOWSTATUS]  DEFAULT ((0)) FOR [WORKFLOWSTATUS]