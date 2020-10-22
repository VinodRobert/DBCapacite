/****** Object:  Table [dbo].[CRBatchDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRBatchDetail](
	[DetailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HeaderID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[Rate1] [money] NULL,
	[Rate2] [money] NULL,
	[Rate3] [money] NULL,
	[TRRate] [money] NULL,
	[tpayrollid] [int] NULL,
 CONSTRAINT [PK_CRBatchDetail] PRIMARY KEY CLUSTERED 
(
	[DetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]