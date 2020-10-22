/****** Object:  Procedure [dbo].[sp_ValidateLedgerCodeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 19-02-2019
-- Description:	Validate Ledgercode Groups
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateLedgerCodeGroup] 
	-- Add the parameters for the stored procedure here
	@orgId int = -1,
	@contrNumber nvarchar(10) = '',
	@divId int = -1,
	@plantNumber nvarchar(10) = '',
	@actCode nvarchar(10) = '',
	@ledgerCode nvarchar(10) = '',	
	@allocation nvarchar(35) = '',
	@sys nvarchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  declare @ledgerCnt int;
	declare @actCnt int;
	declare @contrId int;
	declare @peid int;

	set @peid = -1;
	set @contrId = -1;
	set @ledgerCnt = 0;
	set @actCnt = 0;

	if @actCode = '-1' and @contrNumber != '-1' begin set @actCode = '' end
	/*Set Contract ID*/
	if @contrNumber != '-1' and @contrNumber != ''
	begin
		set @contrId = (select top 1 CONTRID from CONTRACTS where CONTRNUMBER = @contrNumber);
	end;
	/*Set Plant ID*/
	if @plantNumber != '-1' and @plantNumber != ''
	begin
		select @peid = PEID from PLANTANDEQ where PeNumber = @plantNumber;
	end;

	set @ledgerCnt = (
    select count(*) from getLedgerCodesInGroup(@orgid, @contrNumber, @divId, @plantNumber, @actCode, @ledgerCode,  @allocation, @sys)
	);

	if @contrNumber != '-1' and @contrNumber != ''
	begin
		set @actCnt = (
			select count(*) from ACTIVITIESALLOWED 
			where [SYS] = @sys
			and [BORGID] = @orgid 
			and [ActNumber] = @actCode and 
			case @allocation when 'Contracts' then [CONTRID] else 1 end = case @allocation when 'Contracts' then @contrId else 1 end
			);
	end;

	if @allocation = 'Contracts'
	begin
		if (@ledgerCnt = 0 or @actCnt = 0)
        begin
            select 0
        end
        else
        begin
            select 1
        end
	end
	else
	begin
		select @ledgerCnt;
	end;

END
		
		