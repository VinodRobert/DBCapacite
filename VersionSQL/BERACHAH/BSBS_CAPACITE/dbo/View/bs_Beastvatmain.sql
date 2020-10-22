/****** Object:  View [dbo].[bs_Beastvatmain]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_Beastvatmain
AS
SELECT     TOP 100 PERCENT dbo.TRANSACTIONS.OrgID, dbo.TRANSACTIONS.[Year], dbo.TRANSACTIONS.Period, dbo.TRANSACTIONS.PDate, 
                      dbo.TRANSACTIONS.BatchRef, dbo.TRANSACTIONS.TransRef, dbo.TRANSACTIONS.TransType, dbo.TRANSACTIONS.Allocation, 
                      dbo.TRANSACTIONS.LedgerCode, dbo.TRANSACTIONS.Contract, dbo.TRANSACTIONS.Description, dbo.TRANSACTIONS.Currency, 
                      dbo.TRANSACTIONS.Debit, dbo.TRANSACTIONS.Credit, dbo.TRANSACTIONS.VatDebit, dbo.TRANSACTIONS.VatCredit, dbo.TRANSACTIONS.TransID, 
                      dbo.TRANSACTIONS.VATType, dbo.TRANSACTIONS.HomeCurrAmount, dbo.TRANSACTIONS.ConversionRate, dbo.bs_BeastVAT.Currency AS VCcurrency, 
                      dbo.bs_BeastVAT.ConversionRate AS VCconversion, dbo.bs_BeastVAT.LedgerCode AS VCLedgercode
FROM         dbo.TRANSACTIONS LEFT OUTER JOIN
                      dbo.bs_BeastVAT ON dbo.TRANSACTIONS.Description = dbo.bs_BeastVAT.Description AND dbo.TRANSACTIONS.OrgID = dbo.bs_BeastVAT.OrgID AND 
                      dbo.TRANSACTIONS.[Year] = dbo.bs_BeastVAT.[Year] AND dbo.TRANSACTIONS.Period = dbo.bs_BeastVAT.Period AND 
                      dbo.TRANSACTIONS.PDate = dbo.bs_BeastVAT.PDate AND dbo.TRANSACTIONS.BatchRef = dbo.bs_BeastVAT.BatchRef AND 
                      dbo.TRANSACTIONS.TransRef = dbo.bs_BeastVAT.TransRef