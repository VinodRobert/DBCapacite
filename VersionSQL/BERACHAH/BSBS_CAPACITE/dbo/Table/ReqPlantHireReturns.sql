/****** Object:  Table [dbo].[ReqPlantHireReturns]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ReqPlantHireReturns](
	[GlCode] [char](10) NOT NULL,
	[HireRRevPenaltyPerc] [numeric](18, 4) NOT NULL,
	[HireRPenaltyAmount] [money] NOT NULL,
	[HireRAmount] [money] NOT NULL,
	[HireRTotalAmount] [money] NOT NULL,
	[HireRSort] [int] IDENTITY(1,1) NOT NULL,
	[VATAMOUNT] [money] NOT NULL,
	[IDR] [int] NULL,
	[HireRPostAmount] [money] NULL,
	[HireRPostVat] [money] NULL,
	[ESCALATIONAMOUNT] [money] NOT NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [Index_IDR] ON [dbo].[ReqPlantHireReturns]
(
	[IDR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
ALTER TABLE [dbo].[ReqPlantHireReturns] ADD  CONSTRAINT [DF_ReqPlantHireReturns_HireRRevPenaltyPerc]  DEFAULT ('1') FOR [HireRRevPenaltyPerc]
ALTER TABLE [dbo].[ReqPlantHireReturns] ADD  CONSTRAINT [DF_ReqPLANTHIRERETURNS_VATAMOUNT]  DEFAULT ((0)) FOR [VATAMOUNT]
ALTER TABLE [dbo].[ReqPlantHireReturns] ADD  CONSTRAINT [DF_REQPLANTHIRERETURNS_ESCALATIONAMOUNT]  DEFAULT ((0)) FOR [ESCALATIONAMOUNT]
ALTER TABLE [dbo].[ReqPlantHireReturns]  WITH CHECK ADD  CONSTRAINT [FK_ReqPlantHireReturns_ReqPlantHireReturnsHead] FOREIGN KEY([IDR])
REFERENCES [dbo].[ReqPlantHireReturnsHead] ([ID])
ALTER TABLE [dbo].[ReqPlantHireReturns] CHECK CONSTRAINT [FK_ReqPlantHireReturns_ReqPlantHireReturnsHead]