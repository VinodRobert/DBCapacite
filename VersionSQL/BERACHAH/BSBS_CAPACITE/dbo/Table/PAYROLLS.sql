/****** Object:  Table [dbo].[PAYROLLS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PAYROLLS](
	[PAYROLLID] [int] NOT NULL,
	[PAYROLLNAME] [nvarchar](55) NOT NULL,
	[PAYROLLDESC] [nvarchar](255) NOT NULL,
	[BORGID] [int] NOT NULL,
	[DEN01] [decimal](18, 2) NOT NULL,
	[DEN02] [decimal](18, 2) NOT NULL,
	[DEN03] [decimal](18, 2) NOT NULL,
	[DEN04] [decimal](18, 2) NOT NULL,
	[DEN05] [decimal](18, 2) NOT NULL,
	[DEN06] [decimal](18, 2) NOT NULL,
	[DEN07] [decimal](18, 2) NOT NULL,
	[DEN08] [decimal](18, 2) NOT NULL,
	[DEN09] [decimal](18, 2) NOT NULL,
	[DEN10] [decimal](18, 2) NOT NULL,
	[DEN11] [decimal](18, 2) NOT NULL,
	[DEN12] [decimal](18, 2) NOT NULL,
	[DEN13] [decimal](18, 2) NOT NULL,
	[DEN14] [decimal](18, 2) NOT NULL,
	[DEN15] [decimal](18, 2) NOT NULL,
	[DEN16] [decimal](18, 2) NOT NULL,
	[DEN17] [decimal](18, 2) NOT NULL,
	[DEN18] [decimal](18, 2) NOT NULL,
	[DEN19] [decimal](18, 2) NOT NULL,
	[DEN20] [decimal](18, 2) NOT NULL,
	[MAXSHIFTSYEAR] [decimal](10, 2) NOT NULL,
	[ROUNDTO] [decimal](19, 2) NOT NULL,
	[NHPAYPERIOD] [decimal](18, 2) NOT NULL,
	[MAXYEAREARNUIFDEDU] [decimal](18, 2) NOT NULL,
	[USESECONDRATE] [bit] NOT NULL,
	[NTOTADJ] [bit] NOT NULL,
	[UIFDEDUEMPE] [decimal](18, 2) NOT NULL,
	[UIFDEDUEMPL] [decimal](18, 2) NOT NULL,
	[MAXSHIFTSHRSPAYPERIOD] [decimal](18, 2) NOT NULL,
	[CLOCKCARDSPERPAYPERIOD] [decimal](18, 2) NOT NULL,
	[WCABCUTOFF] [decimal](18, 2) NOT NULL,
	[WCABASS] [decimal](18, 2) NOT NULL,
	[WCABEXC] [decimal](18, 2) NOT NULL,
	[WCACCUTOFF] [decimal](18, 2) NOT NULL,
	[WCACASS] [decimal](18, 2) NOT NULL,
	[WCACEXC] [decimal](18, 2) NOT NULL,
	[SDLPERC] [decimal](18, 2) NOT NULL,
	[IRP5CREATORNO] [nvarchar](30) NOT NULL,
	[IRP5CONTACTNAME] [nvarchar](75) NOT NULL,
	[IRP5TEL1] [nvarchar](30) NOT NULL,
	[IRP5TEL2] [nvarchar](30) NOT NULL,
	[IRP5EMAIL] [nvarchar](50) NOT NULL,
	[DEN21] [decimal](18, 2) NOT NULL,
	[DEN22] [decimal](18, 2) NOT NULL,
	[DEN23] [decimal](18, 2) NOT NULL,
	[DEN24] [decimal](18, 2) NOT NULL,
	[DEN25] [decimal](18, 2) NOT NULL,
	[DEN26] [decimal](18, 2) NOT NULL,
	[USETHIRDRATE] [bit] NOT NULL,
	[DAYSCAPTURE] [bit] NOT NULL,
	[TAXYEARSTART] [datetime] NOT NULL,
	[CURRPERIOD] [smallint] NOT NULL,
	[CURRYEARNO] [smallint] NOT NULL,
	[PRLNUMBER] [nvarchar](10) NOT NULL,
	[RUNNO] [smallint] NOT NULL,
	[PERIODPAYMENT] [nvarchar](15) NOT NULL,
	[TAXYEARENDDATE] [datetime] NOT NULL,
	[PAYSLIPSASP] [nvarchar](50) NOT NULL,
	[CHEQUESASP] [nvarchar](50) NOT NULL,
	[IRP5ASP] [nvarchar](50) NOT NULL,
	[IT3ASP] [nvarchar](50) NOT NULL,
	[BANKID] [int] NOT NULL,
	[PADEMP] [smallint] NOT NULL,
	[PADEDS] [smallint] NOT NULL,
	[LABELSASP] [nvarchar](50) NOT NULL,
	[SYNCPAYPOINTS] [bit] NOT NULL,
	[MINYEAREARNUIFDEDU] [decimal](14, 2) NOT NULL,
	[NEGCALC] [bit] NOT NULL,
	[FLFACTOR] [decimal](18, 2) NOT NULL,
	[ALLOWEXTCDC] [bit] NOT NULL,
	[ALLOWTPP] [bit] NOT NULL,
	[MAXWEEKNTHOURS] [decimal](18, 2) NOT NULL,
	[ALLOWEXTDIV] [bit] NOT NULL,
	[ALLOWEXTPE] [bit] NOT NULL,
	[DEFAULTPT] [nvarchar](15) NOT NULL,
	[SPLITMACALCS] [bit] NOT NULL,
	[PRLSPEC] [nvarchar](20) NOT NULL,
	[USEINTPAYMENTS] [bit] NOT NULL,
	[ZAMPENNONTAX] [decimal](18, 2) NOT NULL,
	[SERVCERTASP] [nvarchar](50) NOT NULL,
	[IGNOREEMPNOHOURS] [bit] NOT NULL,
	[NETTWARNAMOUNT] [bigint] NOT NULL,
	[FIRSTMACAP] [decimal](18, 2) NOT NULL,
	[SECONDMACAP] [decimal](18, 2) NOT NULL,
	[NAMMACOPERC] [decimal](18, 2) NOT NULL,
	[NAMMAEMPPERC] [decimal](18, 2) NOT NULL,
	[AUTOADJTCP] [bit] NOT NULL,
	[HOURSPERSHIFT] [decimal](18, 2) NOT NULL,
	[DEFLCNTCONTR] [nvarchar](10) NOT NULL,
	[DEFLCOTCONTR] [nvarchar](10) NOT NULL,
	[DEFLCNTPLANT] [nvarchar](10) NOT NULL,
	[DEFLCOTPLANT] [nvarchar](10) NOT NULL,
	[DEFLCNTOH] [nvarchar](10) NOT NULL,
	[DEFLCOTOH] [nvarchar](10) NOT NULL,
	[DEFLCNTBS] [nvarchar](10) NOT NULL,
	[DEFLCOTBS] [nvarchar](10) NOT NULL,
	[PTINNO] [nvarchar](50) NOT NULL,
	[ALLOWDEFPOSTING] [bit] NOT NULL,
	[SMOOTHTAX] [bit] NOT NULL,
	[ANNZAMTAX] [bit] NOT NULL,
	[SURCHARGELEVEL] [decimal](18, 2) NOT NULL,
	[SURCHARGEP1] [decimal](18, 2) NOT NULL,
	[SURCHARGEP2] [decimal](18, 2) NOT NULL,
	[OTCOST] [bit] NOT NULL,
	[HRSPEC] [nvarchar](5) NOT NULL,
	[OTRATERECALC] [bit] NOT NULL,
	[APPRTNA] [bit] NOT NULL,
	[CALCSPERCCLI] [bit] NOT NULL,
	[DECPLACES] [int] NOT NULL,
	[HOMEORGCODE] [nvarchar](30) NOT NULL,
	[HOMEORGNUMBER] [nvarchar](20) NOT NULL,
	[THIRTYDAYSINMONTH] [bit] NOT NULL,
	[SHOWYTDVALUES] [bit] NOT NULL,
	[ALLOWEMPADD] [bit] NOT NULL,
	[ALLOWEMPTERM] [bit] NOT NULL,
	[CURRENCY] [nvarchar](3) NOT NULL,
	[HRSERVER] [nvarchar](100) NOT NULL,
	[HRDBNAME] [nvarchar](100) NOT NULL,
	[HRUSERID] [nvarchar](100) NOT NULL,
	[HRPASSWORD] [nvarchar](100) NOT NULL,
	[CONTRBONBASICAMOUNT] [decimal](18, 4) NOT NULL,
	[MAXNUMBERINCREMENT] [int] NOT NULL,
	[YEARINCREASEAMOUNT] [decimal](18, 4) NOT NULL,
	[SHOWABSALONMANUAL] [bit] NOT NULL,
	[ALLOW3MAVRG] [bit] NOT NULL,
	[ALLOW6MAVRG] [bit] NOT NULL,
	[ALLOW12MAVRG] [bit] NOT NULL,
	[INDUSTRYSPEC] [nvarchar](15) NOT NULL,
	[ENABLEABSALMANUAL] [bit] NOT NULL,
	[ISMIBFAACTIVE] [bit] NOT NULL,
	[ENFORCEWCATYPE] [bit] NOT NULL,
	[ALLOWTNAEXPORT] [bit] NOT NULL,
	[CLEARDIRECTIVENUMBER] [bit] NOT NULL,
	[USECCSHIFTSTOACCA] [nvarchar](20) NOT NULL,
	[ISHRTEMPDISABLED] [bit] NOT NULL,
	[ALLOW2MAVRG] [bit] NOT NULL,
	[MAXPILLEAVE] [decimal](10, 4) NOT NULL,
	[MAXCMPSSLEAVE] [decimal](10, 4) NOT NULL,
	[MAXUPILLEAVE] [decimal](10, 4) NOT NULL,
	[MAXUMATLEAVE] [decimal](10, 4) NOT NULL,
	[MAXMATLEAVE] [decimal](10, 4) NOT NULL,
	[MAXINJURYLEAVE] [decimal](10, 4) NOT NULL,
	[MAXPHLEAVE] [decimal](10, 4) NOT NULL,
	[MAXICLEAVE] [decimal](10, 4) NOT NULL,
	[MAXSLLEAVE] [decimal](10, 4) NOT NULL,
	[MAXVPLEAVE] [decimal](10, 4) NOT NULL,
	[MAXVULEAVE] [decimal](10, 4) NOT NULL,
	[MAXULLEAVE] [decimal](10, 4) NOT NULL,
	[SKIPJOURNALSPOSTING] [bit] NOT NULL,
	[TAXREGNO] [nvarchar](30) NOT NULL,
	[ENABLETAXREGNO] [bit] NOT NULL,
	[STAMPREGNO] [nvarchar](30) NOT NULL,
	[ENABLESTAMPREGNO] [bit] NOT NULL,
	[UIFREGNO] [nvarchar](30) NOT NULL,
	[ENABLEUIFREGNO] [bit] NOT NULL,
	[SDLREGNO] [nvarchar](30) NOT NULL,
	[ENABLESDLREGNO] [bit] NOT NULL,
	[RSCREGNO] [nvarchar](30) NOT NULL,
	[ENABLERSCREGNO] [bit] NOT NULL,
	[UIFREFERENCENUMBER] [nvarchar](30) NOT NULL,
	[ENABLEUIFREFERENCENUMBER] [bit] NOT NULL,
	[TNAXMLURL] [nvarchar](230) NOT NULL,
	[ENABLETNAXMLURL] [bit] NOT NULL,
	[COSOCSECNO] [nvarchar](30) NOT NULL,
	[ENABLESOCIALSECURITY] [bit] NOT NULL,
	[FIRMNUMBER] [nvarchar](15) NOT NULL,
	[ENABLEFIRMNUMMIBFA] [bit] NOT NULL,
	[TRDCLASSIFICATION] [nvarchar](4) NOT NULL,
	[ENABLETRADECLASSIFICATION] [bit] NOT NULL,
	[ADDRUNITNUM] [nvarchar](5) NOT NULL,
	[ENABLEUNITNUM] [bit] NOT NULL,
	[ENABLECOMPLEX] [bit] NOT NULL,
	[ADDRCOMPLEX] [nvarchar](25) NOT NULL,
	[ADDRSTREETNUM] [nvarchar](5) NOT NULL,
	[ENABLESTREETNUM] [bit] NOT NULL,
	[ADDRSTREET] [nvarchar](25) NOT NULL,
	[ENABLESTREET] [bit] NOT NULL,
	[ADDRSUBURB] [nvarchar](34) NOT NULL,
	[ENABLESUBURB] [bit] NOT NULL,
	[ADDRCITY] [nvarchar](24) NOT NULL,
	[ENABLECITY] [bit] NOT NULL,
	[ADDRPOSTALCODE] [nvarchar](230) NOT NULL,
	[ENABLEPOSTALCODE] [bit] NOT NULL,
	[LEAVEPAYDATEDRIVEN] [bit] NOT NULL,
	[CONTACTPERSON] [nvarchar](150) NOT NULL,
	[CONTACTNUMBER] [nvarchar](150) NOT NULL,
	[ENABLEWORKFLOWCC] [bit] NOT NULL,
	[ENABLEWORKFLOWAA] [bit] NOT NULL,
	[ENABLEWORKFLOWLD] [bit] NOT NULL,
	[ENABLEWORKFLOWSD] [bit] NOT NULL,
 CONSTRAINT [PK_PAYROLLS] PRIMARY KEY CLUSTERED 
(
	[PAYROLLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_PAYROLLS_NUMBER] UNIQUE NONCLUSTERED 
(
	[PRLNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PAYROLLNAME]  DEFAULT ('') FOR [PAYROLLNAME]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PAYROLLDESC]  DEFAULT ('') FOR [PAYROLLDESC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN01]  DEFAULT ((200)) FOR [DEN01]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN02]  DEFAULT ((100)) FOR [DEN02]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN03]  DEFAULT ((50)) FOR [DEN03]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN04]  DEFAULT ((20)) FOR [DEN04]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN05]  DEFAULT ((10)) FOR [DEN05]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN06]  DEFAULT ((5)) FOR [DEN06]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN07]  DEFAULT ((2)) FOR [DEN07]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN08]  DEFAULT ((1)) FOR [DEN08]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN09]  DEFAULT ((0.50)) FOR [DEN09]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN10]  DEFAULT ((0.20)) FOR [DEN10]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN11]  DEFAULT ((0.10)) FOR [DEN11]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN12]  DEFAULT ((0.05)) FOR [DEN12]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN13]  DEFAULT ((0.02)) FOR [DEN13]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN14]  DEFAULT ((0.01)) FOR [DEN14]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN15]  DEFAULT ((0.00)) FOR [DEN15]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN16]  DEFAULT ((0.00)) FOR [DEN16]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN17]  DEFAULT ((0.00)) FOR [DEN17]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN18]  DEFAULT ((0.00)) FOR [DEN18]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN19]  DEFAULT ((0.00)) FOR [DEN19]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN20]  DEFAULT ((0.00)) FOR [DEN20]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_MAXSHIFTSYEAR]  DEFAULT ((0)) FOR [MAXSHIFTSYEAR]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ROUNDTO]  DEFAULT ((0)) FOR [ROUNDTO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_NHPAYPERIOD]  DEFAULT ((0)) FOR [NHPAYPERIOD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_MAXUIFDEDU]  DEFAULT ((0)) FOR [MAXYEAREARNUIFDEDU]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_SECONDRATE]  DEFAULT ((0)) FOR [USESECONDRATE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_NTOTADJ]  DEFAULT ((0)) FOR [NTOTADJ]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_UIFDEDU]  DEFAULT ((0)) FOR [UIFDEDUEMPE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_UIFDEDUEMPl]  DEFAULT ((0)) FOR [UIFDEDUEMPL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_MAXSHIFTSHRSPAYPERIOD]  DEFAULT ((0)) FOR [MAXSHIFTSHRSPAYPERIOD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_CLOCKCARDSPERPAYPERIOD]  DEFAULT ((0)) FOR [CLOCKCARDSPERPAYPERIOD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_WCACUTOFF]  DEFAULT ((0)) FOR [WCABCUTOFF]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_WCAASS]  DEFAULT ((0)) FOR [WCABASS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_WCAEXC]  DEFAULT ((0)) FOR [WCABEXC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_WCACCUTOFF]  DEFAULT ((0)) FOR [WCACCUTOFF]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_WCACASS]  DEFAULT ((0)) FOR [WCACASS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_WCACEXC]  DEFAULT ((0)) FOR [WCACEXC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_SDLPERC]  DEFAULT ((0)) FOR [SDLPERC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IRP5CREATORNO]  DEFAULT ('') FOR [IRP5CREATORNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IRP5CONTACTNAME]  DEFAULT ('') FOR [IRP5CONTACTNAME]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IRP5TEL1]  DEFAULT ('') FOR [IRP5TEL1]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IRP5TEL2]  DEFAULT ('') FOR [IRP5TEL2]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IRP5EMAIL]  DEFAULT ('') FOR [IRP5EMAIL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN21]  DEFAULT ((0.00)) FOR [DEN21]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN22]  DEFAULT ((0.00)) FOR [DEN22]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN23]  DEFAULT ((0.00)) FOR [DEN23]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN24]  DEFAULT ((0.00)) FOR [DEN24]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN25]  DEFAULT ((0.00)) FOR [DEN25]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEN26]  DEFAULT ((0.00)) FOR [DEN26]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_THIRDRATE]  DEFAULT ((0)) FOR [USETHIRDRATE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DAYCAPTURE]  DEFAULT ((0)) FOR [DAYSCAPTURE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_TAXYEARSTART]  DEFAULT ('01/03/2003') FOR [TAXYEARSTART]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_RUNNO_1]  DEFAULT ((1)) FOR [CURRPERIOD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_CURRYEAR]  DEFAULT (datepart(year,getdate())) FOR [CURRYEARNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_RUNNO_2]  DEFAULT ((1)) FOR [RUNNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PERIODPAYMENT]  DEFAULT ('') FOR [PERIODPAYMENT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_TAXYEARENDDATE]  DEFAULT (getdate()) FOR [TAXYEARENDDATE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PAYSLIPSASP]  DEFAULT ('') FOR [PAYSLIPSASP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_CHEQUESASP]  DEFAULT ('') FOR [CHEQUESASP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IRP5ASP]  DEFAULT ('') FOR [IRP5ASP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_IT3ASP]  DEFAULT ('') FOR [IT3ASP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_BANKID]  DEFAULT ((-1)) FOR [BANKID]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PADEMP]  DEFAULT ((10)) FOR [PADEMP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PADEDS]  DEFAULT ((5)) FOR [PADEDS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__LABELS__19B5BC39]  DEFAULT ('') FOR [LABELSASP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SYNCPA__298471B3]  DEFAULT ((0)) FOR [SYNCPAYPOINTS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MINYEA__3C2D31D3]  DEFAULT ((0)) FOR [MINYEAREARNUIFDEDU]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_NEGCALC]  DEFAULT ((0)) FOR [NEGCALC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_FLFACTOR]  DEFAULT ((1)) FOR [FLFACTOR]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ALLOWEXTCDC]  DEFAULT ((0)) FOR [ALLOWEXTCDC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ALLOWTPP]  DEFAULT ((0)) FOR [ALLOWTPP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_MAXWEEKNTHOURS]  DEFAULT ((0)) FOR [MAXWEEKNTHOURS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ALLOWEXTDIV]  DEFAULT ((0)) FOR [ALLOWEXTDIV]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ALLOWEXTPE]  DEFAULT ((0)) FOR [ALLOWEXTPE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFAULTPT]  DEFAULT ('Hourly') FOR [DEFAULTPT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_SPLITMACALCS]  DEFAULT ((1)) FOR [SPLITMACALCS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_PRLSPEC]  DEFAULT ('South Africa') FOR [PRLSPEC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_USEINTPAYMENTS]  DEFAULT ((0)) FOR [USEINTPAYMENTS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ZAMPEN__07E1F018]  DEFAULT ((0)) FOR [ZAMPENNONTAX]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_EMPLOYEES_SERVCERTASP]  DEFAULT ('') FOR [SERVCERTASP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_EMPLOYEES_IGNOREEMPNOHOURS]  DEFAULT ((0)) FOR [IGNOREEMPNOHOURS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_EMPLOYEES_NETTWARNAMOUNT]  DEFAULT ((1000000)) FOR [NETTWARNAMOUNT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_FIRSTMACAP]  DEFAULT ((530)) FOR [FIRSTMACAP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_SECONDMACAP]  DEFAULT ((320)) FOR [SECONDMACAP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_NAMMACOPERC]  DEFAULT ((70)) FOR [NAMMACOPERC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_NAMMAEMPPERC]  DEFAULT ((30)) FOR [NAMMAEMPPERC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_AUTOADJTCP]  DEFAULT ((0)) FOR [AUTOADJTCP]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_HOURSPERSHIFT]  DEFAULT ((0)) FOR [HOURSPERSHIFT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCNTCONTR]  DEFAULT ('') FOR [DEFLCNTCONTR]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCOTCONTR]  DEFAULT ('') FOR [DEFLCOTCONTR]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCNTPLANT]  DEFAULT ('') FOR [DEFLCNTPLANT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCOTPLANT]  DEFAULT ('') FOR [DEFLCOTPLANT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCNTOH]  DEFAULT ('') FOR [DEFLCNTOH]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCOTOH]  DEFAULT ('') FOR [DEFLCOTOH]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCNTBS]  DEFAULT ('') FOR [DEFLCNTBS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_DEFLCOTBS]  DEFAULT ('') FOR [DEFLCOTBS]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__PTINNO__3EC810AE]  DEFAULT ('') FOR [PTINNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ALLOWDEFPOSTING]  DEFAULT ((0)) FOR [ALLOWDEFPOSTING]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_SMOOTHTAX]  DEFAULT ((0)) FOR [SMOOTHTAX]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ANNZAM__611D28B2]  DEFAULT ((1)) FOR [ANNZAMTAX]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SURCHA__6B9AB725]  DEFAULT ((1000000)) FOR [SURCHARGELEVEL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SURCHA__6C8EDB5E]  DEFAULT ((10)) FOR [SURCHARGEP1]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SURCHA__6D82FF97]  DEFAULT ((3)) FOR [SURCHARGEP2]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__OTCOST__0A5513C6]  DEFAULT ((1)) FOR [OTCOST]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HRSPEC__0B4937FF]  DEFAULT ('') FOR [HRSPEC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__OTRATE__1C73C401]  DEFAULT ((1)) FOR [OTRATERECALC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__APPRTN__26BD13A1]  DEFAULT ((0)) FOR [APPRTNA]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__CALCSP__2458D59E]  DEFAULT ((1)) FOR [CALCSPERCCLI]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__DECPLA__48963614]  DEFAULT ((2)) FOR [DECPLACES]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HOMEOR__4F4333A3]  DEFAULT ('') FOR [HOMEORGCODE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HOMEOR__503757DC]  DEFAULT ('') FOR [HOMEORGNUMBER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__THIRTY__512B7C15]  DEFAULT ((0)) FOR [THIRTYDAYSINMONTH]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SHOWYT__6AEB4E18]  DEFAULT ((0)) FOR [SHOWYTDVALUES]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOWE__6BDF7251]  DEFAULT ((1)) FOR [ALLOWEMPADD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOWE__6CD3968A]  DEFAULT ((1)) FOR [ALLOWEMPTERM]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_CURRENCY]  DEFAULT ('') FOR [CURRENCY]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HRSERV__7692D645]  DEFAULT ('') FOR [HRSERVER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HRDBNA__7786FA7E]  DEFAULT ('') FOR [HRDBNAME]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HRUSER__787B1EB7]  DEFAULT ('') FOR [HRUSERID]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__HRPASS__796F42F0]  DEFAULT ('') FOR [HRPASSWORD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__CONTRB__7A636729]  DEFAULT ((0)) FOR [CONTRBONBASICAMOUNT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXNUM__7B578B62]  DEFAULT ((0)) FOR [MAXNUMBERINCREMENT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__YEARIN__7C4BAF9B]  DEFAULT ((0)) FOR [YEARINCREASEAMOUNT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SHOWAB__7D3FD3D4]  DEFAULT ((0)) FOR [SHOWABSALONMANUAL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOW3__7E33F80D]  DEFAULT ((0)) FOR [ALLOW3MAVRG]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOW6__7F281C46]  DEFAULT ((0)) FOR [ALLOW6MAVRG]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOW1__001C407F]  DEFAULT ((0)) FOR [ALLOW12MAVRG]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__INDUST__011064B8]  DEFAULT ('Construction') FOR [INDUSTRYSPEC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__020488F1]  DEFAULT ((0)) FOR [ENABLEABSALMANUAL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ISMIBF__02F8AD2A]  DEFAULT ((0)) FOR [ISMIBFAACTIVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENFORC__03ECD163]  DEFAULT ((0)) FOR [ENFORCEWCATYPE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOWT__52206BA5]  DEFAULT ((1)) FOR [ALLOWTNAEXPORT]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__CLEARD__6903D0FD]  DEFAULT ((0)) FOR [CLEARDIRECTIVENUMBER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_USECCSHIFTSTOACCA]  DEFAULT ('') FOR [USECCSHIFTSTOACCA]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ISHRTE__35050A0A]  DEFAULT ((0)) FOR [ISHRTEMPDISABLED]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ALLOW2__0600025E]  DEFAULT ((0)) FOR [ALLOW2MAVRG]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXPIL__21A81CD3]  DEFAULT ((0)) FOR [MAXPILLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXCMP__229C410C]  DEFAULT ((0)) FOR [MAXCMPSSLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXUPI__23906545]  DEFAULT ((0)) FOR [MAXUPILLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXUMA__2484897E]  DEFAULT ((0)) FOR [MAXUMATLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXMAT__2578ADB7]  DEFAULT ((0)) FOR [MAXMATLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXINJ__266CD1F0]  DEFAULT ((0)) FOR [MAXINJURYLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXPHL__2760F629]  DEFAULT ((0)) FOR [MAXPHLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXICL__28551A62]  DEFAULT ((0)) FOR [MAXICLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXSLL__29493E9B]  DEFAULT ((0)) FOR [MAXSLLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXVPL__2A3D62D4]  DEFAULT ((0)) FOR [MAXVPLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXVUL__2B31870D]  DEFAULT ((0)) FOR [MAXVULEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__MAXULL__2C25AB46]  DEFAULT ((0)) FOR [MAXULLEAVE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SKIPJO__2D19CF7F]  DEFAULT ((0)) FOR [SKIPJOURNALSPOSTING]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__TAXREG__2E0DF3B8]  DEFAULT ('') FOR [TAXREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__2F0217F1]  DEFAULT ((0)) FOR [ENABLETAXREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__STAMPR__2FF63C2A]  DEFAULT ('') FOR [STAMPREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__30EA6063]  DEFAULT ((0)) FOR [ENABLESTAMPREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__UIFREG__31DE849C]  DEFAULT ('') FOR [UIFREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__32D2A8D5]  DEFAULT ((0)) FOR [ENABLEUIFREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__SDLREG__33C6CD0E]  DEFAULT ('') FOR [SDLREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__34BAF147]  DEFAULT ((0)) FOR [ENABLESDLREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__RSCREG__35AF1580]  DEFAULT ('') FOR [RSCREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__36A339B9]  DEFAULT ((0)) FOR [ENABLERSCREGNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__UIFREF__37975DF2]  DEFAULT ('') FOR [UIFREFERENCENUMBER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__388B822B]  DEFAULT ((0)) FOR [ENABLEUIFREFERENCENUMBER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__TNAXML__397FA664]  DEFAULT ('') FOR [TNAXMLURL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__3A73CA9D]  DEFAULT ((0)) FOR [ENABLETNAXMLURL]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__COSOCS__3E445B81]  DEFAULT ('') FOR [COSOCSECNO]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__3F387FBA]  DEFAULT ((0)) FOR [ENABLESOCIALSECURITY]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__FIRMNU__402CA3F3]  DEFAULT ('') FOR [FIRMNUMBER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__4120C82C]  DEFAULT ((0)) FOR [ENABLEFIRMNUMMIBFA]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__TRDCLA__4214EC65]  DEFAULT ('') FOR [TRDCLASSIFICATION]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__4309109E]  DEFAULT ((0)) FOR [ENABLETRADECLASSIFICATION]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRUN__43FD34D7]  DEFAULT ('') FOR [ADDRUNITNUM]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__44F15910]  DEFAULT ((0)) FOR [ENABLEUNITNUM]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__45E57D49]  DEFAULT ((0)) FOR [ENABLECOMPLEX]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRCO__46D9A182]  DEFAULT ('') FOR [ADDRCOMPLEX]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRST__47CDC5BB]  DEFAULT ('') FOR [ADDRSTREETNUM]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__48C1E9F4]  DEFAULT ((0)) FOR [ENABLESTREETNUM]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRST__49B60E2D]  DEFAULT ('') FOR [ADDRSTREET]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__4AAA3266]  DEFAULT ((0)) FOR [ENABLESTREET]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRSU__4B9E569F]  DEFAULT ('') FOR [ADDRSUBURB]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__4C927AD8]  DEFAULT ((0)) FOR [ENABLESUBURB]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRCI__4D869F11]  DEFAULT ('') FOR [ADDRCITY]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__4E7AC34A]  DEFAULT ((0)) FOR [ENABLECITY]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ADDRPO__4F6EE783]  DEFAULT ('') FOR [ADDRPOSTALCODE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__ENABLE__50630BBC]  DEFAULT ((0)) FOR [ENABLEPOSTALCODE]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__LEAVEP__683A954D]  DEFAULT ((0)) FOR [LEAVEPAYDATEDRIVEN]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__CONTAC__72B823C0]  DEFAULT ('') FOR [CONTACTPERSON]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF__PAYROLLS__CONTAC__73AC47F9]  DEFAULT ('') FOR [CONTACTNUMBER]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ENABLEWORKFLOWCC]  DEFAULT (N'0') FOR [ENABLEWORKFLOWCC]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ENABLEWORKFLOWAA]  DEFAULT (N'0') FOR [ENABLEWORKFLOWAA]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ENABLEWORKFLOWLD]  DEFAULT (N'0') FOR [ENABLEWORKFLOWLD]
ALTER TABLE [dbo].[PAYROLLS] ADD  CONSTRAINT [DF_PAYROLLS_ENABLEWORKFLOWSD]  DEFAULT (N'0') FOR [ENABLEWORKFLOWSD]
ALTER TABLE [dbo].[PAYROLLS]  WITH CHECK ADD  CONSTRAINT [FK_PAYROLLS_BORGS] FOREIGN KEY([BORGID])
REFERENCES [dbo].[BORGS] ([BORGID])
ALTER TABLE [dbo].[PAYROLLS] CHECK CONSTRAINT [FK_PAYROLLS_BORGS]