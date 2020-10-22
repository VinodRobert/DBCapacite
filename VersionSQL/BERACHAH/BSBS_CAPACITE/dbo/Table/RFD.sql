/****** Object:  Table [dbo].[RFD]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RFD](
	[RFDID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ORDID] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[REQUIREDDATE] [datetime] NOT NULL,
 CONSTRAINT [PK_RFD] PRIMARY KEY CLUSTERED 
(
	[RFDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RFD]  WITH CHECK ADD  CONSTRAINT [FK_RFD_ORD] FOREIGN KEY([ORDID])
REFERENCES [dbo].[ORD] ([ORDID])
ALTER TABLE [dbo].[RFD] CHECK CONSTRAINT [FK_RFD_ORD]