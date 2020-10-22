/****** Object:  View [dbo].[ReqPlantViewLastLocation]    Committed by VersionSQL https://www.versionsql.com ******/

create view [dbo].[ReqPlantViewLastLocation]
AS
SELECT     dbo.ReqPlantViewReadings.PeNumber, dbo.ReqPlantViewReadings.SMRUnit, dbo.ReqPlantViewReadings.PltMeterNum, dbo.ReqPlantViewReadings.PBHRCloseSMR AS SMR, 
dbo.ReqPlantViewReadings.PBRHDate AS Date, dbo.ReqPlantViewReadings.IsService, dbo.ReqPlantViewReadings.ServID, dbo.ReqPlantViewReadings.ID, 
dbo.ReqPlantViewReadings.[Where], dbo.ReqPlantViewReadings.USERNAME, dbo.ReqPlantViewReadings.AllocTO, dbo.ReqPlantViewReadings.AllocName, 
dbo.ReqPlantViewReadings.Alloc, RATE.Rate1, RATE.Rate2, RATE.Rate3, RATE.Rate4, RATE.Rate5, RATE.MinPerDay
FROM         dbo.ReqPlantViewReadings INNER JOIN
(SELECT     ReqPlantViewReadings_2.PeNumber, ReqPlantViewReadings_2.PBRHDate, MAX(ReqPlantViewReadings_2.ID) AS MaxID, FindMaxDate.MaxSMR
FROM          dbo.ReqPlantViewReadings AS ReqPlantViewReadings_2 INNER JOIN
           (SELECT     PeNumber, MAX(PBRHDate) AS MaxDate, MAX(PBHRCloseSMR) AS MaxSMR
             FROM          dbo.ReqPlantViewReadings AS ReqPlantViewReadings_1
             WHERE      (NOT (AllocTO = N'N/A')) AND (NOT (PltFID = 5))
             GROUP BY PeNumber) AS FindMaxDate ON ReqPlantViewReadings_2.PeNumber = FindMaxDate.PeNumber AND 
       ReqPlantViewReadings_2.PBRHDate = FindMaxDate.MaxDate AND ReqPlantViewReadings_2.PBHRCloseSMR = FindMaxDate.MaxSMR
GROUP BY ReqPlantViewReadings_2.PeNumber, ReqPlantViewReadings_2.PBRHDate, FindMaxDate.MaxSMR) AS FindMaxID ON 
dbo.ReqPlantViewReadings.PeNumber = FindMaxID.PeNumber AND dbo.ReqPlantViewReadings.ID = FindMaxID.MaxID AND 
dbo.ReqPlantViewReadings.PBRHDate = FindMaxID.PBRHDate INNER JOIN
(SELECT     dbo.PLANTANDEQ.PeNumber, dbo.PLANTCATEGORIES.CatID, dbo.PLANTCATEGORIES.CatNumber, ISNULL(dbo.PlantHireRates.HireRate1, 
       dbo.PLANTCATEGORIES.CatRate1) AS Rate1, ISNULL(dbo.PlantHireRates.HireRate2, dbo.PLANTCATEGORIES.CatRate2) AS Rate2, 
       ISNULL(dbo.PlantHireRates.HireRate3, dbo.PLANTCATEGORIES.CatRate3) AS Rate3, ISNULL(dbo.PlantHireRates.HireRate4, 
       dbo.PLANTCATEGORIES.CatRate4) AS Rate4, ISNULL(dbo.PlantHireRates.HireRate5, dbo.PLANTCATEGORIES.CatRate5) AS Rate5, 
       ISNULL(dbo.PlantHireRates.HireRDayMin, dbo.PLANTCATEGORIES.HireRDayMin) AS MinPerDay
FROM          dbo.PLANTANDEQ INNER JOIN
       dbo.PLANTCATEGORIES ON dbo.PLANTANDEQ.CatID = dbo.PLANTCATEGORIES.CatID LEFT OUTER JOIN
       dbo.PlantHireRates ON dbo.PLANTANDEQ.PeNumber = dbo.PlantHireRates.PeNumber AND dbo.PlantHireRates.HireFlag = 2) AS RATE ON 
RATE.PeNumber = dbo.ReqPlantViewReadings.PeNumber

		