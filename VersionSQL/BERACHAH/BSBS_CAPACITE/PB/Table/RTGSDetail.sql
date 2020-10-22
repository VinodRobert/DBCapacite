/****** Object:  Table [PB].[RTGSDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [PB].[RTGSDetail](
	[RTGSDetailID] [int] IDENTITY(1,1) NOT NULL,
	[RTGSHeaderID] [int] NULL,
	[BatchDetailID] [int] NULL,
	[BeneficiaryName] [varchar](200) NULL,
	[BeneficiaryAccountNumber] [varchar](50) NULL,
	[IFSCCode] [varchar](15) NULL,
	[BeneficiaryBankName] [varchar](150) NULL,
	[PostingStatus] [int] NULL,
	[PostingDate] [datetime] NULL,
	[PostingReference] [varchar](25) NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[PaymentBankID] [int] NULL,
	[UTRNumber] [varchar](20) NULL,
	[PaymentTableID] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[RTGSDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [PB].[RTGSDetail]  WITH CHECK ADD  CONSTRAINT [FK_RTGSDetail_PAYMENTBATCHDETAIL] FOREIGN KEY([BatchDetailID])
REFERENCES [PB].[PAYMENTBATCHDETAIL] ([DETAILID])
ALTER TABLE [PB].[RTGSDetail] CHECK CONSTRAINT [FK_RTGSDetail_PAYMENTBATCHDETAIL]