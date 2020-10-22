/****** Object:  Table [PB].[PAYMENTBATCHTRANSACTIONS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [PB].[PAYMENTBATCHTRANSACTIONS](
	[TRANSID] [int] NOT NULL,
	[DETAILID] [int] NOT NULL,
	[PDATE] [date] NULL,
	[BATCHREF] [varchar](25) NULL,
	[TRANSREF] [varchar](25) NULL,
	[TRANSTYPE] [varchar](15) NULL,
	[ORDERNO] [varchar](35) NULL,
	[DEBIT] [decimal](18, 2) NULL,
	[CREDIT] [decimal](18, 2) NULL,
	[PAIDTODATE] [decimal](18, 2) NULL,
	[PAIDTHISPERIOD] [decimal](18, 2) NULL,
 CONSTRAINT [PK__PAYBATCH__D4B60CAFE2F807BE] PRIMARY KEY CLUSTERED 
(
	[TRANSID] ASC,
	[DETAILID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [PB].[PAYMENTBATCHTRANSACTIONS]  WITH CHECK ADD  CONSTRAINT [FK_PAYMENTBATCHTRANSACTIONS_PAYMENTBATCHDETAIL] FOREIGN KEY([DETAILID])
REFERENCES [PB].[PAYMENTBATCHDETAIL] ([DETAILID])
ALTER TABLE [PB].[PAYMENTBATCHTRANSACTIONS] CHECK CONSTRAINT [FK_PAYMENTBATCHTRANSACTIONS_PAYMENTBATCHDETAIL]