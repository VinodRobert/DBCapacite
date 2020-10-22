/****** Object:  Table [dbo].[PlantHirePublicHolidays]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlantHirePublicHolidays](
	[HirePDID] [int] IDENTITY(1,1) NOT NULL,
	[HirePDDate] [datetime] NULL,
	[HirePDDesc] [char](50) NULL,
	[CuntryCode] [char](10) NULL,
	[DebtNumber] [char](10) NULL,
	[ContrNumber] [nvarchar](10) NULL,
	[HirePDisHoliday] [bit] NULL,
 CONSTRAINT [IX_PlantHirePublicHolidaysNew] UNIQUE NONCLUSTERED 
(
	[HirePDDate] ASC,
	[CuntryCode] ASC,
	[DebtNumber] ASC,
	[ContrNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PlantHirePublicHolidays] ADD  DEFAULT (1) FOR [HirePDisHoliday]