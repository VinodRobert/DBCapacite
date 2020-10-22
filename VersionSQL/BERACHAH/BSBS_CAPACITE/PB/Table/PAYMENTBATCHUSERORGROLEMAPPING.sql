/****** Object:  Table [PB].[PAYMENTBATCHUSERORGROLEMAPPING]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [PB].[PAYMENTBATCHUSERORGROLEMAPPING](
	[USERORGROLEID] [int] IDENTITY(1,1) NOT NULL,
	[BSLOGINID] [varchar](15) NULL,
	[BSORGID] [int] NULL,
	[BSProcess] [varchar](10) NULL,
	[APPROVERLEVELID] [int] NULL,
 CONSTRAINT [PK__USERORGR__B6193106D63C76D6] PRIMARY KEY CLUSTERED 
(
	[USERORGROLEID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]