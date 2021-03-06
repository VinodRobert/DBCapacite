/****** Object:  Table [dbo].[BANKRECONHISTORYDETAIL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BANKRECONHISTORYDETAIL](
	[DID] [int] IDENTITY(1,1) NOT NULL,
	[HID] [int] NOT NULL,
	[TRANSID] [int] NOT NULL,
	[PRESENTED] [int] NOT NULL,
 CONSTRAINT [PK_BANKRECONHISTORYDETAIL] PRIMARY KEY CLUSTERED 
(
	[DID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]