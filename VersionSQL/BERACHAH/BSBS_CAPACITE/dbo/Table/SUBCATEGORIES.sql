/****** Object:  Table [dbo].[SUBCATEGORIES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCATEGORIES](
	[CATID] [int] NOT NULL,
	[SUBCATID] [int] IDENTITY(1,1) NOT NULL,
	[SUBCATNAME] [char](55) NOT NULL,
	[SUBCATDESCRIPTION] [char](55) NULL
) ON [PRIMARY]