/****** Object:  Table [dbo].[DebtorEmailType]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DebtorEmailType](
	[DebtorEmailTypeId] [int] IDENTITY(1,1) NOT NULL,
	[DebtorEmailType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DebtorEmailType] PRIMARY KEY CLUSTERED 
(
	[DebtorEmailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]