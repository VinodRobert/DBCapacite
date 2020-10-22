/****** Object:  Table [dbo].[PlantServiceLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantServiceLog](
	[SLID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SLFromWhere] [char](10) NOT NULL,
	[SLFromWhereID] [char](10) NOT NULL,
	[SLDesc] [nchar](25) NOT NULL,
	[SLPeNumber] [char](10) NOT NULL,
	[SLServiceType] [char](25) NULL,
	[SLPervSMR] [numeric](18, 4) NULL,
	[SLNextSMR] [numeric](18, 4) NULL,
	[SLDate] [datetime] NULL,
	[SLPrevServSMR] [numeric](18, 4) NULL,
	[SLServInterval] [numeric](18, 4) NULL,
	[SLNextServSMR] [numeric](18, 4) NULL,
	[SLServIncrementLimit] [numeric](18, 4) NULL,
	[SLDateOfTrans] [datetime] NOT NULL,
	[SLHeadID] [char](10) NULL,
	[SLPrefID] [int] NULL,
 CONSTRAINT [PK_PlantServiceLag] PRIMARY KEY CLUSTERED 
(
	[SLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantServiceLog] ADD  CONSTRAINT [DF_PlantServiceLog_SLDateOfTrans]  DEFAULT (getdate()) FOR [SLDateOfTrans]