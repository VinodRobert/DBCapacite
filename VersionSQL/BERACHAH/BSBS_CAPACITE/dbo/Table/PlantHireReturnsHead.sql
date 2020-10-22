/****** Object:  Table [dbo].[PlantHireReturnsHead]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHireReturnsHead](
	[HireRNumber] [char](10) NOT NULL,
	[HireHNumber] [char](10) NOT NULL,
	[PeNumber] [char](10) NOT NULL,
 CONSTRAINT [PK_PlantHireReturnsHead] PRIMARY KEY CLUSTERED 
(
	[HireRNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHireReturnsHead]  WITH CHECK ADD  CONSTRAINT [FK_PlantHireReturnsHead_PlantHireDetail] FOREIGN KEY([HireHNumber], [PeNumber])
REFERENCES [dbo].[PlantHireDetail] ([HireHNumber], [PeNumber])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [dbo].[PlantHireReturnsHead] CHECK CONSTRAINT [FK_PlantHireReturnsHead_PlantHireDetail]