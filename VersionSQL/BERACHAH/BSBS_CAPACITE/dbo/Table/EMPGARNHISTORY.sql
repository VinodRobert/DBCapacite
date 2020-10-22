/****** Object:  Table [dbo].[EMPGARNHISTORY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPGARNHISTORY](
	[EMPGARNHISTORYID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AUDITDATE] [datetime] NOT NULL,
	[GARNNAME] [nvarchar](100) NOT NULL,
	[REFNO] [nvarchar](25) NOT NULL,
	[GARNID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](25) NOT NULL,
	[PAYMENT] [decimal](18, 4) NULL,
	[PAYDATE] [datetime] NULL,
	[PERIODNO] [int] NOT NULL,
	[YEARNO] [int] NOT NULL,
	[EDSHID] [int] NOT NULL,
	[AMOUNT] [decimal](18, 4) NULL,
	[DEDUAMOUNT] [decimal](18, 4) NULL,
	[ISACTIVE] [bit] NOT NULL,
	[HANDFEE] [decimal](18, 4) NULL,
	[EDSID] [int] NULL,
	[GARNDATE] [datetime] NULL,
	[EDSNUMBER] [int] NULL,
	[BANKNAME] [nvarchar](50) NULL,
	[BRANCH] [nvarchar](20) NULL,
	[BANKACC] [nvarchar](20) NULL,
 CONSTRAINT [PK_EMPGARNHISTORY] PRIMARY KEY CLUSTERED 
(
	[EMPGARNHISTORYID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]