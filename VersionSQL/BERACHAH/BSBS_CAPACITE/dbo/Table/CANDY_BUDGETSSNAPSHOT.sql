/****** Object:  Table [dbo].[CANDY_BUDGETSSNAPSHOT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_BUDGETSSNAPSHOT](
	[CBSID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ID] [int] NOT NULL,
	[ActualNetAmt] [money] NOT NULL,
	[BillSelAmt] [money] NOT NULL,
	[FinalSelAmt] [money] NOT NULL,
	[ClaimSelAmt] [money] NOT NULL,
	[AppVOClaimSelAmt] [money] NOT NULL,
	[AppVOClaimNetAmt] [money] NOT NULL,
	[UNappVOClaimSelAmt] [money] NOT NULL,
	[UNappVOClaimNetAmt] [money] NOT NULL,
	[AppVOFinalSelAmt] [money] NOT NULL,
	[AppVOFinalNetAmt] [money] NOT NULL,
	[UNappVOFinalSelAmt] [money] NOT NULL,
	[UNappVOFinalNetAmt] [money] NOT NULL,
	[FinalNetAmt] [money] NOT NULL,
	[RemCostAmt] [money] NOT NULL,
	[PaidSelAmt] [money] NOT NULL,
	[ActualSelAmt] [money] NOT NULL,
	[NextMonthSelAmt] [money] NOT NULL,
	[UserSelAmt] [money] NOT NULL,
	[SYSDATE] [datetime] NOT NULL,
 CONSTRAINT [PK_CANDY_BUDGETSSNAPSHOT] PRIMARY KEY CLUSTERED 
(
	[CBSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CANDY_BUDGETSSNAPSHOT] ADD  CONSTRAINT [DF_CANDY_BUDGETSSNAPSHOT_SYSDATE]  DEFAULT (getdate()) FOR [SYSDATE]