/****** Object:  View [dbo].[bs_RSC_NON_CONTR_RUN_PRC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_RSC_NON_CONTR_RUN_PRC
AS
SELECT DISTINCT TOP 100 PERCENT AREACODE, LabourPercentage, PERIODNO, RUNNO, YEARNO
FROM         dbo.RSCRUNPERC