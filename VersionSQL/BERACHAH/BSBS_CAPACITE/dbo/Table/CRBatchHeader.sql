/****** Object:  Table [dbo].[CRBatchHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRBatchHeader](
	[HeaderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Ref] [char](50) NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[PERIODNO] [int] NOT NULL,
	[RUNNO] [int] NOT NULL,
	[YEARNO] [int] NOT NULL,
	[LockHolder] [int] NOT NULL,
	[LockRequestor] [int] NOT NULL,
	[valid] [bit] NOT NULL,
	[posted] [bit] NOT NULL,
	[totRecords] [float] NULL,
	[UseHashRecords] [bit] NOT NULL,
 CONSTRAINT [PK_CRBatchHeader] PRIMARY KEY CLUSTERED 
(
	[HeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRBatchHeader] ADD  CONSTRAINT [DF_CRBatchHeader_LockHolder_1]  DEFAULT (0) FOR [LockHolder]
ALTER TABLE [dbo].[CRBatchHeader] ADD  CONSTRAINT [DF_CRBatchHeader_LockRequestor_1]  DEFAULT (0) FOR [LockRequestor]
ALTER TABLE [dbo].[CRBatchHeader] ADD  CONSTRAINT [DF_CRBatchHeader_valid]  DEFAULT (0) FOR [valid]
ALTER TABLE [dbo].[CRBatchHeader] ADD  CONSTRAINT [DF_CRBatchHeader_posted]  DEFAULT (0) FOR [posted]
ALTER TABLE [dbo].[CRBatchHeader] ADD  CONSTRAINT [DF__CRBATCHHE__UseHa__4B6F7563]  DEFAULT (0) FOR [UseHashRecords]