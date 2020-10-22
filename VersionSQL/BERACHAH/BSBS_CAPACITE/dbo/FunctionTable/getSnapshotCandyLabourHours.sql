/****** Object:  Function [dbo].[getSnapshotCandyLabourHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 15-07-2016
-- Description:	returns Snapshot Candy Labour Hours
-- NOTES:
--  
-- =============================================
CREATE FUNCTION [dbo].[getSnapshotCandyLabourHours] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),
	  [Contract Number]	nvarchar(20),
	  [Contract Name] nvarchar(50),		  
	  [Project Number] nvarchar(10),	
	  [Project Name] nvarchar(50),	
	  [Unit] nvarchar(15),
	  [Bill Qty] decimal(22,8),
	  [Bill Net Amount] decimal(18,4),
	  [Bill Net Hours] decimal(22,8),
	  [Actual Qty] decimal(22,8),
	  [Actual Net Amount] decimal(18,4),
	  [Actual Net Hours] decimal(22,8),
	  [Final Qty] decimal(22,8),
	  [Final Net Amount] decimal(18,4),
	  [Final Net Hours] decimal(22,8),
	  [Next Month Qty] decimal(22,8),
	  [Next Month Amount] decimal(18,4),
	  [Next Month Hours] decimal(22,8),
	  [Remaining Cost Amount] decimal(18,4),
	  [Remaining Cost Hours] decimal(22,8),
    [USERQTY] decimal(22,8),
    [USERNETAMT] decimal(22,8),
    [USERNETHRS] decimal(22,8)
  )
AS
BEGIN

	declare @projName as nvarchar(50);
	declare @projNumber as nvarchar(10);
	declare @projId as int;
	declare @contrName as nvarchar(100);
	declare @accrualDate as datetime;
	declare @candyImportDate as datetime;
	declare @contrno as nvarchar(20);

	select @candyImportDate = CandyImportDate, @accrualDate = AccrualDate, @contrno = ContractNo from SNAPSHOTS where SNAPSHOTS.ID = @snapshotId;
	select @projId = PROJID, @contrName = CONTRNAME from Contracts where CONTRNUMBER = @contrno;
	select @projName = ProjName, @projNumber = ProjNumber from PROJECTS where PROJID = @projId;	

    insert into @t
    select labourHrs.TASKCODE as [Activity Number], ACTIVITIES.ActName as [Activity Name], labourHrs.CONTRACT as [Contract Number], @contrName as [Contract Name],
	@projNumber as [Project Number], @projName as [Project Name], labourHrs.UNIT as [Unit], labourHrs.BILLQTY as [Bill Qty], 
	labourHrs.BILLNETAMT as [Bill Net Amount], labourHrs.BILLNETHRS as [Bill Net Hours], labourHrs.ACTUALQTY as [Actual Qty], labourHrs.ACTUALNETAMT as [Actual Net Amount], 
	labourHrs.ACTUALNETHRS as [Actual Net Hours], labourHrs.FINALQTY as [Final Qty], labourHrs.FINALNETAMT as [Final Net Amount], labourHrs.FINANETLHRS as [Final Net Hours], 
	labourHrs.NEXTMONTHQTY as [Next Month Qty], labourHrs.NEXTMONTHNETAMT as [Next Month Amount], labourHrs.NEXTMONTHNETHRS as [Next Month Hours], 
	labourHrs.REMCOSTAMT as [Remaining Cost Amount], labourHrs.REMCOSTHRS as [Remaining Cost Hours], USERQTY, USERNETAMT, USERNETHRS
	from CANDY_LABOURHOURS labourHrs
  LEFT OUTER JOIN ACTIVITIES ON labourHrs.TASKCODE = ACTIVITIES.ActNumber
	where labourHrs.CONTRACT = @contrno
	and labourHrs.SYSDATE = @candyImportDate
	order by labourHrs.TASKCODE;
	
	RETURN
END
		
		