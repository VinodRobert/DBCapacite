/****** Object:  Table [dbo].[CANDY_BUDGETS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CANDY_BUDGETS](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TASKCODE] [nvarchar](10) NOT NULL,
	[TASKNAME] [nvarchar](100) NOT NULL,
	[CONTRACT] [nvarchar](20) NOT NULL,
	[UNIT] [nvarchar](15) NULL,
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
	[AppVOActualSelAmt] [money] NOT NULL,
	[UNappVOActualSelAmt] [money] NOT NULL,
	[FILEUPLOADDATE] [datetime] NULL,
 CONSTRAINT [PK_CANDY_BUDGETS] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CANDY_BUDGETS] ADD  CONSTRAINT [DF_CANDY_BUDGETS_SYSDATE]  DEFAULT (getdate()) FOR [SYSDATE]
ALTER TABLE [dbo].[CANDY_BUDGETS] ADD  CONSTRAINT [DF_CANDY_BUDGETS_AppVOActualSelAmt]  DEFAULT ((0)) FOR [AppVOActualSelAmt]
ALTER TABLE [dbo].[CANDY_BUDGETS] ADD  CONSTRAINT [DF_CANDY_BUDGETS_UNappVOActualSelAmt]  DEFAULT ((0)) FOR [UNappVOActualSelAmt]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER TR_CANDY_BUDGETSSNAPSHOT ON CANDY_BUDGETS
AFTER UPDATE
AS 

SET NOCOUNT ON

insert into CANDY_BUDGETSSNAPSHOT (
ID, ActualNetAmt, BillSelAmt, FinalSelAmt, 
ClaimSelAmt, AppVOClaimSelAmt, AppVOClaimNetAmt, UNappVOClaimSelAmt, UNappVOClaimNetAmt, 
AppVOFinalSelAmt, AppVOFinalNetAmt, UNappVOFinalSelAmt, UNappVOFinalNetAmt, FinalNetAmt, 
RemCostAmt, PaidSelAmt, ActualSelAmt, NextMonthSelAmt, UserSelAmt, SYSDATE)
SELECT D.ID, D.ActualNetAmt, D.BillSelAmt, D.FinalSelAmt, 
D.ClaimSelAmt, D.AppVOClaimSelAmt, D.AppVOClaimNetAmt, D.UNappVOClaimSelAmt, D.UNappVOClaimNetAmt, 
D.AppVOFinalSelAmt, D.AppVOFinalNetAmt, D.UNappVOFinalSelAmt, D.UNappVOFinalNetAmt, D.FinalNetAmt, 
D.RemCostAmt, D.PaidSelAmt, D.ActualSelAmt, D.NextMonthSelAmt, D.UserSelAmt, getDate()
FROM INSERTED I inner join DELETED D on I.ID = D.ID
WHERE I.ActualNetAmt <> D.ActualNetAmt
OR I.BillSelAmt <> D.BillSelAmt
OR I.FinalSelAmt <> D.FinalSelAmt
OR I.ClaimSelAmt <> D.ClaimSelAmt
OR I.AppVOClaimSelAmt <> D.AppVOClaimSelAmt
OR I.AppVOClaimNetAmt <> D.AppVOClaimNetAmt
OR I.UNappVOClaimSelAmt <> D.UNappVOClaimSelAmt
OR I.UNappVOClaimNetAmt <> D.UNappVOClaimNetAmt
OR I.AppVOFinalSelAmt <> D.AppVOFinalSelAmt
OR I.AppVOFinalNetAmt <> D.AppVOFinalNetAmt
OR I.UNappVOFinalSelAmt <> D.UNappVOFinalSelAmt
OR I.UNappVOFinalNetAmt <> D.UNappVOFinalNetAmt
OR I.FinalNetAmt <> D.FinalNetAmt
OR I.RemCostAmt <> D.RemCostAmt
OR I.PaidSelAmt <> D.PaidSelAmt
OR I.ActualSelAmt <> D.ActualSelAmt
OR I.NextMonthSelAmt <> D.NextMonthSelAmt
OR I.UserSelAmt <> D.UserSelAmt

		
ALTER TABLE [dbo].[CANDY_BUDGETS] ENABLE TRIGGER [TR_CANDY_BUDGETSSNAPSHOT]