/****** Object:  Table [BS].[EMPSALARY]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BS].[EMPSALARY](
	[EMPNUMBER] [varchar](10) NOT NULL,
	[YEAR] [int] NOT NULL,
	[MONTH] [int] NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[EMPNAME] [varchar](100) NULL,
	[DESIGNATION] [varchar](100) NULL,
	[JOINDATE] [datetime] NULL,
	[BANKACCNO] [varchar](25) NULL,
	[BANKNAME] [varchar](25) NULL,
	[PFNUMBER] [varchar](25) NULL,
	[ESINUMBER] [varchar](25) NULL,
	[PAYPOINT] [varchar](15) NULL,
	[PAYBY] [varchar](50) NULL,
	[BASIC] [decimal](18, 2) NULL,
	[DA] [decimal](18, 2) NULL,
	[HRA] [decimal](18, 2) NULL,
	[MEDICAL ALLOWANCE] [decimal](18, 2) NULL,
	[SPECIAL ALLOWANCE] [decimal](18, 2) NULL,
	[OTHER ADDITIONS] [decimal](18, 2) NULL,
	[SALARY ARREARS] [decimal](18, 2) NULL,
	[TOTAL EARNINGS] [decimal](18, 2) NULL,
	[PF] [decimal](18, 2) NULL,
	[PROFESSIONAL TAX] [decimal](18, 2) NULL,
	[ESI] [decimal](18, 2) NULL,
	[SALARY ADVANCE] [decimal](18, 2) NULL,
	[LOAN RECOVERY] [decimal](18, 2) NULL,
	[LOSS OF PAY] [decimal](18, 2) NULL,
	[TELEPHONE] [decimal](18, 2) NULL,
	[OTHER DEDUCTIONS] [decimal](18, 2) NULL,
	[INCOME TAX] [decimal](18, 2) NULL,
	[TOTAL DEUDCTIONS] [decimal](18, 2) NULL,
	[NETPAY] [decimal](18, 2) NULL,
	[PAYROLLMONTH] [varchar](25) NULL,
	[PAYPOINTNAME] [varchar](150) NULL,
	[DAYSWORKED] [decimal](18, 2) NULL,
	[PAID DAYS] [decimal](18, 2) NULL,
	[LOP] [decimal](18, 2) NULL,
 CONSTRAINT [PK_EMPSALARY_1] PRIMARY KEY CLUSTERED 
(
	[EMPNUMBER] ASC,
	[YEAR] ASC,
	[MONTH] ASC,
	[PAYROLLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]