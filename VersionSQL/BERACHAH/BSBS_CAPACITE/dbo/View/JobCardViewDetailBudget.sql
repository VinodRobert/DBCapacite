/****** Object:  View [dbo].[JobCardViewDetailBudget]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  VIEW [dbo].[JobCardViewDetailBudget]
AS
SELECT     JobDCardID, 'D' AS typeFlage, JobDDescription, LedgerCodeDetail, JobDDate, JobDUnit, JobDQuantity, JobDRate, JobDDiscount, JobDVatamount, JobDAmount, 
                      JobDTAmount, 0 AS JobBVatAmount, 0 AS JobBAmount, 0 AS JobBTAmount, JTID
FROM         dbo.JobCardDetail AS JobCardDetail
UNION ALL
SELECT     dbo.JobCardBudget.JobCardID, 'B' AS typeFlage, dbo.JobCardBudget.JobBDescription, dbo.JobCardBudget.LedgerCode, dbo.JobCardHeader.JobStartDate, 
                      dbo.JobCardBudget.JobBUnit, dbo.JobCardBudget.JobBQuantity, dbo.JobCardBudget.JobBRate, 0 AS JobDDiscount, 0 AS JobDVatamount, 0 AS JobDAmount, 
                      0 AS JobDTAmount, dbo.JobCardBudget.JobBVatAmount, dbo.JobCardBudget.JobBAmount, dbo.JobCardBudget.JobBTAmount, NULL AS JTID
FROM         dbo.JobCardBudget INNER JOIN
                      dbo.JobCardHeader ON dbo.JobCardBudget.JobCardID = dbo.JobCardHeader.JobCardID

		