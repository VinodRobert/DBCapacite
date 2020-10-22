/****** Object:  Table [dbo].[EMBATCHDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMBATCHDETAIL](
	[DetailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HeaderID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[EMPNAME] [nvarchar](75) NOT NULL,
	[BIRTHDAY] [datetime] NOT NULL,
	[BANKACCOUNT] [nvarchar](30) NOT NULL,
	[BANKBRANCHCODE] [nvarchar](10) NOT NULL,
	[IDNUM] [nvarchar](30) NOT NULL,
	[DEPENDENTS] [int] NOT NULL,
	[STARTDATE] [datetime] NOT NULL,
	[TYPEPAYMENT] [nvarchar](15) NOT NULL,
	[PAYBY] [nvarchar](30) NOT NULL,
	[RATE1] [money] NOT NULL,
	[LDTOTALYEAR] [decimal](18, 2) NOT NULL,
	[SDTOTAL] [decimal](18, 2) NOT NULL,
	[EDSHID] [int] NOT NULL,
	[PREVNUMBER] [nvarchar](15) NOT NULL,
	[SURNAME] [nvarchar](75) NOT NULL,
	[KNOWNAS] [nvarchar](25) NOT NULL,
	[INITIALS] [nvarchar](7) NOT NULL,
	[SEX] [nvarchar](6) NOT NULL,
	[RACE] [nvarchar](10) NOT NULL,
	[MARITALSTATUS] [nvarchar](10) NOT NULL,
	[NATURE] [nvarchar](2) NOT NULL,
	[TEL1] [nvarchar](15) NOT NULL,
	[CELL1] [nvarchar](15) NOT NULL,
	[EMAIL] [nvarchar](50) NOT NULL,
	[ADDR1] [nvarchar](50) NOT NULL,
	[ADDR2] [nvarchar](50) NOT NULL,
	[ADDR3] [nvarchar](50) NOT NULL,
	[PCODE] [nvarchar](8) NOT NULL,
	[BANKACCTYPE] [nvarchar](20) NOT NULL,
	[BANKBRANCHNAME] [nvarchar](50) NOT NULL,
	[STANDARDBANK_PROFILE] [nvarchar](16) NOT NULL,
	[PASSPORTNO] [nvarchar](25) NOT NULL,
	[HFNUMBER] [nvarchar](20) NOT NULL,
	[CHILDREN] [smallint] NOT NULL,
	[SPOUSENAME] [nvarchar](75) NOT NULL,
	[SPOUSEADDR] [nvarchar](75) NOT NULL,
	[SPOUSETEL] [nvarchar](15) NOT NULL,
	[SPOUSECELL] [nvarchar](15) NOT NULL,
	[EMPDISABILITY] [nvarchar](200) NOT NULL,
	[MDCLNAME] [nvarchar](50) NOT NULL,
	[MDCLNUMBER] [nvarchar](20) NOT NULL,
	[PENSPROVNUMBER] [nvarchar](20) NOT NULL,
	[GRSTARTDATE] [datetime] NULL,
	[PENDATE] [datetime] NULL,
	[PAYPOINT] [nvarchar](15) NOT NULL,
	[OCCUPATION] [nvarchar](50) NOT NULL,
	[EMPOCCCAT] [smallint] NOT NULL,
	[EMPOCCLEVEL] [smallint] NOT NULL,
	[EQMOVE] [smallint] NOT NULL,
	[JOBCODE] [nvarchar](10) NOT NULL,
	[GRADE] [nvarchar](10) NOT NULL,
	[ISFOREMAN] [bit] NOT NULL,
	[FOREMANNUM] [nvarchar](15) NOT NULL,
	[FOREMANPRLID] [int] NOT NULL,
	[RATE2] [money] NOT NULL,
	[RATE3] [money] NOT NULL,
	[TRAVELRATE] [money] NOT NULL,
	[DIRECTIVENO] [nvarchar](20) NOT NULL,
	[DIRECTIVEPERC] [decimal](18, 2) NOT NULL,
	[SSCODE] [nvarchar](25) NOT NULL,
	[SSCATEGORY] [nvarchar](25) NOT NULL,
	[PRLSTAMP] [nvarchar](4) NOT NULL,
	[TAXNUMBER] [nvarchar](20) NOT NULL,
	[IT3REASONCODE] [nvarchar](3) NOT NULL,
	[TAXALLOC] [nvarchar](3) NOT NULL,
	[WCATYPE] [char](15) NOT NULL,
	[UIFREASONCODE] [nvarchar](3) NOT NULL,
	[STDHRSPAYPER] [decimal](18, 2) NOT NULL,
	[DEBTNUMBER] [char](10) NOT NULL,
	[CONTRACTEXPDATE] [datetime] NULL,
	[NOTES] [text] NOT NULL,
	[EMPUNION] [nvarchar](15) NOT NULL,
	[EMPLOYLEVEL] [int] NOT NULL,
	[FILENO] [nvarchar](15) NOT NULL,
	[COUNTRYORG] [nvarchar](55) NOT NULL,
	[PENSIONSTARTDATE] [datetime] NULL,
	[MEDICALSTARTDATE] [datetime] NULL,
	[COSTTOCOMP] [decimal](18, 2) NOT NULL,
	[BONUS] [decimal](18, 2) NOT NULL,
	[IPBENEFICIARY] [nvarchar](75) NOT NULL,
	[IPADDR1] [nvarchar](50) NOT NULL,
	[IPADDR2] [nvarchar](50) NOT NULL,
	[IPADDR3] [nvarchar](50) NOT NULL,
	[IPBANKACCOUNT] [nvarchar](50) NOT NULL,
	[IPBANKNAME] [nvarchar](50) NOT NULL,
	[IPBANKADDR1] [nvarchar](50) NOT NULL,
	[IPBANKADDR2] [nvarchar](50) NOT NULL,
	[IPBANKADDR3] [nvarchar](50) NOT NULL,
	[IPBRANCHNAME] [nvarchar](50) NOT NULL,
	[IPBANKTEL1] [nvarchar](15) NOT NULL,
	[IPBANKTEL2] [nvarchar](15) NOT NULL,
	[IPSWIFT] [nvarchar](15) NOT NULL,
	[IPSORT] [nvarchar](15) NOT NULL,
	[IPABA] [nvarchar](20) NOT NULL,
	[IPIBAN] [nvarchar](50) NOT NULL,
	[IPCORRESPONDENTBANKNAME] [nvarchar](20) NOT NULL,
	[IPCORRESPONDENTABA] [nvarchar](20) NOT NULL,
	[IPINFO] [nvarchar](200) NOT NULL,
	[TNALEDGERCODECONTRACT] [char](10) NOT NULL,
	[TNALEDGERCODEPLANT] [char](10) NOT NULL,
	[TNALEDGERCODEBS] [char](10) NOT NULL,
	[TNALEDGERCODEOH] [char](10) NOT NULL,
 CONSTRAINT [PK_EMBATCHDETAIL] PRIMARY KEY CLUSTERED 
(
	[DetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_EMBATCHDETAIL] UNIQUE NONCLUSTERED 
(
	[EMPNUMBER] ASC,
	[HeaderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_BANKACCOUNT]  DEFAULT ('') FOR [BANKACCOUNT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_BANKBRANCHCODE]  DEFAULT ('') FOR [BANKBRANCHCODE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IDNUM]  DEFAULT ('') FOR [IDNUM]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_DEPENDENTS]  DEFAULT ((0)) FOR [DEPENDENTS]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TYPEPAYMENT]  DEFAULT ('') FOR [TYPEPAYMENT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PAYBY]  DEFAULT ('Cash') FOR [PAYBY]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_RATE1]  DEFAULT ((0)) FOR [RATE1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_LDTOTALYEAR]  DEFAULT ((0)) FOR [LDTOTALYEAR]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SDTOTAL]  DEFAULT ((0)) FOR [SDTOTAL]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EDSHID]  DEFAULT ((0)) FOR [EDSHID]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PREVNUMBER]  DEFAULT ('') FOR [PREVNUMBER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SURNAME]  DEFAULT ('') FOR [SURNAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_KNOWNAS]  DEFAULT ('') FOR [KNOWNAS]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_INITIALS]  DEFAULT ('') FOR [INITIALS]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SEX]  DEFAULT ('') FOR [SEX]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_RACE]  DEFAULT ('') FOR [RACE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_MARITALSTATUS]  DEFAULT ('') FOR [MARITALSTATUS]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_NATURE]  DEFAULT ('A') FOR [NATURE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TEL1]  DEFAULT ('') FOR [TEL1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_CELL1]  DEFAULT ('') FOR [CELL1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EMAIL]  DEFAULT ('') FOR [EMAIL]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_ADDR1]  DEFAULT ('') FOR [ADDR1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_ADDR2]  DEFAULT ('') FOR [ADDR2]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_ADDR3]  DEFAULT ('') FOR [ADDR3]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PCODE]  DEFAULT ('') FOR [PCODE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_BANKACCTYPE]  DEFAULT ('') FOR [BANKACCTYPE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_BANKBRANCHNAME]  DEFAULT ('') FOR [BANKBRANCHNAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_STANDARDBANK_PROFILE]  DEFAULT ('') FOR [STANDARDBANK_PROFILE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PASSPORTNO]  DEFAULT ('') FOR [PASSPORTNO]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_HFNUMBER]  DEFAULT ('') FOR [HFNUMBER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_CHILDREN]  DEFAULT ((0)) FOR [CHILDREN]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SPOUSENAME]  DEFAULT ('') FOR [SPOUSENAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SPOUSEADDR]  DEFAULT ('') FOR [SPOUSEADDR]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SPOUSETEL]  DEFAULT ('') FOR [SPOUSETEL]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SPOUSECELL]  DEFAULT ('') FOR [SPOUSECELL]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EMPDISABILITY]  DEFAULT ('') FOR [EMPDISABILITY]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_MDCLNAME]  DEFAULT ('') FOR [MDCLNAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_MDCLNUMBER]  DEFAULT ('') FOR [MDCLNUMBER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PENSPROVNUMBER]  DEFAULT ('') FOR [PENSPROVNUMBER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PAYPOINT]  DEFAULT ('') FOR [PAYPOINT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_OCCUPATION]  DEFAULT ('') FOR [OCCUPATION]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EMPOCCCAT]  DEFAULT ((0)) FOR [EMPOCCCAT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EMPOCCLEVEL]  DEFAULT ((0)) FOR [EMPOCCLEVEL]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EQMOVE]  DEFAULT ((0)) FOR [EQMOVE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_JOBCODE]  DEFAULT ('') FOR [JOBCODE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_GRADE]  DEFAULT ('') FOR [GRADE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_ISFOREMAN]  DEFAULT ((0)) FOR [ISFOREMAN]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_FOREMANNUM]  DEFAULT ('') FOR [FOREMANNUM]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_FOREMANPRLID]  DEFAULT ((-1)) FOR [FOREMANPRLID]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_RATE2]  DEFAULT ((0)) FOR [RATE2]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_RATE3]  DEFAULT ((0)) FOR [RATE3]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TRAVELRATE]  DEFAULT ((0)) FOR [TRAVELRATE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_DIRECTIVENO]  DEFAULT ('') FOR [DIRECTIVENO]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_DIRECTIVEPERC]  DEFAULT ((0)) FOR [DIRECTIVEPERC]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SSCODE]  DEFAULT ('') FOR [SSCODE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_SSCATEGORY]  DEFAULT ('') FOR [SSCATEGORY]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_PRLSTAMP]  DEFAULT ('') FOR [PRLSTAMP]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TAXNUMBER]  DEFAULT ('') FOR [TAXNUMBER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IT3REASONCODE]  DEFAULT ('') FOR [IT3REASONCODE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TAXALLOC]  DEFAULT ('') FOR [TAXALLOC]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_WCATYPE]  DEFAULT ('') FOR [WCATYPE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_UIFREASONCODE]  DEFAULT ('') FOR [UIFREASONCODE]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_STDHRSPAYPER]  DEFAULT ((0)) FOR [STDHRSPAYPER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_DEBTNUMBER]  DEFAULT ('') FOR [DEBTNUMBER]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_NOTES]  DEFAULT ('') FOR [NOTES]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EMPUNION]  DEFAULT ('') FOR [EMPUNION]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_EMPLOYLEVEL]  DEFAULT ((0)) FOR [EMPLOYLEVEL]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_FILENO]  DEFAULT ('') FOR [FILENO]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_COUNTRYORG]  DEFAULT ('') FOR [COUNTRYORG]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_COSTTOCOMP]  DEFAULT ((0)) FOR [COSTTOCOMP]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_BONUS]  DEFAULT ((0)) FOR [BONUS]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBENEFICIARY]  DEFAULT ('') FOR [IPBENEFICIARY]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPADDR1]  DEFAULT ('') FOR [IPADDR1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPADDR2]  DEFAULT ('') FOR [IPADDR2]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPADDR3]  DEFAULT ('') FOR [IPADDR3]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKACCOUNT]  DEFAULT ('') FOR [IPBANKACCOUNT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKNAME]  DEFAULT ('') FOR [IPBANKNAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKADDR1]  DEFAULT ('') FOR [IPBANKADDR1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKADDR2]  DEFAULT ('') FOR [IPBANKADDR2]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKADDR3]  DEFAULT ('') FOR [IPBANKADDR3]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBRANCHNAME]  DEFAULT ('') FOR [IPBRANCHNAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKTEL1]  DEFAULT ('') FOR [IPBANKTEL1]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPBANKTEL2]  DEFAULT ('') FOR [IPBANKTEL2]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPSWIFT]  DEFAULT ('') FOR [IPSWIFT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPSORT]  DEFAULT ('') FOR [IPSORT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPABA]  DEFAULT ('') FOR [IPABA]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPIBAN]  DEFAULT ('') FOR [IPIBAN]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPCORRESPONDENTBANKNAME]  DEFAULT ('') FOR [IPCORRESPONDENTBANKNAME]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPCORRESPONDENTABA]  DEFAULT ('') FOR [IPCORRESPONDENTABA]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_IPINFO]  DEFAULT ('') FOR [IPINFO]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TNALEDGERCODECONTRACT]  DEFAULT ('') FOR [TNALEDGERCODECONTRACT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TNALEDGERCODEPLANT]  DEFAULT ('') FOR [TNALEDGERCODEPLANT]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TNALEDGERCODEBS]  DEFAULT ('') FOR [TNALEDGERCODEBS]
ALTER TABLE [dbo].[EMBATCHDETAIL] ADD  CONSTRAINT [DF_EMBATCHDETAIL_TNALEDGERCODEOH]  DEFAULT ('') FOR [TNALEDGERCODEOH]