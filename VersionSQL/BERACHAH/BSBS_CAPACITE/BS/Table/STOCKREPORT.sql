/****** Object:  Table [BS].[STOCKREPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[STOCKREPORT](
	[INDEXCODE] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ORGID] [int] NULL,
	[STORE] [varchar](25) NULL,
	[STOCKCODE] [varchar](20) NULL,
	[TRANSACTIONDATE] [datetime] NULL,
	[INQTY] [decimal](18, 4) NULL,
	[OUTQTY] [decimal](18, 4) NULL,
	[RATE] [decimal](18, 2) NULL,
	[GRNNO] [varchar](50) NULL,
	[TRANSTYPE] [varchar](15) NULL,
	[UNIT] [varchar](15) NULL,
	[DLVRID] [int] NULL,
	[TRANSID] [int] NULL,
	[REFNO] [varchar](100) NULL,
	[REQNO] [varchar](75) NULL,
	[SUBBIENAME] [varchar](60) NULL,
PRIMARY KEY CLUSTERED 
(
	[INDEXCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]