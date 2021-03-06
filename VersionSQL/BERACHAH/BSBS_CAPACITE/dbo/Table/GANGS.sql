/****** Object:  Table [dbo].[GANGS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GANGS](
	[PKLGANGID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[GANGCODE] [nvarchar](50) NOT NULL,
	[GANGDESCRIPTION] [nvarchar](250) NOT NULL,
	[ISACTIVE] [bit] NOT NULL,
 CONSTRAINT [PK_GANGS] PRIMARY KEY CLUSTERED 
(
	[PKLGANGID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GANGS] ADD  DEFAULT ((1)) FOR [ISACTIVE]