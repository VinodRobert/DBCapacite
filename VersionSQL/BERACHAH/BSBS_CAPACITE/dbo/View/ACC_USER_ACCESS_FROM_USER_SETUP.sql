/****** Object:  View [dbo].[ACC_USER_ACCESS_FROM_USER_SETUP]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE VIEW ACC_USER_ACCESS_FROM_USER_SETUP as 
SELECT USERID [User ID], LOGINID [Login ID], USERNAME [User Name], SCONRECAPP AS [Subcontractor recon approver], 
DEBTRECAPP AS [Debtors Recon Approver], INVAPP AS [Debtors Invoice Approver],
CanSeeDashboard AS [Dashboard Access], MasterAddEdit AS [Can Add/Edit Master Data], REMCAPP AS [Creditors Remittance Batch Approver], 
REMSAPP AS [Subcontract Remittance Batch Approver], REMCBAT AS [Can Add Edit Creditor Remittance Batch], 
REMSBAT AS [Can Add Edit Subcontractor Remittance Batch], ALLOWIC AS [Can Do Intercompany], IsPlantAdmin AS [Plant Administrator], 
IsWorkshopAdmin AS [Workshop Administrator]
FROM USERS