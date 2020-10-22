/****** Object:  Table [dbo].[EMPEDSETT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPEDSETT](
	[PRLID] [int] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[EDSNUMBER] [nvarchar](5) NOT NULL,
	[EDSCODE] [nvarchar](5) NOT NULL,
	[EDSHID] [int] NOT NULL,
	[USEIT] [bit] NOT NULL,
	[OVERRITE] [decimal](18, 4) NOT NULL,
	[EMPEDSETTID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[STARTINMONTH] [smallint] NOT NULL,
 CONSTRAINT [PK_EMPEDSETT] PRIMARY KEY CLUSTERED 
(
	[PRLID] ASC,
	[EMPNUMBER] ASC,
	[EDSNUMBER] ASC,
	[EDSHID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPEDSETT] ADD  CONSTRAINT [DF_EMPEDSETT_USEIT]  DEFAULT (1) FOR [USEIT]
ALTER TABLE [dbo].[EMPEDSETT] ADD  CONSTRAINT [DF_EMPEDSETT_OVERRITE]  DEFAULT (0) FOR [OVERRITE]
ALTER TABLE [dbo].[EMPEDSETT] ADD  CONSTRAINT [DF_EMPEDSETT_STARTINMONTH]  DEFAULT ((0)) FOR [STARTINMONTH]