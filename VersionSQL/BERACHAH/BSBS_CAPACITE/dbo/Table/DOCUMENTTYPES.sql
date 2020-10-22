/****** Object:  Table [dbo].[DOCUMENTTYPES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DOCUMENTTYPES](
	[DTID] [int] IDENTITY(1,1) NOT NULL,
	[DTNAME] [nvarchar](50) NOT NULL,
	[DTACRONYM] [char](10) NOT NULL
) ON [PRIMARY]