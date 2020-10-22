/****** Object:  Table [dbo].[PlantHireAdditional]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireAdditional](
	[HireAID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HireHNumber] [char](10) NOT NULL,
	[ActNumber] [char](10) NULL,
	[HireAGlCode] [char](10) NULL,
	[VatID] [char](10) NOT NULL,
	[HireADate] [datetime] NOT NULL,
	[HireADescription] [char](200) NOT NULL,
	[HireAUnit] [char](4) NOT NULL,
	[HireAQuantity] [numeric](18, 4) NOT NULL,
	[HiteARate] [money] NOT NULL,
	[HireAAmount] [money] NOT NULL,
	[HireADiscount] [money] NOT NULL,
	[HireAVatAmount] [money] NOT NULL,
	[HireATotAmount] [money] NOT NULL,
	[HireAFlagID] [int] NOT NULL,
	[HireAInvoiceNumber] [char](10) NULL,
	[OVERRIDEGL] [bit] NOT NULL,
	[PLANTNO] [nvarchar](10) NOT NULL,
	[POSTUSERID] [int] NOT NULL,
	[POSTDATE] [datetime] NULL,
	[REVENUEGL] [char](10) NULL,
 CONSTRAINT [PK_PlantHireAdditional] PRIMARY KEY CLUSTERED 
(
	[HireAID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireAdditional] ADD  CONSTRAINT [DF_PlantHireAdditional_HireAQuantity]  DEFAULT ('0') FOR [HireAQuantity]
ALTER TABLE [dbo].[PlantHireAdditional] ADD  CONSTRAINT [DF_PlantHireAdditional_HireAFlagID]  DEFAULT (0) FOR [HireAFlagID]
ALTER TABLE [dbo].[PlantHireAdditional] ADD  CONSTRAINT [DF_PLANTHIREADDITIONAL_OVERRIDEGL]  DEFAULT ('0') FOR [OVERRIDEGL]
ALTER TABLE [dbo].[PlantHireAdditional] ADD  CONSTRAINT [DF_PLANTHIREADDITIONAL_PLANTNO]  DEFAULT ('') FOR [PLANTNO]
ALTER TABLE [dbo].[PlantHireAdditional] ADD  CONSTRAINT [DF_PLANTHIREADDITIONAL_POSTUSERID]  DEFAULT ('0') FOR [POSTUSERID]
ALTER TABLE [dbo].[PlantHireAdditional] ADD  CONSTRAINT [DF_PLANTHIREADDITIONAL_POSTDATE]  DEFAULT (getdate()) FOR [POSTDATE]
ALTER TABLE [dbo].[PlantHireAdditional]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireAdditional_PlantHireHeader] FOREIGN KEY([HireHNumber])
REFERENCES [dbo].[PlantHireHeader] ([HireHNumber])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHireAdditional] CHECK CONSTRAINT [FK_PlantHireAdditional_PlantHireHeader]
ALTER TABLE [dbo].[PlantHireAdditional]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireAdditional_PlantHireReturnsFlag] FOREIGN KEY([HireAFlagID])
REFERENCES [dbo].[PlantHireReturnsFlag] ([HireRPostFlagID])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantHireAdditional] CHECK CONSTRAINT [FK_PlantHireAdditional_PlantHireReturnsFlag]