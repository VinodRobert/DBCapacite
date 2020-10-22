/****** Object:  Table [dbo].[RoleAudit]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RoleAudit](
	[Type] [char](1) NULL,
	[TableName] [varchar](128) NULL,
	[PK] [varchar](1000) NULL,
	[FieldName] [varchar](128) NULL,
	[OldValue] [varchar](1000) NULL,
	[NewValue] [varchar](1000) NULL,
	[UpdateDate] [datetime] NULL,
	[UserName] [varchar](128) NULL
) ON [PRIMARY]