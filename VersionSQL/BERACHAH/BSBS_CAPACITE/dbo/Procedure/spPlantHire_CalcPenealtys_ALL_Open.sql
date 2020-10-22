/****** Object:  Procedure [dbo].[spPlantHire_CalcPenealtys_ALL_Open]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[spPlantHire_CalcPenealtys_ALL_Open]
	 @userThis int,
	 @CatID int = null,
	 @PltNum char(10) = NULL,
	 @chrFromW nVarchar(20) = 'GlobalUpdate',
   @BorgID int = null
AS
--DATE 10-12-2006
BEGIN TRANSACTION
DECLARE @holdError INT, @PBHidThis int, @theDate datetime
SET @holdError = 0
set @theDate = getDate()

-- Set up recordset for CURSOR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if @PltNum is NULL and @CatID is NULL -- Recalculate all the open Batches  
begin
DECLARE curMy   CURSOR SCROLL OPTIMISTIC  for  
	SELECT PlantHirePBHeader.PBHid
	FROM  PlantHirePBHeader 
	INNER JOIN PlantHirePBReturnsHead on PlantHirePBHeader.PBHID = PlantHirePBReturnsHead.PBHID
	INNER JOIN  PLANTANDEQ ON PlantHirePBHeader.PeNumber = PLANTANDEQ.PeNumber 
    WHERE (PlantHirePBHeader.PBHClosed = 0) and PLANTANDEQ.Borgid = @BorgID
end 
else if @CatID is NOT NULL --Recalculate for a specific Catary
begin 
DECLARE curMy   CURSOR SCROLL OPTIMISTIC  for   			
	SELECT PlantHirePBHeader.PBHid
	FROM    PlantHirePBHeader INNER JOIN
				PlantHirePBReturnsHead on PlantHirePBHeader.PBHID = PlantHirePBReturnsHead.PBHID INNER JOIN 
	            PLANTANDEQ ON PlantHirePBHeader.PeNumber = PLANTANDEQ.PeNumber INNER JOIN
	            PLANTCATEGORIES ON PLANTANDEQ.CatID = PLANTCATEGORIES.CatID
	WHERE (PlantHirePBHeader.PBHClosed = 0) AND (PLANTCATEGORIES.CatID = @CatID)
end	
else -- Recalculate for a specific Plant Number   
begin 
DECLARE curMy   CURSOR SCROLL OPTIMISTIC  for   			
	SELECT PlantHirePBHeader.PBHid
	FROM    PlantHirePBHeader INNER JOIN
	            PLANTANDEQ ON PlantHirePBHeader.PeNumber = PLANTANDEQ.PeNumber INNER JOIN
	            PLANTCATEGORIES ON PLANTANDEQ.CatID = PLANTCATEGORIES.CatID
	WHERE (PlantHirePBHeader.PBHClosed = 0) and (PlantHirePBHeader.PeNumber = @PltNum) 
end	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>		
OPEN curMy 
		
FETCH NEXT FROM curMy 
Into @PBHidThis
SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

while @@FETCH_STATUS = 0
begin
	--select @PBHidThis
	EXEC 	@holdError = spPlantHire_CalcPenealtys 
			@PBHid = @PBHidThis, 
			@user = @userThis, 
			@chrFromWhere= @chrFromW,
			@theDate = @theDate

	SELECT @holdError = coalesce(nullif(@holdError, 0), @@error)
	IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

	
	FETCH NEXT FROM curMy 
	Into @PBHidThis
	SELECT @holdError = @@error IF @holdError <> 0 BEGIN ROLLBACK TRANSACTION RETURN @holdError END

end
CLOSE curMy
DEALLOCATE curMy


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
	
		