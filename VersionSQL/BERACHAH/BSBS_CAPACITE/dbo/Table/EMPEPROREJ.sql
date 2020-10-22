/****** Object:  Table [dbo].[EMPEPROREJ]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPEPROREJ](
	[PAYROLLID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[EMPNAME] [nvarchar](75) NOT NULL,
	[BIRTHDAY] [datetime] NULL,
	[STARTDATE] [datetime] NULL,
	[RATE1] [money] NOT NULL,
	[REJDATE] [datetime] NOT NULL,
	[COMPANY] [nvarchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPEPROREJ] ADD  CONSTRAINT [DF_EMPEPROREJ_REJDATE]  DEFAULT (getdate()) FOR [REJDATE]