/****** Object:  Table [dbo].[LDBatchHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LDBatchHeader](
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
	[totLeaveDays] [float] NULL,
	[UseHashEmployees] [bit] NOT NULL,
	[UseHashRecords] [bit] NOT NULL,
	[UseHashLeaveDays] [bit] NOT NULL,
	[WORKFLOWSTATUS] [int] NOT NULL,
 CONSTRAINT [PK_LDBatchHeader] PRIMARY KEY CLUSTERED 
(
	[HeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF_LDBatchHeader_LockHolder]  DEFAULT (0) FOR [LockHolder]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF_LDBatchHeader_LockRequestor]  DEFAULT (0) FOR [LockRequestor]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF_LDBatchHeader_valid]  DEFAULT (0) FOR [valid]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF_LDBatchHeader_posted]  DEFAULT (0) FOR [posted]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF__LDBATCHHE__UseHa__4F400647]  DEFAULT (0) FOR [UseHashEmployees]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF__LDBATCHHE__UseHa__50342A80]  DEFAULT (0) FOR [UseHashRecords]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF__LDBATCHHE__UseHa__51284EB9]  DEFAULT (0) FOR [UseHashLeaveDays]
ALTER TABLE [dbo].[LDBatchHeader] ADD  CONSTRAINT [DF_LDBATCHHEADER_WORKFLOWSTATUS]  DEFAULT ((0)) FOR [WORKFLOWSTATUS]