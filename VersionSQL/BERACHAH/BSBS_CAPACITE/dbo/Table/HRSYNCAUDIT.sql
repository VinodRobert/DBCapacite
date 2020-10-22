/****** Object:  Table [dbo].[HRSYNCAUDIT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HRSYNCAUDIT](
	[ACTIONDATE] [datetime] NOT NULL,
	[LINKID] [int] NOT NULL,
	[ACTIONTYPE] [tinyint] NOT NULL,
	[BSEMPID] [nvarchar](500) NULL,
	[EMPLOYEENUMBER] [varchar](16) NOT NULL,
	[EMPLOYEEIDNUMBER] [varchar](32) NOT NULL,
	[EMPLOYEEPASSPORT] [varchar](16) NOT NULL,
	[EFFECTIVEDATE] [varchar](10) NOT NULL,
	[REASON] [varchar](50) NOT NULL,
	[REEMPLOYABLE] [bit] NOT NULL,
	[TRANSFERTOLINKID] [int] NOT NULL,
	[PREVEMPNUMBER] [varchar](16) NULL,
	[PAYROLLID] [int] NULL
) ON [PRIMARY]