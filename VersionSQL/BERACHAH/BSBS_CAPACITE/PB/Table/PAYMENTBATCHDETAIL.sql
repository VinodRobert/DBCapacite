/****** Object:  Table [PB].[PAYMENTBATCHDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [PB].[PAYMENTBATCHDETAIL](
	[DETAILID] [int] IDENTITY(1,1) NOT NULL,
	[BATCHID] [int] NULL,
	[BATCHOWNER] [varchar](15) NULL,
	[CURRENTOWNER] [varchar](25) NULL,
	[APPROVALLEVELID] [int] NULL,
	[PARTYCODE] [varchar](25) NULL,
	[PARTYNAME] [varchar](150) NULL,
	[BATCHOUTSTANDING] [decimal](18, 2) NULL,
	[AMOUNTINWORDS] [varchar](350) NULL,
	[NARRATION] [varchar](50) NULL,
	[CILOUTSTANDING] [decimal](18, 2) NULL,
	[PROJECTOUTSTANDING] [decimal](18, 2) NULL,
	[GSTOUTSTANDING] [decimal](18, 2) NULL,
	[BANKID] [int] NULL,
	[SUBMITTEDBY] [varchar](15) NULL,
	[SUBMISSIONTIME] [datetime] NULL,
 CONSTRAINT [PK__PAYBATCH__0E176F9A36AE997C] PRIMARY KEY CLUSTERED 
(
	[DETAILID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [PB].[PAYMENTBATCHDETAIL]  WITH CHECK ADD  CONSTRAINT [FK_DETAIL_BANKID] FOREIGN KEY([BANKID])
REFERENCES [PB].[PAYMENTBANKS] ([BANKID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [PB].[PAYMENTBATCHDETAIL] CHECK CONSTRAINT [FK_DETAIL_BANKID]
ALTER TABLE [PB].[PAYMENTBATCHDETAIL]  WITH CHECK ADD  CONSTRAINT [FK_DETAIL_BATCHID] FOREIGN KEY([BATCHID])
REFERENCES [PB].[PAYMENTBATCHHEADER] ([BATCHID])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [PB].[PAYMENTBATCHDETAIL] CHECK CONSTRAINT [FK_DETAIL_BATCHID]