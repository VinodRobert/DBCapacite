/****** Object:  Procedure [BS].[spCheckUnSubmittedSubbeRecons]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spCheckUnSubmittedSubbeRecons(@FinYear CHAR(4))
as
-- Here the ReconStatus will be 1 ; PaidThisPeriod will be Always Greater Than Zero and Ledgercode = Subbie Code 
SELECT * FROM TRANSACTIONS WHERE YEAR=@FinYear  AND LEDGERCODE='1320000' AND PaidThisPeriod>0 AND RECONSTATUS=1