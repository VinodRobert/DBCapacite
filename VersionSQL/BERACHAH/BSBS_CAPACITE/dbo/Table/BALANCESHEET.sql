/****** Object:  Table [dbo].[BALANCESHEET]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BALANCESHEET](
	[BSheetID] [int] IDENTITY(1,1) NOT NULL,
	[BSheetSeq] [int] NOT NULL,
	[BSheetDescription] [char](55) NOT NULL,
	[BSheetType] [char](5) NOT NULL,
	[BSheetLastYear] [money] NOT NULL,
	[BsheetThisYear] [money] NOT NULL,
	[BSheetFromGLCode] [char](10) NOT NULL,
	[BSheetToGLCode] [char](10) NOT NULL,
	[BSheetOrgID] [int] NOT NULL,
	[BSheetSumm] [char](10) NOT NULL,
	[BSheetTot] [char](10) NOT NULL,
	[ALLOCATION] [nvarchar](25) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[BALANCESHEET] ADD  CONSTRAINT [DF_BALANCESHEET_ALLOCATION]  DEFAULT ('Balance Sheet') FOR [ALLOCATION]