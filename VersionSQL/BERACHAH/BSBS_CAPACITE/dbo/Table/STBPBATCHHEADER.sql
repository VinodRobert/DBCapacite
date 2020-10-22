/****** Object:  Table [dbo].[STBPBATCHHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STBPBATCHHEADER](
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
	[totSTBP] [float] NULL,
	[UseHashEmployees] [bit] NOT NULL,
	[UseHashRecords] [bit] NOT NULL,
	[UseHashSTBP] [bit] NOT NULL,
 CONSTRAINT [PK_STBPBATCHHEADER] PRIMARY KEY CLUSTERED 
(
	[HeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF_STBPBATCHHEADER_LockHolder]  DEFAULT ((0)) FOR [LockHolder]
ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF_STBPBATCHHEADER_LockRequestor]  DEFAULT ((0)) FOR [LockRequestor]
ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF_STBPBATCHHEADER_valid]  DEFAULT ((0)) FOR [valid]
ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF_STBPBATCHHEADER_posted]  DEFAULT ((0)) FOR [posted]
ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF__STBPBATCHHEADER__4F400647]  DEFAULT ((0)) FOR [UseHashEmployees]
ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF__STBPBATCHHE__UseHa__50342A80]  DEFAULT ((0)) FOR [UseHashRecords]
ALTER TABLE [dbo].[STBPBATCHHEADER] ADD  CONSTRAINT [DF__STBPBATCHHE__UseHa__51284EB9]  DEFAULT ((0)) FOR [UseHashSTBP]