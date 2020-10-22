/****** Object:  Table [dbo].[PlantMeterNumber]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantMeterNumber](
	[PltMPeNamber] [char](10) NOT NULL,
	[PltMeterNum] [int] NOT NULL,
	[PltMUnit] [char](10) NOT NULL,
	[PltMReplaceDate] [datetime] NOT NULL,
	[PltMReplaceReading] [numeric](18, 4) NOT NULL,
	[PlrMRemarks] [char](50) NULL,
 CONSTRAINT [PK_PlantMeterNumber] PRIMARY KEY CLUSTERED 
(
	[PltMPeNamber] ASC,
	[PltMeterNum] ASC,
	[PltMUnit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantMeterNumber] ADD  CONSTRAINT [DF_PlantMeterNumber_PltMReplaceReading]  DEFAULT ('0') FOR [PltMReplaceReading]
ALTER TABLE [dbo].[PlantMeterNumber]  WITH CHECK ADD  CONSTRAINT [FK_PlantMeterNumber_PLANTANDEQ] FOREIGN KEY([PltMPeNamber])
REFERENCES [dbo].[PLANTANDEQ] ([PeNumber])
ON UPDATE CASCADE
ALTER TABLE [dbo].[PlantMeterNumber] CHECK CONSTRAINT [FK_PlantMeterNumber_PLANTANDEQ]