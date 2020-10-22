/****** Object:  Procedure [dbo].[spCreateTempTrans]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker botes
-- Create date: 2009/05/29
-- Description:	Add a Temporary Transaction table to the BSBS_Temp database 
-- =============================================
CREATE PROCEDURE [spCreateTempTrans]
	@TName as nvarchar(50)
AS
BEGIN

	exec('
	IF  EXISTS (SELECT * FROM BSBS_Temp.dbo.sysobjects WHERE id = OBJECT_ID(N''[BSBS_temp].[dbo].[TRANSACTIONS'+ @TName +']''))
			DROP TABLE BSBS_Temp.[dbo].[TRANSACTIONS'+ @TName +'] 
	')

	exec('
	CREATE TABLE BSBS_Temp.[dbo].[TRANSACTIONS'+ @TName +']( [Debug] int,
		[OrgID] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_OrgID]  DEFAULT (0),
		[Year] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Year]  DEFAULT (''2000''),
		[Period] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Period]  DEFAULT (1),
		[PDate] [datetime] NULL,
		[BatchRef] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_BatchRef]  DEFAULT (''''),
		[TransRef] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_TransRef]  DEFAULT (''''),
		[MatchRef] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_MatchRef]  DEFAULT (''''),
		[TransType] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_TransType]  DEFAULT (''''),
		[Allocation] [char](25) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Allocation]  DEFAULT (''Balance Sheet''),
		[LedgerCode] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_LedgerCode]  DEFAULT (''''),
		[Contract] [nvarchar](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Contract]  DEFAULT (''''),
		[Activity] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Activity]  DEFAULT (''''),
		[Description] [char](255) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Description]  DEFAULT (''''),
		[ForeignDescription] [char](255) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_ForeignDescription]  DEFAULT (''''),
		[Currency] [nvarchar](3) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Currency]  DEFAULT (''ZAR''),
		[Debit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Debit]  DEFAULT (0.00),
		[Credit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Credit]  DEFAULT (0.00),
		[VatDebit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_VatDebit]  DEFAULT (0.00),
		[VatCredit] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_VatCredit]  DEFAULT (0.00),
		[Credno] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Credno]  DEFAULT (''''),
		[Store] [char](20) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Store]  DEFAULT (''''),
		[Plantno] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Plantno]  DEFAULT (''''),
		[Stockno] [char](20) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Stockno]  DEFAULT (''''),
		[Quantity] [numeric](23, 4) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Quantity]  DEFAULT (0),
		[Unit] [char](10) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Unit]  DEFAULT (''''),
		[Rate] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Rate]  DEFAULT (0),
		[ReqNo] [char](55) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_ReqNo]  DEFAULT (''''),
		[OrderNo] [char](55) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_OrderNo]  DEFAULT (''''),
		[Age] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_Age]  DEFAULT (0),
		[TransID] [int] IDENTITY(1,1) NOT NULL,
		[SubConTran] [char](20) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_SubConTran]  DEFAULT (''''),
		[VATType] [varchar](250) NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_VATType]  DEFAULT (''Z''),
		[HomeCurrAmount] [money] NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_HomeCurrAmount]  DEFAULT (0),
		[ConversionDate] [datetime] NULL,
		[ConversionRate] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_ConversionRate]  DEFAULT (1),
		[PaidFor] [bit] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_PaidFor]  DEFAULT (0),
		[PaidToDate] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_PaidToDate]  DEFAULT (0),
		[PaidThisPeriod] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_PaidThisPeriod]  DEFAULT (0),
		[WhtThisPeriod] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_WhtThisPeriod]  DEFAULT (0),
		[DiscThisPeriod] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_DiscThisPeriod]  DEFAULT (0),
		[ReconStatus] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_ReconStatus]  DEFAULT (0),
		[UserID] [char](10) NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_UserID]  DEFAULT (''Admin''),
		[DivID] [int] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_DivID]  DEFAULT (3),
		[ForexVal] [money] NOT NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +''+ @TName +'_ForexVal]  DEFAULT (0),
		[HeadID] [char](10) NULL,
		[XGLCODE] [char](10) NOT NULL DEFAULT (''''),
		[XVATA] [money] NOT NULL DEFAULT ((0.00)),
		[XVATT] [char](2) NOT NULL DEFAULT (''Z''),
		[DOCNUMBER] [nchar](50) NULL,
		[WHTID] [int] NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_WHTID]  DEFAULT ((-1)),
		[FBID] [int] NULL CONSTRAINT [DF_TRANSACTIONS'+ @TName +'_FBID]  DEFAULT ((-1)),
	 CONSTRAINT [PK_TRANSACTIONS'+ @TName +'] PRIMARY KEY CLUSTERED 
	(
		[TransID] ASC
	) ON [PRIMARY] )
	')	
end 
		