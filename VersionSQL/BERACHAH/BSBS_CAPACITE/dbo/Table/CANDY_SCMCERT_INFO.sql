/****** Object:  Table [dbo].[CANDY_SCMCERT_INFO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_SCMCERT_INFO](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UploadListID] [int] NOT NULL,
	[INFOPARAM] [nvarchar](50) NOT NULL,
	[INFOVALUE] [nvarchar](100) NULL,
 CONSTRAINT [PK_CANDY_SCMCERT_INFO] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CANDY_SCMCERT_INFO]  WITH CHECK ADD  CONSTRAINT [FK_CANDY_SCMCERT_INFO_CANDY_UPLOADLIST] FOREIGN KEY([UploadListID])
REFERENCES [dbo].[CANDY_UPLOADLIST] ([ID])
ALTER TABLE [dbo].[CANDY_SCMCERT_INFO] CHECK CONSTRAINT [FK_CANDY_SCMCERT_INFO_CANDY_UPLOADLIST]