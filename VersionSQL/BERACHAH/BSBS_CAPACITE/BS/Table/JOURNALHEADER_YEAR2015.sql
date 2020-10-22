/****** Object:  Table [BS].[JOURNALHEADER_YEAR2015]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[JOURNALHEADER_YEAR2015](
	[JnlHeadBatch] [char](10) NOT NULL,
	[JnlHeadTransRef] [char](10) NOT NULL,
	[JnlHeadDate] [datetime] NULL,
	[JnlHeadCurrency] [char](3) NOT NULL,
	[JnlHeadID] [int] IDENTITY(1,1) NOT NULL,
	[JnlHeadDescription] [char](55) NOT NULL,
	[JnlHeadPosted] [bit] NOT NULL,
	[JnlUserID] [int] NOT NULL,
	[BorgID] [int] NOT NULL,
	[JnlHeadSubmit] [int] NOT NULL,
	[JnlHeadApproved] [int] NOT NULL,
	[JnlHeadRejected] [int] NOT NULL,
	[JnlUserName] [char](55) NOT NULL,
	[JnlPeriod] [int] NOT NULL,
	[JnlHeadExchRate] [float] NOT NULL,
	[JnlIsAutoIC] [bit] NOT NULL,
	[jnlInProgress] [bit] NOT NULL,
	[LOCKHOLDER] [int] NOT NULL,
	[BATCHMODE] [bit] NOT NULL,
	[JNLAPPROVER] [int] NULL,
	[JNLAPPDATE] [datetime] NULL,
	[JNLPOSTBY] [int] NULL,
	[JNLPOSTDATE] [datetime] NULL,
	[ARCHIVE] [bit] NOT NULL,
	[JNLYEAR] [nvarchar](4) NOT NULL,
	[ISACC] [bit] NOT NULL,
	[ISFASSET] [bit] NOT NULL,
	[ASSETTYPEDEF] [nvarchar](3) NOT NULL,
	[LOGUSERID] [int] NOT NULL,
	[LOGDATETIME] [datetime] NOT NULL,
	[JNLTYPE] [nvarchar](5) NOT NULL,
	[WFVALUEAPPROVED] [bit] NOT NULL,
	[PARKPOSTTYPENAME] [nvarchar](25) NOT NULL
) ON [PRIMARY]