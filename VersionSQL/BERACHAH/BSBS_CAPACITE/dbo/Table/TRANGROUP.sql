/****** Object:  Table [dbo].[TRANGROUP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TRANGROUP](
	[TRANGRP] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[TRANGROUP] ADD  CONSTRAINT [DF_TRANGROUP_TRANGRP]  DEFAULT ('-1') FOR [TRANGRP]