/****** Object:  Table [dbo].[STAMPSETS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[STAMPSETS](
	[SSID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PAYROLLID] [int] NOT NULL,
	[SSTOTAL] [money] NOT NULL,
	[FROMVAL] [money] NOT NULL,
	[TOVAL] [money] NOT NULL,
	[EDS1] [int] NOT NULL,
	[CALC1] [nvarchar](150) NOT NULL,
	[VALUE1] [money] NOT NULL,
	[EDS2] [int] NOT NULL,
	[CALC2] [nvarchar](150) NOT NULL,
	[VALUE2] [money] NOT NULL,
	[EDS3] [int] NOT NULL,
	[CALC3] [nvarchar](150) NOT NULL,
	[VALUE3] [money] NOT NULL,
	[EDS4] [int] NOT NULL,
	[CALC4] [nvarchar](150) NOT NULL,
	[VALUE4] [money] NOT NULL,
	[EDS5] [int] NOT NULL,
	[CALC5] [nvarchar](150) NOT NULL,
	[VALUE5] [money] NOT NULL,
	[EDS6] [int] NOT NULL,
	[CALC6] [nvarchar](150) NOT NULL,
	[VALUE6] [money] NOT NULL,
	[EDS7] [int] NOT NULL,
	[CALC7] [nvarchar](150) NOT NULL,
	[VALUE7] [money] NOT NULL,
	[EDS8] [int] NOT NULL,
	[CALC8] [nvarchar](150) NOT NULL,
	[VALUE8] [money] NOT NULL,
	[EDS9] [int] NOT NULL,
	[CALC9] [nvarchar](150) NOT NULL,
	[VALUE9] [money] NOT NULL,
	[EDS10] [int] NOT NULL,
	[CALC10] [nvarchar](150) NOT NULL,
	[VALUE10] [money] NOT NULL,
	[EDS11] [int] NOT NULL,
	[CALC11] [nvarchar](150) NOT NULL,
	[VALUE11] [money] NOT NULL,
	[EDS12] [int] NOT NULL,
	[CALC12] [nvarchar](150) NOT NULL,
	[VALUE12] [money] NOT NULL,
	[EDS13] [int] NOT NULL,
	[CALC13] [nvarchar](150) NOT NULL,
	[VALUE13] [money] NOT NULL,
	[EDS14] [int] NOT NULL,
	[CALC14] [nvarchar](150) NOT NULL,
	[VALUE14] [money] NOT NULL,
	[EDS15] [int] NOT NULL,
	[CALC15] [nvarchar](150) NOT NULL,
	[VALUE15] [money] NOT NULL,
	[EDS16] [int] NOT NULL,
	[CALC16] [nvarchar](150) NOT NULL,
	[VALUE16] [money] NOT NULL,
	[EDS17] [int] NOT NULL,
	[CALC17] [nvarchar](150) NOT NULL,
	[VALUE17] [money] NOT NULL,
	[EDS18] [int] NOT NULL,
	[CALC18] [nvarchar](150) NOT NULL,
	[VALUE18] [money] NOT NULL,
	[EDS19] [int] NOT NULL,
	[CALC19] [nvarchar](150) NOT NULL,
	[VALUE19] [money] NOT NULL,
	[EDS20] [int] NOT NULL,
	[CALC20] [nvarchar](150) NOT NULL,
	[VALUE20] [money] NOT NULL,
	[SSNAME] [nvarchar](50) NOT NULL,
	[EDSHID] [int] NOT NULL,
	[SSCATEGORY] [nvarchar](25) NOT NULL,
	[SSCODE] [nvarchar](25) NOT NULL,
	[MINHRS] [decimal](18, 2) NOT NULL,
	[MAXHRS] [decimal](18, 2) NOT NULL,
	[MINHRSNOSTAMP] [decimal](18, 2) NOT NULL,
	[MAXHRSNOSTAMP] [decimal](18, 2) NOT NULL,
	[REGNO] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_STAMPSETS] PRIMARY KEY CLUSTERED 
(
	[SSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_SSTOTAL]  DEFAULT (0) FOR [SSTOTAL]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_FROMVAL]  DEFAULT (0) FOR [FROMVAL]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_TOVAL]  DEFAULT (0) FOR [TOVAL]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS1]  DEFAULT ((-1)) FOR [EDS1]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC1]  DEFAULT ('') FOR [CALC1]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE1]  DEFAULT (0) FOR [VALUE1]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS2]  DEFAULT ((-1)) FOR [EDS2]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC2]  DEFAULT ('') FOR [CALC2]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE2]  DEFAULT (0) FOR [VALUE2]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS3]  DEFAULT ((-1)) FOR [EDS3]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC3]  DEFAULT ('') FOR [CALC3]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE3]  DEFAULT (0) FOR [VALUE3]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS4]  DEFAULT ((-1)) FOR [EDS4]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC4]  DEFAULT ('') FOR [CALC4]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE4]  DEFAULT (0) FOR [VALUE4]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS5]  DEFAULT ((-1)) FOR [EDS5]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC5]  DEFAULT ('') FOR [CALC5]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE5]  DEFAULT (0) FOR [VALUE5]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS6]  DEFAULT ((-1)) FOR [EDS6]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC6]  DEFAULT ('') FOR [CALC6]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE6]  DEFAULT (0) FOR [VALUE6]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS7]  DEFAULT ((-1)) FOR [EDS7]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC7]  DEFAULT ('') FOR [CALC7]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE7]  DEFAULT (0) FOR [VALUE7]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS8]  DEFAULT ((-1)) FOR [EDS8]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC8]  DEFAULT ('') FOR [CALC8]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE8]  DEFAULT (0) FOR [VALUE8]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS9]  DEFAULT ((-1)) FOR [EDS9]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC9]  DEFAULT ('') FOR [CALC9]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE9]  DEFAULT (0) FOR [VALUE9]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS10]  DEFAULT ((-1)) FOR [EDS10]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC10]  DEFAULT ('') FOR [CALC10]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE10]  DEFAULT (0) FOR [VALUE10]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS11]  DEFAULT ((-1)) FOR [EDS11]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC11]  DEFAULT ('') FOR [CALC11]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE11]  DEFAULT (0) FOR [VALUE11]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS12]  DEFAULT ((-1)) FOR [EDS12]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC12]  DEFAULT ('') FOR [CALC12]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE12]  DEFAULT (0) FOR [VALUE12]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS13]  DEFAULT ((-1)) FOR [EDS13]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC13]  DEFAULT ('') FOR [CALC13]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE13]  DEFAULT (0) FOR [VALUE13]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS14]  DEFAULT ((-1)) FOR [EDS14]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC14]  DEFAULT ('') FOR [CALC14]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE14]  DEFAULT (0) FOR [VALUE14]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS15]  DEFAULT ((-1)) FOR [EDS15]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC15]  DEFAULT ('') FOR [CALC15]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE15]  DEFAULT (0) FOR [VALUE15]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS16]  DEFAULT ((-1)) FOR [EDS16]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC16]  DEFAULT ('') FOR [CALC16]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE16]  DEFAULT (0) FOR [VALUE16]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS17]  DEFAULT ((-1)) FOR [EDS17]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC17]  DEFAULT ('') FOR [CALC17]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE17]  DEFAULT (0) FOR [VALUE17]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS18]  DEFAULT ((-1)) FOR [EDS18]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC18]  DEFAULT ('') FOR [CALC18]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE18]  DEFAULT (0) FOR [VALUE18]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS19]  DEFAULT ((-1)) FOR [EDS19]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC19]  DEFAULT ('') FOR [CALC19]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE19]  DEFAULT (0) FOR [VALUE19]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDS20]  DEFAULT ((-1)) FOR [EDS20]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CALC20]  DEFAULT ('') FOR [CALC20]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_VALUE20]  DEFAULT (0) FOR [VALUE20]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_SSNAME]  DEFAULT ('') FOR [SSNAME]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_EDSHEADER]  DEFAULT ((-1)) FOR [EDSHID]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_CATEGORY]  DEFAULT ('') FOR [SSCATEGORY]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_SSCODE]  DEFAULT ('') FOR [SSCODE]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_MINHRS]  DEFAULT (0) FOR [MINHRS]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_MAXHRS]  DEFAULT (0) FOR [MAXHRS]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_MINHRSNOSTAMP]  DEFAULT (0) FOR [MINHRSNOSTAMP]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_MAXHRSNOSTAMP]  DEFAULT (0) FOR [MAXHRSNOSTAMP]
ALTER TABLE [dbo].[STAMPSETS] ADD  CONSTRAINT [DF_STAMPSETS_REGNO]  DEFAULT ('') FOR [REGNO]