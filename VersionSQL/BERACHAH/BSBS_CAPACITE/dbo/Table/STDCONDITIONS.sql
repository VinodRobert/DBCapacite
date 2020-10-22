/****** Object:  Table [dbo].[STDCONDITIONS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STDCONDITIONS](
	[SCID] [int] IDENTITY(1,1) NOT NULL,
	[CODE] [nvarchar](50) NOT NULL,
	[DESCRIPTION] [nvarchar](50) NOT NULL,
	[DETAILS] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]