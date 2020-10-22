/****** Object:  Table [dbo].[PERIODENDDATES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PERIODENDDATES](
	[PERIODNO] [smallint] NOT NULL,
	[YEARNO] [smallint] NOT NULL,
	[PENDDATE] [datetime] NOT NULL,
	[PAYROLLID] [int] NOT NULL,
 CONSTRAINT [PK_PERIODENDDATES] PRIMARY KEY CLUSTERED 
(
	[PERIODNO] ASC,
	[YEARNO] ASC,
	[PAYROLLID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PERIODENDDATES]  WITH CHECK ADD  CONSTRAINT [FK_PERIODENDDATES_PAYROLLS] FOREIGN KEY([PAYROLLID])
REFERENCES [dbo].[PAYROLLS] ([PAYROLLID])
ALTER TABLE [dbo].[PERIODENDDATES] CHECK CONSTRAINT [FK_PERIODENDDATES_PAYROLLS]