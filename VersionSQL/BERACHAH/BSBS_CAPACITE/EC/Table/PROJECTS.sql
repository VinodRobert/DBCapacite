/****** Object:  Table [EC].[PROJECTS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [EC].[PROJECTS](
	[BORGID] [int] NOT NULL,
	[BSBORGID] [int] NULL,
	[BSBORGNAME] [varchar](150) NULL,
	[CURRENTFINYEAR] [int] NULL,
	[CUTOFFDATE] [datetime] NULL,
	[FINYEAR] [int] NULL,
	[PERIOD] [int] NULL,
	[LASTTRANGRP] [int] NULL,
	[GSTINID] [int] NULL,
	[STATENAME] [varchar](50) NULL,
	[EC_ENABLED] [int] NULL,
	[EI_ENABLED] [int] NULL,
	[STATECODE] [char](2) NULL,
	[TRANGRP_DEBTOR] [int] NULL,
	[TRANGRP_SUBBIE] [int] NULL,
	[LASTRECON_DEBTOR] [int] NULL,
	[LASTRECON_SUBBIE] [int] NULL,
 CONSTRAINT [PK_PROJECTS_1] PRIMARY KEY CLUSTERED 
(
	[BORGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]