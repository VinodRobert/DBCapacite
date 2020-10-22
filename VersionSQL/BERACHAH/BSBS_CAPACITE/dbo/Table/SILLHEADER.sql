/****** Object:  Table [dbo].[SILLHEADER]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SILLHEADER](
	[SillNumber] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SillColumnName] [char](35) NULL,
	[SillDescription] [char](55) NULL,
 CONSTRAINT [PK_SILLHEADER] PRIMARY KEY CLUSTERED 
(
	[SillNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]