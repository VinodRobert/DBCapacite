/****** Object:  Table [dbo].[SWIFT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SWIFT](
	[SWIFTCODE] [nvarchar](50) NOT NULL,
	[BRANCHNAME] [nvarchar](150) NULL,
	[BANK] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_SWIFT] PRIMARY KEY CLUSTERED 
(
	[SWIFTCODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]