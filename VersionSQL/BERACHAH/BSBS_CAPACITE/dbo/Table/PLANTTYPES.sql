/****** Object:  Table [dbo].[PLANTTYPES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANTTYPES](
	[TypeName] [char](25) NOT NULL,
	[IsDebit] [bit] NOT NULL,
	[TypeOppGlCode] [char](10) NULL,
	[TypeOppCost] [char](25) NULL,
	[TypeOppDesc] [char](25) NULL,
	[TypeVAT] [char](2) NULL,
	[TypeJnl] [bit] NOT NULL,
	[TypeDesc] [char](55) NULL,
	[Isplant] [bit] NOT NULL,
	[Isnom] [bit] NOT NULL,
	[Iscred] [bit] NOT NULL,
	[Isdebt] [bit] NOT NULL,
	[Isstock] [bit] NOT NULL,
	[IsSub] [bit] NOT NULL,
	[IsContract] [bit] NOT NULL,
	[ToJoinT] [int] NOT NULL,
	[TypeDefGl] [char](10) NULL,
	[TypeDefAlloc] [char](25) NULL,
	[TypeGLAlloc] [char](25) NULL,
	[TypeGLCode] [char](10) NULL,
	[IsOverheads] [bit] NOT NULL,
 CONSTRAINT [PK_PLANTTYPES] PRIMARY KEY CLUSTERED 
(
	[TypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PLANTTYPES] ADD  DEFAULT (0) FOR [IsOverheads]