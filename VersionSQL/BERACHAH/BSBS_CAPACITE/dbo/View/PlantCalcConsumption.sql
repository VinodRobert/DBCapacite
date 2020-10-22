/****** Object:  View [dbo].[PlantCalcConsumption]    Committed by VersionSQL https://www.versionsql.com ******/

 create view [dbo].[PlantCalcConsumption]
AS
SELECT     START.PltRID, START.PltRPosted, START.PltRIsService, START.PeNumber, START.PltRUnit, dbo.PlantCalcMeterNumber.PltMeterNum, START.PltRDateOfReading, 
                      MAX([END].PltRSMR) AS StatSMR, START.PltRSMR AS EndSMR, START.PltRSMR - MAX([END].PltRSMR) AS Delta, START.PltRLitres, START.PltRAmount, 
                      CASE WHEN START.PltRLitres = 0 THEN 0 ELSE CASE WHEN START.PltRUnit = 'Km' THEN (START.PltRSMR - MAX([END].PltRSMR)) 
                      / START.PltRLitres ELSE START.PltRLitres / (START.PltRSMR - MAX([END].PltRSMR)) END END AS Consumption, PlantCalcMeterNumber_1.PltMeterNum AS Expr1, 
                      dbo.PlantCalcMeterNumber.PltMReplaceReading
FROM         dbo.PlantReadings AS START INNER JOIN
                          (SELECT     PltRID, PeNumber, PltRContrNum, PltRActNum, PltRUnit, PltRSMR, PltRDateOfReading, PltREntrDate, PltRRefNum, PltRIsService, JobCardID, ServID, 
                                                   UserID, PltRLitres, PltRAmount, PltRPosted, PltFalgID
                            FROM          dbo.PlantReadings
                            WHERE      (PltRLitres IS NOT NULL)) AS [END] ON START.PltRSMR > [END].PltRSMR AND START.PeNumber = [END].PeNumber AND 
                      START.PltRUnit = [END].PltRUnit INNER JOIN
                      dbo.PlantCalcMeterNumber ON START.PltRID = dbo.PlantCalcMeterNumber.ID INNER JOIN
                      dbo.PlantCalcMeterNumber AS PlantCalcMeterNumber_1 ON [END].PltRID = PlantCalcMeterNumber_1.ID AND 
                      dbo.PlantCalcMeterNumber.PltMeterNum = PlantCalcMeterNumber_1.PltMeterNum
GROUP BY START.PltRID, START.PeNumber, START.PltRUnit, START.PltRDateOfReading, START.PltRSMR, START.PltRIsService, START.PltRLitres, START.PltRAmount, 
                      START.PltRPosted, dbo.PlantCalcMeterNumber.PltMeterNum, PlantCalcMeterNumber_1.PltMeterNum, dbo.PlantCalcMeterNumber.PltMReplaceReading
HAVING      (START.PltRLitres IS NOT NULL)

		