/****** Object:  Table [dbo].[DEBTRECONSHIST]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEBTRECONSHIST](
	[ReconHistID] [int] IDENTITY(1,1) NOT NULL,
	[OrgID] [int] NOT NULL,
	[SubConNumber] [char](10) NULL,
	[Contract] [char](10) NULL,
	[Activity] [char](10) NULL,
	[ValNo] [numeric](18, 0) NULL,
	[Certno] [numeric](18, 0) NULL,
	[ContValue] [money] NULL,
	[WorkDoneTot] [money] NULL,
	[WorkDonePrev] [money] NULL,
	[WorkDoneThisMonth] [money] NULL,
	[EscalationTot] [money] NULL,
	[EscalationPrev] [money] NULL,
	[EscalationThisMonth] [money] NULL,
	[MOSTot] [money] NULL,
	[MOSPrev] [money] NULL,
	[MOSThisMonth] [money] NULL,
	[AdvanceTot] [money] NULL,
	[AdvancePrev] [money] NULL,
	[AdvanceThisMonth] [money] NULL,
	[AdditionalTot] [money] NULL,
	[AdditionalPrev] [money] NULL,
	[AdditionalThisMonth] [money] NULL,
	[BFWDTot] [money] NULL,
	[BFWDPrev] [money] NULL,
	[BFWDThisMonth] [money] NULL,
	[VATTot] [money] NULL,
	[VATPrev] [money] NULL,
	[VATThisMonth] [money] NULL,
	[DiscountTot] [money] NULL,
	[DiscountPrev] [money] NULL,
	[DiscountThisMonth] [money] NULL,
	[RetentionTot] [money] NULL,
	[RetentionPrev] [money] NULL,
	[RetentionThisMonth] [money] NULL,
	[ContraTot] [money] NULL,
	[ContraPrev] [money] NULL,
	[ContraThisMonth] [money] NULL,
	[WithholdTot] [money] NULL,
	[WithholdPrev] [money] NULL,
	[WithholdThisMonth] [money] NULL,
	[WithholdPerc] [decimal](18, 4) NULL,
	[AmountDue] [money] NULL,
	[PrevPaid] [money] NULL,
	[TotDue] [money] NULL,
	[VATPerc] [decimal](18, 4) NULL,
	[VATAmount] [money] NULL,
	[Paid] [money] NULL,
	[Name] [char](10) NULL,
	[SupName] [nvarchar](127) NOT NULL,
	[Code] [char](10) NULL,
	[Credno] [char](10) NULL,
	[Ret1] [money] NULL,
	[Ret2] [money] NULL,
	[RCo1] [money] NULL,
	[RCo2] [money] NULL,
	[Disc] [money] NULL,
	[Posted] [bit] NULL,
	[LPosted] [bit] NULL,
	[Printed] [bit] NULL,
	[SCType] [char](10) NULL,
	[VATno] [char](10) NULL,
	[Remark] [char](200) NULL,
	[GLCode] [char](10) NULL,
	[ReconID] [int] NOT NULL,
	[UserID] [nvarchar](15) NOT NULL,
	[PostDate] [datetime] NULL,
	[PostRef] [char](10) NULL,
	[Orderno] [nvarchar](35) NULL,
	[Interest] [money] NULL,
	[InterestTot] [money] NULL,
	[Currency] [char](3) NOT NULL,
	[Exchrate] [float] NOT NULL,
	[Contrexchrate] [float] NOT NULL,
	[DomTot] [money] NULL,
	[DomThisMonth] [money] NULL,
	[DomPrev] [money] NULL,
	[NomTot] [money] NULL,
	[NomThisMonth] [money] NULL,
	[NomPrev] [money] NULL,
	[DirTot] [money] NULL,
	[DirThisMonth] [money] NULL,
	[DirPrev] [money] NULL,
	[FltTot] [money] NULL,
	[FltThisMonth] [money] NULL,
	[FltPrev] [money] NULL,
	[VALDONETOT] [money] NOT NULL,
	[VALDONEPREV] [money] NOT NULL,
	[VALDONETHISMONTH] [money] NOT NULL,
	[MARGIN] [money] NOT NULL,
	[VATONADV] [money] NOT NULL,
	[VATONWDONE] [money] NOT NULL,
	[RETPERC] [decimal](18, 4) NOT NULL,
	[WithholdAMOUNT] [money] NOT NULL,
	[DRAPPROVER] [int] NULL,
	[DRAPPDATE] [datetime] NULL,
	[DRPOSTBY] [int] NULL,
	[DRPOSTDATE] [datetime] NULL,
	[VatType] [nvarchar](100) NULL,
	[WithholdID] [int] NULL,
	[CERTNOPREV] [numeric](18, 0) NULL,
	[FROMDATE] [datetime] NULL,
	[BOQPOSTDETAIL] [bit] NOT NULL,
	[LEDGER] [char](10) NULL,
	[RETRELEASEDATE] [datetime] NULL,
	[OVERRIDETAX] [int] NOT NULL,
	[OVERRIDEWHT] [int] NOT NULL,
	[WFVALUEAPPROVED] [bit] NOT NULL,
	[SUBMITTED] [bit] NOT NULL,
	[APPROVED] [bit] NOT NULL,
	[REJECTED] [bit] NOT NULL,
	[LOGUSERID] [int] NOT NULL,
	[LOGDATETIME] [datetime] NOT NULL,
	[INTERESTPREV] [money] NOT NULL,
	[ADVANCEPERC] [decimal](18, 4) NOT NULL,
	[CLASSID] [int] NOT NULL,
 CONSTRAINT [PK_DEBTRECONSHIST] PRIMARY KEY CLUSTERED 
(
	[ReconHistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_ContValue]  DEFAULT ((0)) FOR [ContValue]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WorkDoneTot]  DEFAULT ((0)) FOR [WorkDoneTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WorkDonePrev]  DEFAULT ((0)) FOR [WorkDonePrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WorkDoneThisMonth]  DEFAULT ((0)) FOR [WorkDoneThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_EscalationTot]  DEFAULT ((0)) FOR [EscalationTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_EscalationPrev]  DEFAULT ((0)) FOR [EscalationPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_EscalationThisMonth]  DEFAULT ((0)) FOR [EscalationThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_MOSTot]  DEFAULT ((0)) FOR [MOSTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_MOSPrev]  DEFAULT ((0)) FOR [MOSPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_MOSThisMonth]  DEFAULT ((0)) FOR [MOSThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AdvanceTot]  DEFAULT ((0)) FOR [AdvanceTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AdvancePrev]  DEFAULT ((0)) FOR [AdvancePrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AdvanceThisMonth]  DEFAULT ((0)) FOR [AdvanceThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AdditionalTot]  DEFAULT ((0)) FOR [AdditionalTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AdditionalPrev]  DEFAULT ((0)) FOR [AdditionalPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AdditionalThisMonth]  DEFAULT ((0)) FOR [AdditionalThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_BFWDTot]  DEFAULT ((0)) FOR [BFWDTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_BFWDPrev]  DEFAULT ((0)) FOR [BFWDPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_BFWDThisMonth]  DEFAULT ((0)) FOR [BFWDThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATTot]  DEFAULT ((0)) FOR [VATTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATPrev]  DEFAULT ((0)) FOR [VATPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATThisMonth]  DEFAULT ((0)) FOR [VATThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DiscountTot]  DEFAULT ((0)) FOR [DiscountTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DiscountPrev]  DEFAULT ((0)) FOR [DiscountPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DiscountThisMonth]  DEFAULT ((0)) FOR [DiscountThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_RetentionTot]  DEFAULT ((0)) FOR [RetentionTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_RetentionPrev]  DEFAULT ((0)) FOR [RetentionPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_RetentionThisMonth]  DEFAULT ((0)) FOR [RetentionThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_ContraTot]  DEFAULT ((0)) FOR [ContraTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_ContraPrev]  DEFAULT ((0)) FOR [ContraPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_ContraThisMonth]  DEFAULT ((0)) FOR [ContraThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WithholdTot]  DEFAULT ((0)) FOR [WithholdTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WithholdPrev]  DEFAULT ((0)) FOR [WithholdPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WithholdThisMonth]  DEFAULT ((0)) FOR [WithholdThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WithholdPerc]  DEFAULT ((0)) FOR [WithholdPerc]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_AmountDue]  DEFAULT ((0)) FOR [AmountDue]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_PrevPaid]  DEFAULT ((0)) FOR [PrevPaid]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_TotDue]  DEFAULT ((0)) FOR [TotDue]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATPerc]  DEFAULT ((0)) FOR [VATPerc]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATAmount]  DEFAULT ((0)) FOR [VATAmount]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Paid]  DEFAULT ((0)) FOR [Paid]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_SUPNAME]  DEFAULT ('') FOR [SupName]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Ret1]  DEFAULT ((0)) FOR [Ret1]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Ret2]  DEFAULT ((0)) FOR [Ret2]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_RCo1]  DEFAULT ((0)) FOR [RCo1]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_RCo2]  DEFAULT ((0)) FOR [RCo2]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Disc]  DEFAULT ((0)) FOR [Disc]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Posted]  DEFAULT (N'0') FOR [Posted]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_LPosted]  DEFAULT (N'0') FOR [LPosted]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Printed]  DEFAULT (N'0') FOR [Printed]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_UserID]  DEFAULT ('') FOR [UserID]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Interest]  DEFAULT ((0)) FOR [Interest]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_InterestTot]  DEFAULT ((0)) FOR [InterestTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Currency]  DEFAULT (N'ZAR') FOR [Currency]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Exchrate]  DEFAULT ((0)) FOR [Exchrate]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_Contrexchrate]  DEFAULT ((0)) FOR [Contrexchrate]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DomTot]  DEFAULT ((0)) FOR [DomTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DomThisMonth]  DEFAULT ((0)) FOR [DomThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DomPrev]  DEFAULT ((0)) FOR [DomPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_NomTot]  DEFAULT ((0)) FOR [NomTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_NomThisMonth]  DEFAULT ((0)) FOR [NomThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_NomPrev]  DEFAULT ((0)) FOR [NomPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DirTot]  DEFAULT ((0)) FOR [DirTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DirThisMonth]  DEFAULT ((0)) FOR [DirThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DirPrev]  DEFAULT ((0)) FOR [DirPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_FltTot]  DEFAULT ((0)) FOR [FltTot]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_FltThisMonth]  DEFAULT ((0)) FOR [FltThisMonth]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_FltPrev]  DEFAULT ((0)) FOR [FltPrev]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VALDONETOT]  DEFAULT ((0)) FOR [VALDONETOT]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VALDONEPREV]  DEFAULT ((0)) FOR [VALDONEPREV]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VALDONETHISMONTH]  DEFAULT ((0)) FOR [VALDONETHISMONTH]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_MARGIN]  DEFAULT ((0)) FOR [MARGIN]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATONADV]  DEFAULT ((0)) FOR [VATONADV]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VATONWDONE]  DEFAULT ((0)) FOR [VATONWDONE]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_RETPERC]  DEFAULT ((0)) FOR [RETPERC]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WithholdAMOUNT]  DEFAULT ((0)) FOR [WithholdAMOUNT]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DRAPPROVER]  DEFAULT ((-1)) FOR [DRAPPROVER]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DRAPPDATE]  DEFAULT (getdate()) FOR [DRAPPDATE]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DRPOSTBY]  DEFAULT ((-1)) FOR [DRPOSTBY]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_DRPOSTDATE]  DEFAULT (getdate()) FOR [DRPOSTDATE]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_VatType]  DEFAULT ('') FOR [VatType]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_BOQPOSTDETAIL]  DEFAULT (N'0') FOR [BOQPOSTDETAIL]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_OVERRIDETAX]  DEFAULT ((0)) FOR [OVERRIDETAX]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_OVERRIDEWHT]  DEFAULT ((0)) FOR [OVERRIDEWHT]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_WFVALUEAPPROVED]  DEFAULT (N'0') FOR [WFVALUEAPPROVED]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_SUBMITTED]  DEFAULT (N'0') FOR [SUBMITTED]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_APPROVED]  DEFAULT (N'0') FOR [APPROVED]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_REJECTED]  DEFAULT (N'0') FOR [REJECTED]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_LOGUSERID]  DEFAULT ((-1)) FOR [LOGUSERID]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_LOGDATETIME]  DEFAULT (getdate()) FOR [LOGDATETIME]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_INTERESTPREV]  DEFAULT ((0)) FOR [INTERESTPREV]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_ADVANCEPERC]  DEFAULT ((0)) FOR [ADVANCEPERC]
ALTER TABLE [dbo].[DEBTRECONSHIST] ADD  CONSTRAINT [DF_DEBTRECONSHIST_CLASSID]  DEFAULT ((-1)) FOR [CLASSID]