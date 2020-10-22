/****** Object:  Table [dbo].[EMAILTOSMS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMAILTOSMS](
	[FROM] [nvarchar](100) NOT NULL,
	[TO] [nvarchar](100) NOT NULL,
	[SUBJECT] [nvarchar](100) NOT NULL
) ON [PRIMARY]