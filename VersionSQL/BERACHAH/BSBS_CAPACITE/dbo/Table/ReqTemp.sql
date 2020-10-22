/****** Object:  Table [dbo].[ReqTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ReqTemp](
	[seq] [int] IDENTITY(1,1) NOT NULL,
	[Orgid] [int] NULL,
	[hirehnumber] [char](10) NOT NULL,
	[penumber] [char](10) NOT NULL,
	[hirernumber] [varchar](10) NULL,
	[hirerfromdate] [datetime] NULL,
	[hirertodate] [datetime] NULL,
	[hirerq1] [decimal](18, 4) NULL,
	[hirerq2] [decimal](18, 4) NULL,
	[hirerq3] [decimal](18, 4) NULL,
	[hirerq4] [decimal](18, 4) NULL,
	[hirerq5] [decimal](18, 4) NULL,
	[actnumber] [char](10) NULL,
	[hirersmrreading] [numeric](18, 4) NOT NULL,
	[hirersmrdate] [datetime] NULL,
	[vattype] [nvarchar](10) NOT NULL,
	[hirerperiod] [int] NULL,
	[hireryear] [int] NULL
) ON [PRIMARY]