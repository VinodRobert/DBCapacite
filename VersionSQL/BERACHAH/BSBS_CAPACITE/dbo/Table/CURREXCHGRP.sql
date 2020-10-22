/****** Object:  Table [dbo].[CURREXCHGRP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CURREXCHGRP](
	[GROUPID] [decimal](23, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DESCR] [nvarchar](60) NOT NULL,
	[DISABLED] [bit] NOT NULL,
 CONSTRAINT [PK_CURREXCHGRP] PRIMARY KEY NONCLUSTERED 
(
	[GROUPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]