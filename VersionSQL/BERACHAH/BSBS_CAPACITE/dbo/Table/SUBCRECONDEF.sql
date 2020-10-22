/****** Object:  Table [dbo].[SUBCRECONDEF]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SUBCRECONDEF](
	[ACCSPEC] [int] NOT NULL,
	[ACCSPECNAME] [nvarchar](50) NOT NULL,
	[ORGID] [int] NOT NULL,
	[USECURR] [bit] NOT NULL,
	[USEADV] [bit] NOT NULL,
	[USEVARTAB] [bit] NOT NULL,
	[USEPAYE] [bit] NOT NULL,
	[USESDL] [bit] NOT NULL,
	[USEUIF] [bit] NOT NULL,
	[USEWCA] [bit] NOT NULL,
	[USERET] [bit] NOT NULL,
	[USEVAT] [bit] NOT NULL,
	[USEWHT] [bit] NOT NULL,
	[USECONTRA] [bit] NOT NULL,
	[RETADV] [bit] NOT NULL,
	[RETMOS] [bit] NOT NULL,
	[RETADM] [bit] NOT NULL,
	[RETADJ] [bit] NOT NULL,
	[RETDIS] [bit] NOT NULL,
	[TAXTM] [char](1) NOT NULL,
	[TAXDD] [bit] NOT NULL,
	[TAXCD] [char](4) NOT NULL,
	[TAXADV] [bit] NOT NULL,
	[TAXRET] [bit] NOT NULL,
	[TAXWHT] [bit] NOT NULL,
	[TAXCONTRA] [bit] NOT NULL,
	[WHTTP] [char](1) NOT NULL,
	[WHTDD] [bit] NOT NULL,
	[WHTSIGN] [int] NOT NULL,
	[WHTID] [int] NOT NULL,
	[WHTADV] [bit] NOT NULL,
	[WHTADM] [bit] NOT NULL,
	[WHTADJ] [bit] NOT NULL,
	[WHTVAT] [bit] NOT NULL,
	[WHTCONTRA] [bit] NOT NULL,
	[CONTRATP] [char](1) NOT NULL,
	[CONTRATAB] [bit] NOT NULL,
	[CONTRALEDGER] [nvarchar](10) NOT NULL,
	[LAYOUT] [int] NOT NULL,
	[USEBOQ] [bit] NULL,
	[USEADMIN] [bit] NULL,
	[USEDIS] [bit] NOT NULL,
	[DISWD] [bit] NOT NULL,
	[DISESC] [bit] NOT NULL,
	[DISMOS] [bit] NOT NULL,
	[DISOTH] [bit] NOT NULL,
	[DISAMT] [bit] NOT NULL,
	[DISVAR] [bit] NOT NULL,
	[RETVAR] [bit] NOT NULL,
	[SUBAGREEMENT] [bit] NOT NULL,
	[WDDESC] [nvarchar](50) NULL,
	[MOSDESC] [nvarchar](50) NULL,
	[VARDESC] [nvarchar](50) NULL,
	[OTHERDESC] [nvarchar](50) NULL,
	[SDLDESC] [nvarchar](50) NULL,
	[UIFDESC] [nvarchar](50) NULL,
	[WCADESC] [nvarchar](50) NULL,
	[TAXTP] [char](1) NOT NULL,
	[WHTDESC] [nvarchar](50) NULL,
	[RETWD] [bit] NOT NULL,
	[RETESC] [bit] NOT NULL,
	[RETOTH] [bit] NOT NULL,
	[PAYEADV] [bit] NOT NULL,
	[PAYEWD] [bit] NOT NULL,
	[PAYEESC] [bit] NOT NULL,
	[PAYEMOS] [bit] NOT NULL,
	[PAYEVAR] [bit] NOT NULL,
	[PAYEOTH] [bit] NOT NULL,
	[PAYERET] [bit] NOT NULL,
	[PAYEADM] [bit] NOT NULL,
	[PAYEDIS] [bit] NOT NULL,
	[SDLADV] [bit] NOT NULL,
	[SDLWD] [bit] NOT NULL,
	[SDLESC] [bit] NOT NULL,
	[SDLMOS] [bit] NOT NULL,
	[SDLVAR] [bit] NOT NULL,
	[SDLOTH] [bit] NOT NULL,
	[SDLRET] [bit] NOT NULL,
	[SDLADM] [bit] NOT NULL,
	[SDLDIS] [bit] NOT NULL,
	[UIFADV] [bit] NOT NULL,
	[UIFWD] [bit] NOT NULL,
	[UIFESC] [bit] NOT NULL,
	[UIFMOS] [bit] NOT NULL,
	[UIFVAR] [bit] NOT NULL,
	[UIFOTH] [bit] NOT NULL,
	[UIFRET] [bit] NOT NULL,
	[UIFADM] [bit] NOT NULL,
	[UIFDIS] [bit] NOT NULL,
	[WCAADV] [bit] NOT NULL,
	[WCAWD] [bit] NOT NULL,
	[WCAESC] [bit] NOT NULL,
	[WCAMOS] [bit] NOT NULL,
	[WCAVAR] [bit] NOT NULL,
	[WCAOTH] [bit] NOT NULL,
	[WCARET] [bit] NOT NULL,
	[WCAADM] [bit] NOT NULL,
	[WCADIS] [bit] NOT NULL,
	[TAXWD] [bit] NOT NULL,
	[TAXESC] [bit] NOT NULL,
	[TAXMOS] [bit] NOT NULL,
	[TAXVAR] [bit] NOT NULL,
	[TAXOTH] [bit] NOT NULL,
	[TAXADM] [bit] NOT NULL,
	[TAXDIS] [bit] NOT NULL,
	[TAXPAYE] [bit] NOT NULL,
	[TAXSDL] [bit] NOT NULL,
	[TAXUIF] [bit] NOT NULL,
	[TAXWCA] [bit] NOT NULL,
	[WHTWD] [bit] NOT NULL,
	[WHTESC] [bit] NOT NULL,
	[WHTMOS] [bit] NOT NULL,
	[WHTVAR] [bit] NOT NULL,
	[WHTOTH] [bit] NOT NULL,
	[WHTRET] [bit] NOT NULL,
	[WHTDIS] [bit] NOT NULL,
	[WHTPAYE] [bit] NOT NULL,
	[WHTSDL] [bit] NOT NULL,
	[WHTUIF] [bit] NOT NULL,
	[WHTWCA] [bit] NOT NULL,
	[ADVDESC] [nvarchar](50) NULL,
	[PAYEDESC] [nvarchar](50) NULL,
	[ADMDESC] [nvarchar](50) NULL,
	[ESCDESC] [nvarchar](50) NULL,
	[ADVCOL] [char](1) NULL,
	[WDCOL] [char](1) NULL,
	[ESCCOL] [char](1) NULL,
	[MOSCOL] [char](1) NULL,
	[VARCOL] [char](1) NULL,
	[OTHCOL] [char](1) NULL,
	[DISCOL] [char](1) NULL,
	[RETCOL] [char](1) NULL,
	[PAYECOL] [char](1) NULL,
	[SDLCOL] [char](1) NULL,
	[UIFCOL] [char](1) NULL,
	[WCACOL] [char](1) NULL,
	[ADMCOL] [char](1) NULL,
	[TAXCOL] [char](1) NULL,
	[CONTRACOL] [char](1) NULL,
	[WHTCOL] [char](1) NULL,
	[POSTCONTDET] [bit] NOT NULL,
	[UIFMAX] [numeric](18, 4) NOT NULL,
	[WCAMAX] [numeric](18, 4) NOT NULL,
	[PAYECTRL] [nvarchar](35) NOT NULL,
	[SDLCTRL] [nvarchar](35) NOT NULL,
	[UIFCTRL] [nvarchar](35) NOT NULL,
	[WCACTRL] [nvarchar](35) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SITEXT] [nvarchar](500) NOT NULL,
	[TRANSREFCOL] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_SUBCRECONDEF] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ACCSPEC]  DEFAULT ((0)) FOR [ACCSPEC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ACCSPECNAME]  DEFAULT ('') FOR [ACCSPECNAME]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ORGID]  DEFAULT ((-1)) FOR [ORGID]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USECURR]  DEFAULT ('1') FOR [USECURR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEADV]  DEFAULT ('1') FOR [USEADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEVARTAB]  DEFAULT ('0') FOR [USEVARTAB]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEPAYE]  DEFAULT ('1') FOR [USEPAYE]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USESDL]  DEFAULT ('1') FOR [USESDL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEUIF]  DEFAULT ('1') FOR [USEUIF]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEWCA]  DEFAULT ('1') FOR [USEWCA]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USERET]  DEFAULT ('1') FOR [USERET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEVAT]  DEFAULT ('1') FOR [USEVAT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEWHT]  DEFAULT ('1') FOR [USEWHT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USECONTRA]  DEFAULT ('1') FOR [USECONTRA]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETADV]  DEFAULT ('1') FOR [RETADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETMOS]  DEFAULT ('1') FOR [RETMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETADM]  DEFAULT ('1') FOR [RETADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETADJ]  DEFAULT ('1') FOR [RETADJ]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETDIS]  DEFAULT ('1') FOR [RETDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXTM]  DEFAULT ('T') FOR [TAXTM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXDD]  DEFAULT ('1') FOR [TAXDD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXCD]  DEFAULT ('') FOR [TAXCD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXADV]  DEFAULT ('1') FOR [TAXADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXRET]  DEFAULT ('1') FOR [TAXRET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXWHT]  DEFAULT ('1') FOR [TAXWHT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXCONTRA]  DEFAULT ('1') FOR [TAXCONTRA]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTTP]  DEFAULT ('T') FOR [WHTTP]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTDD]  DEFAULT ('1') FOR [WHTDD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTSIGN]  DEFAULT ((-1)) FOR [WHTSIGN]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTID]  DEFAULT ((-1)) FOR [WHTID]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTADV]  DEFAULT ('1') FOR [WHTADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTADM]  DEFAULT ('1') FOR [WHTADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTADJ]  DEFAULT ('1') FOR [WHTADJ]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTVAT]  DEFAULT ('1') FOR [WHTVAT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTCONTRA]  DEFAULT ('1') FOR [WHTCONTRA]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_CONTRATP]  DEFAULT ('T') FOR [CONTRATP]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_CONTRATAB]  DEFAULT ('1') FOR [CONTRATAB]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_CONTRALEDGER]  DEFAULT ('') FOR [CONTRALEDGER]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_LAYOUT]  DEFAULT ((1)) FOR [LAYOUT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEBOQ]  DEFAULT ('1') FOR [USEBOQ]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEADMIN]  DEFAULT ('1') FOR [USEADMIN]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_USEDIS]  DEFAULT ('1') FOR [USEDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISWD]  DEFAULT ('1') FOR [DISWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISESC]  DEFAULT ('1') FOR [DISESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISMOS]  DEFAULT ('1') FOR [DISMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISOTH]  DEFAULT ('1') FOR [DISOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISAMT]  DEFAULT ('1') FOR [DISAMT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISVAR]  DEFAULT ('1') FOR [DISVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETVAR]  DEFAULT ('1') FOR [RETVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SUBAGREEMENT]  DEFAULT ('0') FOR [SUBAGREEMENT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WDDESC]  DEFAULT ('') FOR [WDDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_MOSDESC]  DEFAULT ('') FOR [MOSDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_VARDESC]  DEFAULT ('') FOR [VARDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_OTHERDESC]  DEFAULT ('') FOR [OTHERDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLDESC]  DEFAULT ('') FOR [SDLDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFDESC]  DEFAULT ('') FOR [UIFDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCADESC]  DEFAULT ('') FOR [WCADESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXTP]  DEFAULT ('P') FOR [TAXTP]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTDESC]  DEFAULT ('') FOR [WHTDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETWD]  DEFAULT ('1') FOR [RETWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETESC]  DEFAULT ('1') FOR [RETESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETOTH]  DEFAULT ('1') FOR [RETOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEADV]  DEFAULT ('0') FOR [PAYEADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEWD]  DEFAULT ('0') FOR [PAYEWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEESC]  DEFAULT ('0') FOR [PAYEESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEMOS]  DEFAULT ('0') FOR [PAYEMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEVAR]  DEFAULT ('0') FOR [PAYEVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEOTH]  DEFAULT ('0') FOR [PAYEOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYERET]  DEFAULT ('0') FOR [PAYERET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEADM]  DEFAULT ('0') FOR [PAYEADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEDIS]  DEFAULT ('0') FOR [PAYEDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLADV]  DEFAULT ('0') FOR [SDLADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLWD]  DEFAULT ('0') FOR [SDLWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLESC]  DEFAULT ('0') FOR [SDLESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLMOS]  DEFAULT ('0') FOR [SDLMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLVAR]  DEFAULT ('0') FOR [SDLVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLOTH]  DEFAULT ('0') FOR [SDLOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLRET]  DEFAULT ('0') FOR [SDLRET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLADM]  DEFAULT ('0') FOR [SDLADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLDIS]  DEFAULT ('0') FOR [SDLDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFADV]  DEFAULT ('0') FOR [UIFADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFWD]  DEFAULT ('0') FOR [UIFWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFESC]  DEFAULT ('0') FOR [UIFESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFMOS]  DEFAULT ('0') FOR [UIFMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFVAR]  DEFAULT ('0') FOR [UIFVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFOTH]  DEFAULT ('0') FOR [UIFOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFRET]  DEFAULT ('0') FOR [UIFRET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFADM]  DEFAULT ('0') FOR [UIFADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFDIS]  DEFAULT ('0') FOR [UIFDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAADV]  DEFAULT ('0') FOR [WCAADV]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAWD]  DEFAULT ('0') FOR [WCAWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAESC]  DEFAULT ('0') FOR [WCAESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAMOS]  DEFAULT ('0') FOR [WCAMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAVAR]  DEFAULT ('0') FOR [WCAVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAOTH]  DEFAULT ('0') FOR [WCAOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCARET]  DEFAULT ('0') FOR [WCARET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAADM]  DEFAULT ('0') FOR [WCAADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCADIS]  DEFAULT ('0') FOR [WCADIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXWD]  DEFAULT ('1') FOR [TAXWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXESC]  DEFAULT ('1') FOR [TAXESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXMOS]  DEFAULT ('1') FOR [TAXMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXVAR]  DEFAULT ('1') FOR [TAXVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXOTH]  DEFAULT ('1') FOR [TAXOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXADM]  DEFAULT ('1') FOR [TAXADM]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXDIS]  DEFAULT ('1') FOR [TAXDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXPAYE]  DEFAULT ('0') FOR [TAXPAYE]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXSDL]  DEFAULT ('0') FOR [TAXSDL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXUIF]  DEFAULT ('0') FOR [TAXUIF]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXWCA]  DEFAULT ('0') FOR [TAXWCA]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTWD]  DEFAULT ('1') FOR [WHTWD]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTESC]  DEFAULT ('1') FOR [WHTESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTMOS]  DEFAULT ('1') FOR [WHTMOS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTVAR]  DEFAULT ('1') FOR [WHTVAR]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTOTH]  DEFAULT ('1') FOR [WHTOTH]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTRET]  DEFAULT ('1') FOR [WHTRET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTDIS]  DEFAULT ('1') FOR [WHTDIS]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTPAYE]  DEFAULT ('0') FOR [WHTPAYE]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTSDL]  DEFAULT ('0') FOR [WHTSDL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTUIF]  DEFAULT ('0') FOR [WHTUIF]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTWCA]  DEFAULT ('0') FOR [WHTWCA]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ADVDESC]  DEFAULT ('') FOR [ADVDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYEDESC]  DEFAULT ('') FOR [PAYEDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ADMDESC]  DEFAULT ('') FOR [ADMDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ESCDESC]  DEFAULT ('') FOR [ESCDESC]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ADVCOL]  DEFAULT ('T') FOR [ADVCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WDCOL]  DEFAULT ('T') FOR [WDCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ESCCOL]  DEFAULT ('T') FOR [ESCCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_MOSCOL]  DEFAULT ('T') FOR [MOSCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_VARCOL]  DEFAULT ('T') FOR [VARCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_OTHCOL]  DEFAULT ('T') FOR [OTHCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_DISCOL]  DEFAULT ('T') FOR [DISCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_RETCOL]  DEFAULT ('T') FOR [RETCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYECOL]  DEFAULT ('T') FOR [PAYECOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLCOL]  DEFAULT ('T') FOR [SDLCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFCOL]  DEFAULT ('T') FOR [UIFCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCACOL]  DEFAULT ('C') FOR [WCACOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_ADMCOL]  DEFAULT ('T') FOR [ADMCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TAXCOL]  DEFAULT ('C') FOR [TAXCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_CONTRACOL]  DEFAULT ('C') FOR [CONTRACOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WHTCOL]  DEFAULT ('C') FOR [WHTCOL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_POSTCONTDET]  DEFAULT ('0') FOR [POSTCONTDET]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFMAX]  DEFAULT ('149736') FOR [UIFMAX]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCAMAX]  DEFAULT ('0') FOR [WCAMAX]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_PAYECTRL]  DEFAULT ('') FOR [PAYECTRL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SDLCTRL]  DEFAULT ('') FOR [SDLCTRL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_UIFCTRL]  DEFAULT ('') FOR [UIFCTRL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_WCACTRL]  DEFAULT ('') FOR [WCACTRL]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_SITEXT]  DEFAULT ('Recipient-created tax invoice issued on behalf of the above subcontractor as per the authorisation given by the South African Revenue Service (note 56 dated 31 March 2010)') FOR [SITEXT]
ALTER TABLE [dbo].[SUBCRECONDEF] ADD  CONSTRAINT [DF_SUBCRECONDEF_TRANSREFCOL]  DEFAULT (N'CERTNO') FOR [TRANSREFCOL]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER LOGMASTERSUBCRECONDEF ON SUBCRECONDEF
AFTER UPDATE, DELETE, INSERT
AS 

SET NOCOUNT ON

declare @tableName varChar(25)
declare @primaryKey varChar(25)
declare @ignoreList varChar(500)

set @tableName = 'SUBCRECONDEF'
set @primaryKey = 'ID'
set @ignoreList = ''

declare @action varChar(25)
declare @logUserID int
declare @logDateTime datetime
declare @borgid int
declare @page varChar(100)
declare @info varChar(250)
declare @application varChar(3)
declare @version varChar(15)
declare @context_info int
declare @sqlTblCols nVarChar(max)
declare @sql nVarChar(max)

set @context_info = -1
set @ignoreList = ',' + replace(@ignoreList, ' ', '') + ','
set @action = ''
set @logUserID = -1
set @logDateTime = DATEADD(M, -1, getDate()) 
set @borgid = -1
set @page = ''
set @info = ''
set @application = ''
set @version = ''
set @sqlTblCols = ''
set @sql = ''

if exists(select * from INSERTED)
BEGIN
	if exists(select * from DELETED)
	BEGIN
		set @action = 'UPDATE'
	END
	ELSE
	BEGIN
		set @action = 'INSERT'
	END
END
ELSE
BEGIN
	if exists(select * from DELETED)
	BEGIN
		set @action = 'DELETE'
	END
END
 
select * into #inserted from INSERTED
select * into #deleted from DELETED

SELECT @context_info = cast(replace(cast(CONTEXT_INFO as varchar(128)), char(0) COLLATE SQL_Latin1_General_CP1_CI_AS,'') as int) FROM master.dbo.sysprocesses WHERE spid = @@SPID

select @logUserID = isnull(USERID, -1),
@logDateTime = isnull(LOGDATETIME, DATEADD(M, -1, getDate())),
@borgid = isnull(BORGID, @borgid),
@page = isnull(PAGE, @page),
@info = isnull(INFO, @info),
@application  = isnull(APPLICATION, @application),
@version = isnull(VERSION, @version)
from logcontext 
where LOGID = @context_info
	
delete FROM LOGCONTEXT where LOGID = @context_info
   
if @action = 'UPDATE'
BEGIN		
	Select @sqlTblCols = @sqlTblCols + 'Case when rtrim(cast(IsNull(i.[' + Column_Name + '],0) as varChar(100)))=rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100))) then '''' else ' + '''[' + Column_Name + ']:'' + rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + ''' + ' -> '' + rtrim(cast(IsNull(i.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + ''' + ''' + '', ''' + ' end +'
	from information_schema.columns 
	where TABLE_NAME = @tableName
	and PATINDEX('%,' + COLUMN_NAME + ',%', @ignoreList) = 0
	and DATA_TYPE not like '%text%'
	and DATA_TYPE not like '%image%'
	and DATA_TYPE not like '%binary%' 
		
	set @sqlTblCols = Substring(@sqlTblCols, 1 , len(@sqlTblCols) - 1)

	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', '''+ @primaryKey +' = '' + cast(i.'+ @primaryKey +' as varChar(10)), Substring(' + @sqlTblCols + ', 1 , len(' + @sqlTblCols + ') - 1) '
	set @sql = @sql + 'From #inserted i inner join #deleted d on i.'+ @primaryKey +' = d.'+ @primaryKey +' where isnull(' + @sqlTblCols + ', '''') <> '''' ' 

	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END   

if @action = 'DELETE' or @action = 'INSERT'
BEGIN
	Select @sqlTblCols = @sqlTblCols + '''[' + Column_Name + ']:'' + rtrim(cast(IsNull(d.[' + Column_Name + '],0) as varChar(100)) collate SQL_LATIN1_GENERAL_CP1_CI_AS) + '', '' + '
	from information_schema.columns 
	where TABLE_NAME = @tableName
	and PATINDEX('%,' + COLUMN_NAME + ',%', @ignoreList) = 0
	and DATA_TYPE not like '%text%'
	and DATA_TYPE not like '%image%'
	and DATA_TYPE not like '%binary%' 
		
	set @sqlTblCols = Substring(@sqlTblCols, 1, len(@sqlTblCols) - 5) + ''''
	
	set @sql = 'select ''' + cast(@logUserID as varChar(10)) + ''', ''' + cast(@borgid as varChar(10)) + ''', ''' + @application + ''', ''' + @tableName + ''', ''' + @action + ''', ''' + @page + ''', ''' + @info + ''', ''' + @version + ''', '''+ @primaryKey +' = '' + cast(d.'+ @primaryKey +' as varChar(10)), ' + @sqlTblCols + ' '
	set @sql = @sql + 'From '+ case when @action = 'DELETE' then '#deleted' else '#inserted' end +' d ' 
 
	insert into LOGMASTER (USERID, BORGID, APPLICATION, TABLENAME, ACTION, PAGE, INFO, VERSION, PRIMARYKEY, DETAILS)
	exec sp_executesql @sql
END

DROP TABLE #inserted
DROP TABLE #deleted

		
ALTER TABLE [dbo].[SUBCRECONDEF] ENABLE TRIGGER [LOGMASTERSUBCRECONDEF]