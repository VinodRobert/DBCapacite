/****** Object:  View [dbo].[PlantViewLastLocation]    Committed by VersionSQL https://www.versionsql.com ******/

create view [dbo].[PlantViewLastLocation]
AS
SELECT     dbo.PlantViewReadings.PeNumber, dbo.PlantViewReadings.SMRUnit, dbo.PlantViewReadings.PltMeterNum, dbo.PlantViewReadings.PBHRCloseSMR AS SMR, 
dbo.PlantViewReadings.PBRHDate AS Date, dbo.PlantViewReadings.IsService, dbo.PlantViewReadings.ServID, dbo.PlantViewReadings.ID, 
dbo.PlantViewReadings.[Where], dbo.PlantViewReadings.USERNAME, dbo.PlantViewReadings.AllocTO, dbo.PlantViewReadings.AllocName, 
dbo.PlantViewReadings.Alloc, RATE.Rate1, RATE.Rate2, RATE.Rate3, RATE.Rate4, RATE.Rate5, RATE.MinPerDay
FROM         dbo.PlantViewReadings INNER JOIN
(SELECT     PlantViewReadings_2.PeNumber, PlantViewReadings_2.PBRHDate, MAX(PlantViewReadings_2.ID) AS MaxID, FindMaxDate.MaxSMR
FROM          dbo.PlantViewReadings AS PlantViewReadings_2 INNER JOIN
           (SELECT     PeNumber, MAX(PBRHDate) AS MaxDate, MAX(PBHRCloseSMR) AS MaxSMR
             FROM          dbo.PlantViewReadings AS PlantViewReadings_1
             WHERE      (NOT (AllocTO = N'N/A')) AND (NOT (PltFID = 5))
             GROUP BY PeNumber) AS FindMaxDate ON PlantViewReadings_2.PeNumber = FindMaxDate.PeNumber AND 
       PlantViewReadings_2.PBRHDate = FindMaxDate.MaxDate AND PlantViewReadings_2.PBHRCloseSMR = FindMaxDate.MaxSMR
GROUP BY PlantViewReadings_2.PeNumber, PlantViewReadings_2.PBRHDate, FindMaxDate.MaxSMR) AS FindMaxID ON 
dbo.PlantViewReadings.PeNumber = FindMaxID.PeNumber AND dbo.PlantViewReadings.ID = FindMaxID.MaxID AND 
dbo.PlantViewReadings.PBRHDate = FindMaxID.PBRHDate INNER JOIN
(SELECT     dbo.PLANTANDEQ.PeNumber, dbo.PLANTCATEGORIES.CatID, dbo.PLANTCATEGORIES.CatNumber, ISNULL(dbo.PlantHireRates.HireRate1, 
       dbo.PLANTCATEGORIES.CatRate1) AS Rate1, ISNULL(dbo.PlantHireRates.HireRate2, dbo.PLANTCATEGORIES.CatRate2) AS Rate2, 
       ISNULL(dbo.PlantHireRates.HireRate3, dbo.PLANTCATEGORIES.CatRate3) AS Rate3, ISNULL(dbo.PlantHireRates.HireRate4, 
       dbo.PLANTCATEGORIES.CatRate4) AS Rate4, ISNULL(dbo.PlantHireRates.HireRate5, dbo.PLANTCATEGORIES.CatRate5) AS Rate5, 
       ISNULL(dbo.PlantHireRates.HireRDayMin, dbo.PLANTCATEGORIES.HireRDayMin) AS MinPerDay
FROM          dbo.PLANTANDEQ INNER JOIN
       dbo.PLANTCATEGORIES ON dbo.PLANTANDEQ.CatID = dbo.PLANTCATEGORIES.CatID LEFT OUTER JOIN
       dbo.PlantHireRates ON dbo.PLANTANDEQ.PeNumber = dbo.PlantHireRates.PeNumber AND dbo.PlantHireRates.HireFlag = 2) AS RATE ON 
RATE.PeNumber = dbo.PlantViewReadings.PeNumber

		