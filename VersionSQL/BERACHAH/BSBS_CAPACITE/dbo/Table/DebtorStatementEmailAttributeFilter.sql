/****** Object:  Table [dbo].[DebtorStatementEmailAttributeFilter]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DebtorStatementEmailAttributeFilter](
	[AttributeFilterId] [int] IDENTITY(1,1) NOT NULL,
	[DebtorStatementEmailId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[FromName] [nvarchar](50) NULL,
	[ToName] [nvarchar](50) NULL,
	[Exist] [nvarchar](50) NULL,
	[AttributeType] [nvarchar](50) NULL,
	[Size] [nvarchar](50) NULL,
 CONSTRAINT [PK_DebtorStatementEmailAttributeFilter] PRIMARY KEY CLUSTERED 
(
	[AttributeFilterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]