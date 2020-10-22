/****** Object:  Table [dbo].[ATTACHMENTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ATTACHMENTS](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FILEID] [int] NOT NULL,
	[FILENAME] [nvarchar](100) NOT NULL,
	[FILESIZE] [decimal](18, 2) NOT NULL,
	[FILEDESCRIPTION] [nvarchar](250) NULL,
	[FILECATEGORY] [nvarchar](50) NULL,
	[CREATEDDATE] [datetime] NOT NULL,
	[CREATEDUSER] [nvarchar](100) NOT NULL,
	[REFTABLE] [nvarchar](100) NOT NULL,
	[REFKEY] [nvarchar](500) NOT NULL,
	[ISDELETED] [bit] NOT NULL,
	[DELETEDUSER] [nvarchar](100) NULL,
	[DELETEDDATE] [datetime] NULL,
 CONSTRAINT [PK_ATTACHMENTS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ATTACHMENTS] ADD  CONSTRAINT [DF_ATTACHMENTS_CREATEDDATE]  DEFAULT (getdate()) FOR [CREATEDDATE]
ALTER TABLE [dbo].[ATTACHMENTS] ADD  CONSTRAINT [DF_ATTACHMENTS_ISDELETED]  DEFAULT ('0') FOR [ISDELETED]