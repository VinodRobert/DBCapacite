/****** Object:  Table [dbo].[VRFINACC2601]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VRFINACC2601](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SUPPLIERID] [varchar](10) NULL,
	[SUPPLIERNAME] [varchar](55) NULL,
	[ORGID] [int] NULL,
	[ORGNAME] [varchar](75) NULL,
	[TRANSTYPE] [varchar](3) NULL,
	[INVOICENUMBER] [varchar](10) NULL,
	[INVOICEDATE] [datetime] NULL,
	[INVOICEAMOUNT] [money] NULL,
	[AGEINDAYS] [int] NULL,
	[BUCKET0] [money] NULL,
	[BUCKET1] [money] NULL,
	[BUCKET2] [money] NULL,
	[BUCKET3] [money] NULL,
	[BUCKET4] [money] NULL,
	[BUCKET5] [money] NULL,
	[BUCKET6] [money] NULL,
	[BUCKET7] [money] NULL,
	[UNMATCHED] [money] NULL,
	[NARRATION] [varchar](50) NULL
) ON [PRIMARY]