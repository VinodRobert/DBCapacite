/****** Object:  Table [BT].[OverHeadExpenseMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[OverHeadExpenseMaster](
	[OverheadExpenseMasterID] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseHeadCode] [varchar](10) NULL,
	[ExpenseHead] [varchar](200) NULL,
	[GLCode] [varchar](10) NULL,
	[ExpenseSubHead] [varchar](200) NULL,
 CONSTRAINT [PK__OverHead__7EF70E47042E64C2] PRIMARY KEY CLUSTERED 
(
	[OverheadExpenseMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]