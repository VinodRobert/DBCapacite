/****** Object:  Procedure [dbo].[spPlantHire_RecalReqBaseRates]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Okker Botes
-- Create date: 08/08/2008
-- Description:	Update the Hire Requisitions bass rates. Set the to the new custom rate for all open requisitions   
-- =============================================
create PROCEDURE spPlantHire_RecalReqBaseRates

	@UserID int = 23,
	@BorgID  int = 0,
	@typeFlag int = -1
AS
BEGIN
	DECLARE @holdError int

	begin transaction

	--Plant
	UPDATE    PlantHireDetail
	SET              PeRate1 = PlantHireRates.HireRate1, PeRate2 = PlantHireRates.HireRate2, PeRate3 = PlantHireRates.HireRate3, PeRate4 = PlantHireRates.HireRate4, 
						  PeRate5 = PlantHireRates.HireRate5
	FROM         PlantHireDetail INNER JOIN
						  PlantHireRates ON PlantHireDetail.PeNumber = PlantHireRates.PeNumber INNER JOIN
						  PlantHireHeader ON PlantHireDetail.HireHNumber = PlantHireHeader.HireHNumber
	where (PlantHireHeader.HireHRemove = 0) AND (PlantHireDetail.HireFlag = @typeFlag)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

	-- DebtNumber	
	UPDATE    PlantHireDetail
	SET              PeRate1 = PlantHireRates.HireRate1, PeRate2 = PlantHireRates.HireRate2, PeRate3 = PlantHireRates.HireRate3, PeRate4 = PlantHireRates.HireRate4, 
						  PeRate5 = PlantHireRates.HireRate5
	FROM         PlantHireDetail INNER JOIN
						  PlantHireRates ON PlantHireDetail.PeNumber = PlantHireRates.PeNumber INNER JOIN
						  PlantHireHeader ON PlantHireDetail.HireHNumber = PlantHireHeader.HireHNumber AND PlantHireRates.DebtNumber = PlantHireHeader.DebtNumber
	WHERE     (PlantHireHeader.HireHRemove = 0) AND (PlantHireDetail.HireFlag = @typeFlag)
	--WHERE     (PlantHireDetail.PeNumber = '123') AND (PlantHireRates.ContractNum = N'123')  AND (PlantHireHeader.HireHRemove = 0)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

	--DivIDTo
	UPDATE    PlantHireDetail
	SET              PeRate1 = PlantHireRates.HireRate1, PeRate2 = PlantHireRates.HireRate2, PeRate3 = PlantHireRates.HireRate3, PeRate4 = PlantHireRates.HireRate4, 
						  PeRate5 = PlantHireRates.HireRate5
	FROM         PlantHireDetail INNER JOIN
						  PlantHireRates ON PlantHireDetail.PeNumber = PlantHireRates.PeNumber INNER JOIN
						  PlantHireHeader ON PlantHireDetail.HireHNumber = PlantHireHeader.HireHNumber AND PlantHireRates.DivID = PlantHireHeader.DivIDTo
	WHERE (PlantHireHeader.HireHRemove = 0) AND (PlantHireDetail.HireFlag = @typeFlag)
	--WHERE     (PlantHireDetail.PeNumber = '123') AND (PlantHireRates.ContractNum = N'123')  AND (PlantHireHeader.HireHRemove = 0)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

	--Contracts
	UPDATE    PlantHireDetail
	SET              PeRate1 = PlantHireRates.HireRate1, PeRate2 = PlantHireRates.HireRate2, PeRate3 = PlantHireRates.HireRate3, PeRate4 = PlantHireRates.HireRate4, 
						  PeRate5 = PlantHireRates.HireRate5
	FROM         PlantHireDetail INNER JOIN
						  PlantHireRates ON PlantHireDetail.PeNumber = PlantHireRates.PeNumber INNER JOIN
						  PlantHireHeader ON PlantHireDetail.HireHNumber = PlantHireHeader.HireHNumber AND PlantHireRates.ContractNum = PlantHireHeader.ContrNumber
	WHERE (PlantHireHeader.HireHRemove = 0) AND (PlantHireDetail.HireFlag = @typeFlag)
	--WHERE     (PlantHireDetail.PeNumber = '123') AND (PlantHireRates.ContractNum = N'123')  AND (PlantHireHeader.HireHRemove = 0)
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END
	

--Get Falg descriptions for log if
	declare @HireFName char(25)

	SELECT  @HireFName =  HireFName
	FROM    PlantHireFlag
	WHERE     (HireFID = @typeFlag)

	INSERT INTO [LOG](LOGDATE, LOGACTION, LOGUSERID, LOGBORGID, PAYROLLID)
	VALUES     (GetDate(), 'Update all OPEN Requisition Based custom rates for '+ @HireFName,  @UserID, @BorgID,'')


	If @holdError <> 0 
	begin 
		ROLLBACK TRANSACTION
		RETURN @holdError
	end 
	else 
	begin  	
		Commit transaction 
		RETURN 0
	end	
END

		