/****** Object:  Table [PB].[RTGSHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [PB].[RTGSHeader](
	[RTGSID] [int] NOT NULL,
	[BORGID] [int] NULL,
	[LoginID] [varchar](15) NULL,
	[BankID] [int] NULL,
	[RTGSDate] [datetime] NULL,
	[RTGSNumber] [varchar](55) NULL,
	[RTGSStatus] [int] NULL,
	[BatchTotalAmount] [decimal](18, 2) NULL,
	[BatchTotalAmountInWords] [varchar](300) NULL,
 CONSTRAINT [PK_RTGSHeader] PRIMARY KEY CLUSTERED 
(
	[RTGSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]