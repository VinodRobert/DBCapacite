/****** Object:  Table [BT].[DPRManpower]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[DPRManpower](
	[DPRID] [int] NOT NULL,
	[ProjectCode] [int] NULL,
	[ManpowerSkillTypeID] [varchar](15) NULL,
	[DPRDate] [datetime] NULL,
	[DPRQty] [decimal](18, 2) NULL
) ON [PRIMARY]