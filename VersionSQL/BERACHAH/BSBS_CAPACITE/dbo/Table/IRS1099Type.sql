/****** Object:  Table [dbo].[IRS1099Type]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IRS1099Type](
	[TypeId] [int] IDENTITY(1,1) NOT NULL,
	[Type1099] [nvarchar](50) NOT NULL,
	[TypeDescription] [nvarchar](64) NOT NULL
) ON [PRIMARY]