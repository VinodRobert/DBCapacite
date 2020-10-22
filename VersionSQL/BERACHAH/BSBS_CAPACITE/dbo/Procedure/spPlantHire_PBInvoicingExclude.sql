/****** Object:  Procedure [dbo].[spPlantHire_PBInvoicingExclude]    Committed by VersionSQL https://www.versionsql.com ******/

--Notes---------------------------------------------------------------------------------------------------------
--2009-10-27 OAB add the @BorgID to the Ivoice number routine.
--	If two orgs was running the Plant Base Hire system the one wood overwrite the others Invoice number.  
--	As per Log 3153 of Namandla Roads and Cavils
--2011-10-10 Matthew
--  Added LTrim when setting PBRHInvoiceNum, else has space in front when not using prefixes and doesnt print single invoices
--
-----------------------------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[spPlantHire_PBInvoicingExclude]

	@BrogID as int
AS
--DATE 06-12-2006
	DECLARE @invNum as int, @invPref as char(5), @cPltNum as char(10) ,@cContNum as nvarchar(10), 
			@TcontNum as nvarchar(10), @cDebtNum as nvarchar(10), @TdebtNum as nvarchar(10), 
			@cInvPerPlt bit, @TPltNum as char(10), @cPBRHSite as nvarchar(100), @tPBRHSite as nvarchar(100)
	
	DECLARE @holdError INT
	SET @holdError = 0
	BEGIN TRANSACTION
	
	set @invNum = (SELECT TOP 1 PlantHirePBInvoiceNum FROM BORGS WHERE (BORGID = @BrogID))
	set @invPref = (SELECT TOP 1 PlantHirePBInvoicePref FROM BORGS WHERE (BORGID = @BrogID))
	
	--SELECT @invNum as invNum, @invPref as invPref 
	
	
	--Set back all un-posted line 
	UPDATE PlantHirePBReturnsHead
	SET PBRHInvoiceNum = NULL, PBRHPostFlag = 0
	WHERE (PBRHPostFlag = 2)


	--Set Invoice number for contracts >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	DECLARE curCont  CURSOR  for 
		SELECT	PlantHirePBReturnsHead.ContrNumber AS OABContNum, PlantHirePBHeader.PeNumber, PlantHirePBHeader.PBRHSite
		FROM	PlantHirePBReturnsHead INNER JOIN
				PlantHirePBHeader ON PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid
		WHERE	(PlantHirePBReturnsHead.PBRHPostFlag = 0) 
				AND (NOT (PlantHirePBReturnsHead.ContrNumber IS NULL)) 
				AND (PlantHirePBHeader.BHRHExcFormInv = 0) 
				AND (PlantHirePBHeader.BorgID = @BrogID)
		ORDER BY OABContNum
	FOR UPDATE 
	
	if @HoldError = 0
	BEGIN
		OPEN curCont
		FETCH NEXT FROM curCont 
			Into @cContNum, @cPltNum, @cPBRHSite
		
		
		if @@FETCH_STATUS = 0	
			set @invNum = @invNum + 1
		
		SET @TcontNum = @cContNum
		SET @tPBRHSite = @cPBRHSite
		SET @HoldError = @@Error	
	END
	
	WHILE @@FETCH_STATUS = 0 AND @HoldError = 0
	BEGIN
	
		--SELECT @cContNum as siteNum, @TcontNum as TempInvoiceN, @invNum as invoiceNum
		
		IF @TcontNum <> @cContNum	
		begin
			set @invNum = @invNum + 1
		end
		else
		begin
			if  @tPBRHSite <> @cPBRHSite 
				set @invNum = @invNum + 1
		end
		--SELECT @cContNum as siteNum, @TcontNum as TempInvoiceN, @invNum as invoiceNum
		
		IF @HoldError = 0
		BEGIN
			UPDATE PlantHirePBReturnsHead
			SET PBRHInvoiceNum = LTRIM(RTRIM(@invPref) + ' ' + CAST(@invNum AS nVarChar)),
			PBRHPostFlag = 2		
			WHERE CURRENT of curCont
			SET @HoldError = @@ERROR
		END
		
		IF @HoldError = 0
		BEGIN
			SET @TcontNum = @cContNum
			SET @tPBRHSite = @cPBRHSite
			FETCH NEXT FROM curCont 
				Into @cContNum, @cPltNum, @cPBRHSite
			SET @HoldError = @@ERROR
		END
	END
	 
	CLOSE curCont
	DEALLOCATE curCont
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
	--Set Invoice number for Debutors +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	DECLARE curDebt  CURSOR  for 
		SELECT PlantHirePBReturnsHead.DebtNumber AS OABDetNum, 
		   PlantHirePBHeader.PeNumber, DEBTORS.DebtInvPerPltNun, PlantHirePBHeader.PBRHSite
		FROM PlantHirePBReturnsHead INNER JOIN
		   PlantHirePBHeader ON 
		   PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid INNER JOIN
		   DEBTORS ON 
		   PlantHirePBReturnsHead.DebtNumber = DEBTORS.DebtNumber
		WHERE (PlantHirePBReturnsHead.PBRHPostFlag = 0) AND 
		   (NOT (PlantHirePBReturnsHead.DebtNumber IS NULL)) AND 
		   (PlantHirePBHeader.BHRHExcFormInv = 0)
			AND (PlantHirePBHeader.BorgID = @BrogID)
		ORDER BY PlantHirePBReturnsHead.DebtNumber
	FOR UPDATE 
	
	if @HoldError = 0
	BEGIN
		OPEN curDebt
		FETCH NEXT FROM curDebt 
			Into @cDebtNum, @cPltNum, @cInvPerPlt, @cPBRHSite
		
		if @@FETCH_STATUS = 0	
			set @invNum = @invNum + 1
			
		SET @TdebtNum = @cDebtNum
		SET @TPltNum = @cPltNum
		SET @HoldError = @@Error
		SET @tPBRHSite = @cPBRHSite	
	END
	
	WHILE @@FETCH_STATUS = 0 AND @HoldError = 0
	BEGIN
	
		SELECT @cDebtNum as DebtNum, @TdebtNum as TempInvoiceN, @invNum as invoiceNum, @cInvPerPlt as cInvPerPlt
		
		IF @TdebtNum <> @cDebtNum
			set @invNum = @invNum + 1
		else
		begin
			if (@cInvPerPlt <> 0 and @TPltNum <> @cPltNum) or @tPBRHSite <> @cPBRHSite 	
				set @invNum = @invNum + 1
		end
			
		SELECT @cDebtNum as DebtNum, @TdebtNum as TempInvoiceN, @invNum as invoiceNum
		
		
		IF @HoldError = 0
		BEGIN
			UPDATE PlantHirePBReturnsHead
			SET PBRHInvoiceNum = LTRIM(RTRIM(@invPref) + ' ' + CAST(@invNum AS nVarChar)),
			PBRHPostFlag = 2		
			WHERE CURRENT of curDebt
			SET @HoldError = @@ERROR
		END
		
		IF @HoldError = 0
		BEGIN
			SET @TdebtNum = @cDebtNum
			SET @TPltNum = @cPltNum
			SET @tPBRHSite = @cPBRHSite
			FETCH NEXT FROM curDebt 
				Into @cDebtNum, @cPltNum, @cInvPerPlt, @cPBRHSite
			SET @HoldError = @@ERROR
		END
	END
	 
	CLOSE curDebt
	DEALLOCATE curDebt
	--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	--Set Invoice number for Overhease &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	declare @cDivToID int, @TDivToID int
	DECLARE curDebt  CURSOR  for 
		SELECT PlantHirePBReturnsHead.DivToID AS OABDivToID, 
		   PlantHirePBHeader.PeNumber, PlantHirePBHeader.PBRHSite
		FROM PlantHirePBReturnsHead INNER JOIN
		   PlantHirePBHeader ON 
		   PlantHirePBReturnsHead.PBHid = PlantHirePBHeader.PBHid
		WHERE (PlantHirePBReturnsHead.PBRHPostFlag = 0) AND 
		   (NOT (PlantHirePBReturnsHead.DivToId IS NULL)) AND 
		   (PlantHirePBHeader.BHRHExcFormInv = 0)
			AND (PlantHirePBHeader.BorgID = @BrogID)
		ORDER BY PlantHirePBReturnsHead.DivToID
	FOR UPDATE 
	
	if @HoldError = 0
	BEGIN
		OPEN curDebt
		FETCH NEXT FROM curDebt 
			Into @cDivToID, @cPltNum,  @cPBRHSite
		
		if @@FETCH_STATUS = 0	
			set @invNum = @invNum + 1
			
		SET @TDivToID = @cDivToID
		SET @TPltNum = @cPltNum
		SET @HoldError = @@Error
		SET @tPBRHSite = @cPBRHSite	
	END
	
	WHILE @@FETCH_STATUS = 0 AND @HoldError = 0
	BEGIN
	
		--SELECT @cDivToID as DivToID_IN, @TDivToID as TempInvoiceN, @invNum as invoiceNum, @cInvPerPlt as cInvPerPlt
		--select @TDivToID, @cDivToID
		IF @TDivToID <> @cDivToID
		begin	
			--select 'Here'
			set @invNum = @invNum + 1
		end
		else
		begin
			if  @tPBRHSite <> @cPBRHSite 
				set @invNum = @invNum + 1
		end
			
		--SELECT @cDivToID as DivToID_OUT, @TDivToID as TempInvoiceN, @invNum as invoiceNum
		
		
		IF @HoldError = 0
		BEGIN
			UPDATE PlantHirePBReturnsHead
			SET PBRHInvoiceNum = LTRIM(RTRIM(@invPref) + ' ' + CAST(@invNum AS nVarChar)),
			PBRHPostFlag = 2		
			WHERE CURRENT of curDebt
			SET @HoldError = @@ERROR
		END
		
		IF @HoldError = 0
		BEGIN
			SET @TDivToID = @cDivToID
			SET @TPltNum = @cPltNum
			SET @tPBRHSite = @cPBRHSite
			FETCH NEXT FROM curDebt 
				Into @cDivToID, @cPltNum,  @cPBRHSite
			SET @HoldError = @@ERROR
		END
	END
	 
	CLOSE curDebt
	DEALLOCATE curDebt
	--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	
	

If @holdError <> 0 
begin 
  ROLLBACK TRANSACTION
  RETURN 0
end 
else  
begin  	
  Commit transaction 
  RETURN 1
end  