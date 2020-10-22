/****** Object:  Table [dbo].[DEBTRECONRULES190920]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONRULES190920](
	[TEMPLATEID] [int] IDENTITY(1,1) NOT NULL,
	[ACCSPEC] [int] NOT NULL,
	[SEQUENCE] [int] NOT NULL,
	[VARCODE] [nvarchar](20) NOT NULL,
	[PRINTDESC] [nvarchar](50) NOT NULL,
	[EDITDESC] [nvarchar](50) NOT NULL,
	[POSTDESC] [nvarchar](50) NOT NULL,
	[SUBCONTRAN] [nvarchar](50) NOT NULL,
	[PPRINTMASK] [nvarchar](20) NOT NULL,
	[MPRINTMASK] [nvarchar](20) NOT NULL,
	[VPRINTMASK] [nvarchar](20) NOT NULL,
	[PEDITMASK] [nvarchar](20) NOT NULL,
	[MEDITMASK] [nvarchar](20) NOT NULL,
	[VEDITMASK] [nvarchar](20) NOT NULL,
	[ISPRINT] [int] NOT NULL,
	[ISEDIT] [int] NOT NULL,
	[ISPOST] [int] NOT NULL,
	[ISLINE] [int] NOT NULL,
	[ISBREAK] [int] NOT NULL,
	[OVERRIDEALLOC] [nvarchar](1) NOT NULL,
	[DEFAULTALLOC] [nvarchar](10) NOT NULL,
	[CONTROLCODE] [nvarchar](50) NOT NULL,
	[LINK] [nvarchar](50) NOT NULL,
	[LINKCODE] [nvarchar](50) NOT NULL,
	[PFORMULA] [nvarchar](250) NOT NULL,
	[MFORMULA] [nvarchar](250) NOT NULL,
	[VFORMULA] [nvarchar](250) NOT NULL,
	[PERCPRINTMASK] [nvarchar](20) NOT NULL,
	[PERCEDITMASK] [nvarchar](20) NOT NULL,
	[TAXFORMULA] [nvarchar](250) NOT NULL,
	[PERCFORMULA] [nvarchar](250) NOT NULL,
	[ALTCCODE] [nvarchar](50) NOT NULL,
	[TAXCODELINK] [nvarchar](50) NOT NULL,
	[WHTIDLINK] [nvarchar](50) NOT NULL,
	[WHTTHISPLINK] [nvarchar](250) NOT NULL,
	[CODE] [nvarchar](10) NOT NULL,
	[MAPPING] [nvarchar](100) NOT NULL,
	[ACTION] [int] NOT NULL
) ON [PRIMARY]