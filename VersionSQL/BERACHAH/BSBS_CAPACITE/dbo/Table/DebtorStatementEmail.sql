/****** Object:  Table [dbo].[DebtorStatementEmail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DebtorStatementEmail](
	[DebtorStatementEmailId] [int] IDENTITY(1,1) NOT NULL,
	[DebtorNumber] [char](10) NOT NULL,
	[DebtorName] [nvarchar](127) NULL,
	[CheckFull] [nvarchar](10) NULL,
	[FinancialYear] [nvarchar](4) NULL,
	[FromPeriod] [nvarchar](100) NULL,
	[StatementDate] [nvarchar](20) NULL,
	[ExcludeRetentions] [nvarchar](20) NULL,
	[UseTransactionCurrency] [nvarchar](20) NULL,
	[ExcludeInactive] [nvarchar](20) NULL,
	[UseHomeCurrency] [nvarchar](20) NULL,
	[UseAttributeFilter] [nvarchar](20) NULL,
	[DebtorsControl] [nvarchar](20) NULL,
	[CurrentYear] [nvarchar](20) NULL,
	[ToPeriod] [nvarchar](20) NULL,
	[OriginalCYear] [int] NULL,
	[OriginalCPeriod] [nvarchar](20) NULL,
	[VatString] [nvarchar](20) NULL,
	[SessionPeriod] [nvarchar](20) NULL,
	[FromMonth] [nvarchar](100) NULL,
	[ToMonth] [nvarchar](100) NULL,
	[OrgId] [int] NULL,
	[ReportDefaultId] [nvarchar](20) NULL,
	[ConfigurationOrg] [nvarchar](20) NULL,
	[ReportOrg] [nvarchar](20) NULL,
	[ReportLinkOrgId] [nvarchar](20) NULL,
	[DateSplitCharacter] [nvarchar](2) NULL,
	[SessionDateFormat] [int] NULL,
	[DateCreated] [datetime] NOT NULL,
	[SubmitedDate] [datetime] NULL,
	[EmailAddress] [nvarchar](250) NULL,
	[Error] [nvarchar](2000) NULL,
	[Information] [nvarchar](2000) NULL,
	[CcEmailAddress] [nvarchar](250) NULL,
	[DebtorEmailTypeId] [int] NOT NULL,
	[InvoiceList] [nvarchar](2000) NULL,
	[DetailedErrorMessage] [nvarchar](2000) NULL,
	[Description] [nvarchar](500) NULL,
	[InvoiceStartDate] [datetime] NULL,
	[InvoiceEndDate] [datetime] NULL,
 CONSTRAINT [PK_DebtorStatementEmail] PRIMARY KEY CLUSTERED 
(
	[DebtorStatementEmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DebtorStatementEmail] ADD  CONSTRAINT [DF_DebtorStatementEmail_DebtorEmailTypeId]  DEFAULT ((4)) FOR [DebtorEmailTypeId]