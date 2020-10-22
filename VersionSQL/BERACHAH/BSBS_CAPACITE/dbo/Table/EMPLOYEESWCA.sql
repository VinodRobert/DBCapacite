/****** Object:  Table [dbo].[EMPLOYEESWCA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPLOYEESWCA](
	[PRLNUMBER] [nvarchar](10) NOT NULL,
	[PERIODNO] [smallint] NOT NULL,
	[YEARNO] [smallint] NOT NULL,
	[RUNNO] [smallint] NOT NULL,
	[EMPNUMBER] [nvarchar](15) NOT NULL,
	[WCAAMOUNT] [money] NOT NULL,
	[PRLID] [int] NOT NULL,
	[WCATYPE] [char](15) NOT NULL,
	[WCAEARNINGS] [decimal](14, 2) NOT NULL,
	[WCAACTUAL] [decimal](14, 2) NOT NULL,
 CONSTRAINT [PK_EMPLOYEESWC] PRIMARY KEY CLUSTERED 
(
	[PRLNUMBER] ASC,
	[PERIODNO] ASC,
	[YEARNO] ASC,
	[RUNNO] ASC,
	[EMPNUMBER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_EMPLOYEESWCA_PERIODNO_YEARNO_RUNNO_EMPNUMBER_PRLID] ON [dbo].[EMPLOYEESWCA]
(
	[PERIODNO] ASC,
	[YEARNO] ASC,
	[RUNNO] ASC,
	[EMPNUMBER] ASC,
	[PRLID] ASC
)
INCLUDE([WCAAMOUNT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[EMPLOYEESWCA] ADD  CONSTRAINT [DF_EMPLOYEESWC_WCAMOUNT]  DEFAULT (0) FOR [WCAAMOUNT]
ALTER TABLE [dbo].[EMPLOYEESWCA] ADD  CONSTRAINT [DF_EMPLOYEESWC_PRLID]  DEFAULT (1) FOR [PRLID]
ALTER TABLE [dbo].[EMPLOYEESWCA] ADD  CONSTRAINT [DF__EMPLOYEES__WCAEA__17CD73C7]  DEFAULT (0) FOR [WCAEARNINGS]
ALTER TABLE [dbo].[EMPLOYEESWCA] ADD  CONSTRAINT [DF__EMPLOYEES__WCAAC__18C19800]  DEFAULT (0) FOR [WCAACTUAL]
ALTER TABLE [dbo].[EMPLOYEESWCA]  WITH CHECK ADD  CONSTRAINT [FK_EMPLOYEESWC_EMPLOYEES] FOREIGN KEY([PRLID], [EMPNUMBER])
REFERENCES [dbo].[EMPLOYEES] ([PAYROLLID], [EMPNUMBER])
ALTER TABLE [dbo].[EMPLOYEESWCA] CHECK CONSTRAINT [FK_EMPLOYEESWC_EMPLOYEES]
ALTER TABLE [dbo].[EMPLOYEESWCA]  WITH CHECK ADD  CONSTRAINT [FK_EMPLOYEESWC_PAYROLLS] FOREIGN KEY([PRLNUMBER])
REFERENCES [dbo].[PAYROLLS] ([PRLNUMBER])
ALTER TABLE [dbo].[EMPLOYEESWCA] CHECK CONSTRAINT [FK_EMPLOYEESWC_PAYROLLS]