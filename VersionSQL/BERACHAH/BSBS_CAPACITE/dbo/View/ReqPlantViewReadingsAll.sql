/****** Object:  View [dbo].[ReqPlantViewReadingsAll]    Committed by VersionSQL https://www.versionsql.com ******/

create VIEW [dbo].[ReqPlantViewReadingsAll]
AS
SELECT     smr.PeNumber, smr.SMRUnit, dbo.PlantMeterNumber.PltMeterNum, smr.PBHRCloseSMR, smr.PBRHDate, smr.IsService, smr.ServID, smr.ID, smr.[Where], 
smr.USERNAME, smr.AllocTO, smr.AllocName, smr.Alloc, smr.PltFID
FROM         (SELECT     dbo.PlantHirePBHeader.PeNumber, dbo.PlantHirePBReturnsHead.PBRHDate, ISNULL(dbo.PlantHirePBReturnsHead.PBHRCloseSMR, - 1) 
                      AS PBHRCloseSMR, 0 AS IsService, NULL AS ServID, CONVERT(nvarchar, dbo.PlantHirePBReturnsHead.PBRHid) AS ID, 'PlantBased' AS [Where], 
                      dbo.PLANTCATEGORIES.SMRUnit, ISNULL(dbo.USERS.USERNAME, 'No User') AS USERNAME, ISNULL(dbo.PlantHirePBReturnsHead.ContrNumber, 
                      ISNULL(dbo.PlantHirePBReturnsHead.DebtNumber, ISNULL(dbo.PlantHirePBReturnsHead.DivToID, - 1))) AS AllocTO, 
                      ISNULL(dbo.CONTRACTS.CONTRNAME, ISNULL(dbo.DEBTORS.DebtName, ISNULL(dbo.DIVISIONS.DivName, - 1))) AS AllocName, 
                      CASE WHEN IsNull(PlantHirePBReturnsHead.ContrNumber, '-1') <> '-1' THEN 'Contract' WHEN IsNull(PlantHirePBReturnsHead.DebtNumber, '-1') 
                      <> '-1' THEN 'Debtor' WHEN IsNull(PlantHirePBReturnsHead.DivToID, '-1') <> '-1' THEN 'Division' ELSE 'No Alloc' END AS Alloc, - 1 AS PltFID
FROM          dbo.PlantHirePBReturnsHead INNER JOIN
                      dbo.PlantHirePBHeader ON dbo.PlantHirePBReturnsHead.PBHid = dbo.PlantHirePBHeader.PBHid INNER JOIN
                      dbo.PLANTCATEGORIES ON dbo.PlantHirePBReturnsHead.CatID = dbo.PLANTCATEGORIES.CatID LEFT OUTER JOIN
                      dbo.DIVISIONS ON dbo.PlantHirePBReturnsHead.DivToID = dbo.DIVISIONS.DivID LEFT OUTER JOIN
                      dbo.CONTRACTS ON dbo.PlantHirePBReturnsHead.ContrNumber = dbo.CONTRACTS.CONTRNUMBER LEFT OUTER JOIN
                      dbo.DEBTORS ON dbo.PlantHirePBReturnsHead.DebtNumber = dbo.DEBTORS.DebtNumber LEFT OUTER JOIN
                      dbo.USERS ON dbo.PlantHirePBReturnsHead.PBHRUser = dbo.USERS.USERID
UNION ALL
SELECT     dbo.ReqPlantHireReturnsHead.PeNumber, dbo.ReqPlantHireReturnsHead.HireRSMRDate, ISNULL(dbo.ReqPlantHireReturnsHead.HireRSMRReading, - 1) AS HireRSMRReading, 
 --2013-09-26 RS  join on the ID column and not the HireRNumber as this is the unique key in the new req based system.
 --0 AS IsService, NULL AS ServID, CONVERT(nvarchar, dbo.ReqPlantHireReturnsHead.HireRNumber) AS ID, 'ReqBased' AS [Where], PLANTCATEGORIES_1.SMRUnit, 
                     0 AS IsService, NULL AS ServID, dbo.ReqPlantHireReturnsHead.ID AS ID, 'ReqBased' AS [Where], PLANTCATEGORIES_1.SMRUnit, 
                     ISNULL(USERS_2.USERNAME, N'Not Posted') AS USERNAME, ISNULL(CAST(dbo.PlantHireHeader.ContrNumber AS nvarchar), 
                     ISNULL(CAST(dbo.PlantHireHeader.DivIDTo AS nvarchar), ISNULL(CAST(dbo.PlantHireHeader.DebtNumber AS nvarchar), 
                     ISNULL(CAST(dbo.PlantHireHeader.SubNumber AS nvarchar), N'N/A')))) AS AllocTo, ISNULL(CONTRACTS_1.CONTRNAME, ISNULL(DIVISIONS_1.DivName, 
                     ISNULL(DEBTORS_1.DebtName, ISNULL(dbo.SUBCONTRACTORS.SubName, N'N/A')))) AS AllocName, CASE WHEN IsNull(PlantHireHeader.ContrNumber, 
                     '-1') <> '-1' THEN 'Contract' WHEN IsNull(PlantHireHeader.DivIDTo, '-1') <> '-1' THEN 'Division' WHEN IsNull(PlantHireHeader.DebtNumber, '-1') 
                     <> '-1' THEN 'Debtor' WHEN IsNull(PlantHireHeader.SubNumber, '-1') <> '-1' THEN 'Sub Contract' ELSE 'No Alloc' END AS Alloc, - 1 AS PltFID
FROM         dbo.PlantHireDetail INNER JOIN
                     dbo.ReqPlantHireReturnsHead ON dbo.PlantHireDetail.HireHNumber = dbo.ReqPlantHireReturnsHead.HireHNumber AND 
                     dbo.PlantHireDetail.PeNumber = dbo.ReqPlantHireReturnsHead.PeNumber INNER JOIN
 --2013-09-26 RS  join on the ID column and not the HireRNumber as this is the unique key in the new req based system.
--dbo.ReqPlantHireReturns ON dbo.ReqPlantHireReturnsHead.HireRNumber = dbo.ReqPlantHireReturnsHead.HireRNumber INNER JOIN                    
                     dbo.ReqPlantHireReturns ON dbo.ReqPlantHireReturnsHead.ID = dbo.ReqPlantHireReturns.IDR INNER JOIN
                     dbo.PLANTCATEGORIES AS PLANTCATEGORIES_1 ON dbo.PlantHireDetail.CatID = PLANTCATEGORIES_1.CatID INNER JOIN
                     dbo.PlantHireHeader ON dbo.PlantHireDetail.HireHNumber = dbo.PlantHireHeader.HireHNumber LEFT OUTER JOIN
                     dbo.USERS AS USERS_2 ON dbo.ReqPlantHireReturnsHead.HireRPostUserID = USERS_2.USERID LEFT OUTER JOIN
                     dbo.SUBCONTRACTORS ON dbo.PlantHireHeader.SubNumber = dbo.SUBCONTRACTORS.SubNumber LEFT OUTER JOIN
                     dbo.DEBTORS AS DEBTORS_1 ON dbo.PlantHireHeader.DebtNumber = DEBTORS_1.DebtNumber LEFT OUTER JOIN
                     dbo.DIVISIONS AS DIVISIONS_1 ON dbo.PlantHireHeader.DivIDTo = DIVISIONS_1.DivID LEFT OUTER JOIN
                     dbo.CONTRACTS AS CONTRACTS_1 ON dbo.PlantHireHeader.ContrNumber = CONTRACTS_1.CONTRNUMBER
GROUP BY dbo.ReqPlantHireReturnsHead.PeNumber, dbo.ReqPlantHireReturnsHead.HireRSMRDate, ISNULL(dbo.ReqPlantHireReturnsHead.HireRSMRReading, - 1), 
                     dbo.ReqPlantHireReturnsHead.ID, dbo.ReqPlantHireReturns.IDR, PLANTCATEGORIES_1.SMRUnit, dbo.PlantHireDetail.HireHNumber, USERS_2.USERNAME, 
                     dbo.PlantHireHeader.HireHAllocation, dbo.PlantHireHeader.ContrNumber, dbo.PlantHireHeader.DivIDTo, dbo.PlantHireHeader.DebtNumber, 
                     dbo.PlantHireHeader.SubNumber, ISNULL(CAST(dbo.PlantHireHeader.ContrNumber AS nvarchar), ISNULL(CAST(dbo.PlantHireHeader.DivIDTo AS nvarchar), 
                     ISNULL(CAST(dbo.PlantHireHeader.DebtNumber AS nvarchar), ISNULL(CAST(dbo.PlantHireHeader.SubNumber AS nvarchar), N'N/A')))), 
                     ISNULL(CONTRACTS_1.CONTRNAME, ISNULL(DIVISIONS_1.DivName, ISNULL(DEBTORS_1.DebtName, ISNULL(dbo.SUBCONTRACTORS.SubName, 
                     N'N/A')))), dbo.ReqPlantHireReturnsHead.HireRPostUserID
UNION ALL
SELECT     dbo.PlantReadings.PeNumber, dbo.PlantReadings.PltRDateOfReading, ISNULL(dbo.PlantReadings.PltRSMR, - 1) AS PltRSMR, 
                     dbo.PlantReadings.PltRIsService, dbo.PlantReadings.ServID, CONVERT(nvarchar, dbo.PlantReadings.PltRID) AS ID, 
                     dbo.PlantReadingsFlags.PltFName AS [Where], dbo.PlantReadings.PltRUnit, USERS_1.USERNAME, 'N/A' AS AllocTO, 'N/A' AS AllocNAME, 'N/A' AS Alloc, 
                     dbo.PlantReadingsFlags.PltFID
FROM         dbo.PlantReadings INNER JOIN
                     dbo.PlantReadingsFlags ON dbo.PlantReadings.PltFalgID = dbo.PlantReadingsFlags.PltFID LEFT OUTER JOIN
                     dbo.USERS AS USERS_1 ON dbo.PlantReadings.UserID = USERS_1.USERID) AS smr LEFT OUTER JOIN
dbo.PlantMeterNumber ON smr.SMRUnit = dbo.PlantMeterNumber.PltMUnit AND smr.PeNumber = dbo.PlantMeterNumber.PltMPeNamber AND 
dbo.PlantMeterNumber.PltMReplaceDate <= CONVERT(DATETIME, smr.PBRHDate, 103)
		