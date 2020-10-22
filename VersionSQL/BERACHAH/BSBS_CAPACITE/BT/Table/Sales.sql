/****** Object:  Table [BT].[Sales]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [BT].[Sales](
	[SalesID] [int] NOT NULL,
	[ProjectCode] [int] NULL,
	[BOQNumber] [varchar](20) NULL,
	[BOQ] [varchar](400) NULL,
	[UOM] [varchar](50) NULL,
	[Qty] [decimal](18, 4) NULL,
	[Rate] [decimal](18, 2) NULL,
	[Status] [int] NULL,
	[RevisionID] [decimal](6, 2) NULL,
	[ClientBOQ] [varchar](35) NULL,
	[MajorRevision] [int] NULL,
	[MinorRevision] [int] NULL,
 CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED 
(
	[SalesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [BT].[Sales]  WITH NOCHECK ADD  CONSTRAINT [FK_Sales_Projects1] FOREIGN KEY([ProjectCode])
REFERENCES [BT].[Projects] ([ProjectID])
ALTER TABLE [BT].[Sales] CHECK CONSTRAINT [FK_Sales_Projects1]