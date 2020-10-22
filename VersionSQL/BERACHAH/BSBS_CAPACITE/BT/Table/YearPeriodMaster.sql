/****** Object:  Table [BT].[YearPeriodMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[YearPeriodMaster](
	[YearPeriodID] [int] NOT NULL,
	[Year] [int] NULL,
	[CalendarMonth] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[MonthFullName] [varchar](25) NULL,
	[MonthName] [varchar](3) NULL,
	[FinYear] [int] NULL,
	[Period] [int] NULL,
	[PeriodFullName] [varchar](25) NULL,
	[PeriodName] [varchar](10) NULL,
 CONSTRAINT [PK_YearPeriodMaster] PRIMARY KEY CLUSTERED 
(
	[YearPeriodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]