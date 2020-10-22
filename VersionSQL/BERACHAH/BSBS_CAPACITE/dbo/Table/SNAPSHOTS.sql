/****** Object:  Table [dbo].[SNAPSHOTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SNAPSHOTS](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUser] [nvarchar](50) NOT NULL,
	[SnapshotsDesc] [nvarchar](100) NULL,
	[OrgID] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUser] [nvarchar](50) NULL,
	[ContractNo] [nvarchar](10) NOT NULL,
	[Year] [nchar](10) NOT NULL,
	[Period] [int] NOT NULL,
	[AccrualDate] [datetime] NOT NULL,
	[LockedDate] [datetime] NULL,
	[CostsOnly] [bit] NOT NULL,
	[ExcludeAccruals] [bit] NOT NULL,
	[CandyImportDate] [datetime] NOT NULL,
	[StandardJnlHeadID] [int] NULL,
	[AccrualJnlHeadID] [int] NULL,
	[FILEUPLOADDATE] [datetime] NULL,
 CONSTRAINT [PK_SNAPSHOTS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SNAPSHOTS] ADD  CONSTRAINT [DF_SNAPSHOTS_IsDeleted]  DEFAULT (N'0') FOR [IsDeleted]
ALTER TABLE [dbo].[SNAPSHOTS] ADD  CONSTRAINT [DF_SNAPSHOTS_Year]  DEFAULT (N'1999') FOR [Year]
ALTER TABLE [dbo].[SNAPSHOTS] ADD  CONSTRAINT [DF_SNAPSHOTS_Period]  DEFAULT ((0)) FOR [Period]
ALTER TABLE [dbo].[SNAPSHOTS] ADD  CONSTRAINT [DF_SNAPSHOTS_CostsOnly]  DEFAULT (N'0') FOR [CostsOnly]
ALTER TABLE [dbo].[SNAPSHOTS] ADD  CONSTRAINT [DF_SNAPSHOTS_ExcludeAccruals]  DEFAULT (N'0') FOR [ExcludeAccruals]
ALTER TABLE [dbo].[SNAPSHOTS] ADD  CONSTRAINT [DF_SNAPSHOTS_CandyImportDate]  DEFAULT (getdate()) FOR [CandyImportDate]