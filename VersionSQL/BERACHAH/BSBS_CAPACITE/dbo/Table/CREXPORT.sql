/****** Object:  Table [dbo].[CREXPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CREXPORT](
	[PH_1] [varchar](8) NULL,
	[PH_2] [varchar](7) NULL,
	[PH_3] [varchar](9) NULL,
	[PH_4] [varchar](10) NULL,
	[PH_5] [varchar](11) NULL,
	[PH_6] [varchar](4) NULL,
	[PH_7] [varchar](8) NULL,
	[PH_8] [varchar](5) NULL,
	[PH_9] [varchar](5) NULL,
	[PH_10] [varchar](6) NULL,
	[PH_11] [varchar](7) NULL,
	[PH_12] [varchar](7) NULL,
	[PH_13] [varchar](9) NULL,
	[PH_14] [varchar](9) NULL,
	[PH_15] [varchar](11) NULL,
	[DE_SUPPLIER] [varchar](11) NULL,
	[DE_SUPPLIERNAME] [varchar](56) NULL,
	[DE_BORGNAME] [varchar](151) NULL,
	[DE_TRANSTYPE] [varchar](4) NULL,
	[DE_INVOCIENUMBER] [varchar](11) NULL,
	[DE_INVOICEDATE] [datetime] NULL,
	[DE_OUTSTANDINGAMOUNT] [float] NULL,
	[DE_PERIOD] [int] NULL,
	[DE_Current] [float] NULL,
	[DE_Thirty] [float] NULL,
	[DE_Ninety] [float] NULL,
	[DE_OneTwenty] [float] NULL,
	[DE_OneFifty] [float] NULL,
	[DE_OneEighty] [float] NULL,
	[DE_Above180] [float] NULL,
	[GF2_1] [varchar](9) NULL,
	[GF2_Sum_OUTSTANDINGAMOUNT] [float] NULL,
	[GF2_Sum_Current] [float] NULL,
	[GF2_Sum_Thirty] [float] NULL,
	[GF2_Sum_Ninety] [float] NULL,
	[GF2_Sum_OneTwenty] [float] NULL,
	[GF2_Sum_OneFifty] [float] NULL,
	[GF2_Sum_OneEighty] [float] NULL,
	[GF2_Sum_Above180] [float] NULL,
	[GF2_TOTALPAID] [float] NULL,
	[GF2_BorgOutStanding] [float] NULL,
	[GF1_1] [varchar](6) NULL,
	[GF1_Sum_OUTSTANDINGAMOUNT] [float] NULL,
	[GF1_Sum_Current] [float] NULL,
	[GF1_Sum_Thirty] [float] NULL,
	[GF1_Sum_Ninety] [float] NULL,
	[GF1_Sum_OneTwenty] [float] NULL,
	[GF1_Sum_OneFifty] [float] NULL,
	[GF1_Sum_OneEighty] [float] NULL,
	[GF1_Sum_Above180] [float] NULL,
	[GF1_TOTALPAID] [float] NULL,
	[GF1_TotBorgOutstanding] [float] NULL,
	[PF_PageNofM] [varchar](255) NULL,
	[PF_PrintDate] [datetime] NULL,
	[PF_PrintTime] [datetime] NULL
) ON [PRIMARY]