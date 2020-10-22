/****** Object:  Table [dbo].[INCOMESTATEMENT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[INCOMESTATEMENT](
	[ISOrgID] [int] NULL,
	[ISDescription] [char](55) NULL,
	[ISType] [char](5) NULL,
	[ISFromGLCode] [char](10) NULL,
	[ISToGLCode] [char](10) NULL,
	[ISID] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]