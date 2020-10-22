/****** Object:  Table [dbo].[IRS1099Code]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IRS1099Code](
	[CodeId] [int] IDENTITY(1,1) NOT NULL,
	[Box] [nvarchar](5) NOT NULL,
	[BoxDescription] [nvarchar](64) NOT NULL,
	[TypeId] [int] NOT NULL
) ON [PRIMARY]