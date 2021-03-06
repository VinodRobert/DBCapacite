/****** Object:  Table [dbo].[LOCALES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LOCALES](
	[LOCALEID] [int] NOT NULL,
	[NAME] [nvarchar](10) NOT NULL,
	[LANGCODE] [nvarchar](3) NOT NULL,
	[COUNTRYID] [nvarchar](3) NOT NULL,
	[DESCR] [nvarchar](50) NOT NULL,
	[SHORTDATE] [nvarchar](30) NULL,
	[MEDIUMDATE] [nvarchar](30) NULL,
	[LONGDATE] [nvarchar](30) NULL,
 CONSTRAINT [PK_LOCALES] PRIMARY KEY CLUSTERED 
(
	[LOCALEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]