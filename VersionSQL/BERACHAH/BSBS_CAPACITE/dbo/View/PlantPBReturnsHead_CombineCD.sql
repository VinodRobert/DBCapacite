/****** Object:  View [dbo].[PlantPBReturnsHead_CombineCD]    Committed by VersionSQL https://www.versionsql.com ******/

create VIEW [dbo].[PlantPBReturnsHead_CombineCD]
AS
SELECT     CASE WHEN (DebtNumber IS NOT NULL) THEN 'D ' + DebtNumber WHEN (ContrNumber IS NOT NULL) THEN 'C ' + ContrNumber ELSE 'O ' + CAST(DivToID AS char) 
                      END AS Debt_Cont_Ovr_Num, PBRHid, PBHid, PBRHDate, PBRHSortFlag, ContrNumber, DebtNumber, DivToID, ActNumber, PBRHOpenSMR, PBHRCloseSMR, 
                      PBRHq1, PBRHq2, PBRHq3, PBRHq4, PBRHq5, PBRHIsWeekday, PBRHIsHoliday, PBRHIsPenDay, PBHRActulWorkHr, PBHRBreakdownHr, PBHRDifSMR, 
                      PBHRVariance, PBRHPenaltyHours, CatID, HireFlag, PBRHRate1, PBRHRate2, PBRHRate3, PBRHRate4, PBRHRate5, PBRHRatePenalty, PBRHCatRateFactor1, 
                      PBRHCatRateFactor2, PBRHCatRateFactor3, PBRHCatRateFactor4, PBRHCatRateFactor5, PBRHFixedRateNum, PBRHFixedDays, PBRHDayMin, PBRHWeekMin, 
                      PBRHMonthMin, PBHRUser, PBRHCreationDate, PBRHTimestamp, PBRHPostFlag, PBRHPostTheDate, PBRHPostUserID, PBRHInvoiceNum, PlOID, PBRHOrdNum, 
                      PBRHNote
FROM         dbo.PlantHirePBReturnsHead
WHERE     (PBRHSortFlag <> 5)
		