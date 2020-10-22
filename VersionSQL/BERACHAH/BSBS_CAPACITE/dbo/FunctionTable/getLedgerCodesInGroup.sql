/****** Object:  Function [dbo].[getLedgerCodesInGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 19-08-2019
-- Description:	returns valid ledger codes
-- NOTES:
-- =============================================
CREATE FUNCTION [dbo].[getLedgerCodesInGroup] (@orgId int, @contrNumber nvarchar(10), @divId int, @plantNumber nvarchar(10), @actCode nvarchar(10), @ledgerCode nvarchar(10), @allocation nvarchar(35), @sys nvarchar(3))
    RETURNS @t TABLE (
	  [LEDGERID] int, 
	  [CONTRID] int, 
	  [DIVID] int, 
	  [PEID] int, 
	  [SYS] [nvarchar](3) collate SQL_Latin1_General_CP1_CI_AS NOT NULL, 
	  [BORGID] int,
	  [LedgerCode] [char](10),
	  [LedgerName] [char](35),
	  [LedgerAlloc] [char](35),
	  [LedgerValue] [money],
	  [LedgerDisplay] [bit],
	  [LedgerCurrency] [char](10),
	  [LedgerSummary] [bit],
	  [LedgerControl] [bit],
	  [LedgerControlCode] [int],
	  [LedgerDesc] [char](55),
	  [ToJoinL] [int],
	  [MozLedgerCode] [char](10),
	  [MozName] [char](80),
	  [LedgerStatus] [int],
	  [FISCALCODE] [char](10),
	  [CONTROLTYPE] [nvarchar](55),
	  [BSHEET] [nvarchar](10),
	  [ISOHRECOVERY] [bit],
	  [ICCODE] [nvarchar](10)
  )
AS
BEGIN

	declare @tmpValidationData table (
		[LEDGERID] int, 
		[CONTRID] int, 
		[DIVID] int, 
		[PEID] int, 
		[SYS] [nvarchar](3) collate SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		[BORGID] int,
		[LedgerCode] [char](10) NOT NULL,
		[LedgerName] [char](35) NULL,
		[LedgerAlloc] [char](35) NOT NULL,
		--[LedgerMemo] [text] NULL,
		[LedgerValue] [money] NULL,
		[LedgerDisplay] [bit] NOT NULL,
		[LedgerCurrency] [char](10) NULL,
		[LedgerSummary] [bit] NOT NULL,
		[LedgerControl] [bit] NOT NULL,
		[LedgerControlCode] [int] NULL,
		[LedgerDesc] [char](55) NULL,
		[ToJoinL] [int] NOT NULL,
		[MozLedgerCode] [char](10) NOT NULL,
		[MozName] [char](80) NOT NULL,
		[LedgerStatus] [int] NOT NULL,
		[FISCALCODE] [char](10) NOT NULL,
		[CONTROLTYPE] [nvarchar](55) NOT NULL,
		[BSHEET] [nvarchar](10) NOT NULL,
		[ISOHRECOVERY] [bit] NOT NULL,
		[ICCODE] [nvarchar](10) NOT NULL
	);
	/* BALANCE SHEET */
	if @allocation = 'Balance Sheet'
	BEGIN
		insert into @tmpValidationData
		/*Lists per user all cost codes in include selection and not in exclude selection*/ 
		SELECT DISTINCT TABLEINCLUDE.LEDGERID, TABLEINCLUDE.CONTRID, TABLEINCLUDE.DIVID, TABLEINCLUDE.PEID, TABLEINCLUDE.SYS, TABLEINCLUDE.BORGID,
		[LedgerCode], [LedgerName], [LedgerAlloc], [LedgerValue], [LedgerDisplay], [LedgerCurrency], [LedgerSummary], [LedgerControl], [LedgerControlCode], [LedgerDesc], [ToJoinL], [MozLedgerCode], [MozName], [LedgerStatus], [FISCALCODE], [CONTROLTYPE], [BSHEET], [ISOHRECOVERY], [ICCODE] 
		FROM 
		( 
			/*------------------------Include at level 0 - default------------------------*/ 

			/*Select All Balance Sheet LEDGERCODES included at default level*/ 
			select null CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, S.SYS, NULL BORGID 
			from LEDGERCODES 
			CROSS JOIN 
			( 
			select @sys SYS
			) S 
			left outer join LEDGERCODEGROUPLINK LCGL on LCGL.HID = -1 and LCGL.LEV = 0 
			WHERE  LEDGERCODES.LEDGERALLOC = 'Balance Sheet' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND ((LCGL.LEV = 0 and LCGL.INC = 1) OR (LCGL.HID is null)) 

			/*------------------------Include at level 0------------------------*/ 
    
			/*union with all Balance Sheet LEDGERCODES turned on at group level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, NULL BORGID 
			from LEDGERCODEGROUPLINK LCGL 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.THEID = -1 
			and LCGL.LEV = 0 
			AND LCGL.INC = 1 
			AND LCGH.ALLOC = 'Balance Sheet' 
			AND LEDGERCODES.LEDGERALLOC = 'Balance Sheet' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end

			/*------------------------Include at level 1------------------------*/ 

			/*union with all Balance Sheet LEDGERCODES turned on at borg level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Balance Sheet' 
			AND LEDGERCODES.LEDGERALLOC = 'Balance Sheet' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 
			AND BORGS.BORGID = @orgId
		) as TABLEINCLUDE 
		left outer join 
		( 
			/*------------------------Excludes at level 0------------------------*/ 

			/*select all Balance Sheet LEDGERCODES excluded at group level, not included at borg level*/ 
			select null CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, NULL BORGID 
			from LEDGERCODEGROUPLINK LCGL 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS 
				from BORGS 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 0 
				AND LCGH.ALLOC = 'Balance Sheet' 
				AND LEDGERCODES.LEDGERALLOC = 'Balance Sheet' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND BORGS.BORGID = @orgId
			) IB 
			ON IB.LEDGERID = LEDGERCODES.LEDGERID 
			and IB.SYS = LCGH.SYS 
			WHERE LCGL.LEV = 0 
			AND LCGL.INC = 0 
			and IB.LEDGERID is null 
			AND LCGH.ALLOC = 'Balance Sheet' 
			AND LEDGERCODES.LEDGERALLOC = 'Balance Sheet' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 

			/*------------------------Excludes at level 1------------------------*/ 
    
			/*select all Balance Sheet LEDGERCODES excluded at borg level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 0 
			AND LCGH.ALLOC = 'Balance Sheet' 
			AND LEDGERCODES.LEDGERALLOC = 'Balance Sheet' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 

		) as TABLEEXCLUDE 
		on TABLEINCLUDE.CONTRID = TABLEEXCLUDE.CONTRID 
		AND TABLEINCLUDE.LEDGERID = TABLEEXCLUDE.LEDGERID 
		AND TABLEINCLUDE.SYS = TABLEEXCLUDE.SYS 
		AND TABLEINCLUDE.ALLOC = TABLEEXCLUDE.ALLOC 
		inner join LEDGERCODES on LEDGERCODES.LedgerID = TABLEINCLUDE.LEDGERID

		WHERE 
		TABLEEXCLUDE.LEDGERID IS NULL 
		AND TABLEEXCLUDE.SYS IS NULL 
	END;

	/* CONTRACTS */
	if @allocation = 'Contracts'
	BEGIN
		insert into @tmpValidationData
		/*Lists per user all cost codes in include selection and not in exclude selection*/ 
		SELECT DISTINCT TABLEINCLUDE.LEDGERID, TABLEINCLUDE.CONTRID, TABLEINCLUDE.DIVID, TABLEINCLUDE.PEID, TABLEINCLUDE.SYS, TABLEINCLUDE.BORGID,
		[LedgerCode], [LedgerName], [LedgerAlloc], [LedgerValue], [LedgerDisplay], [LedgerCurrency], [LedgerSummary], [LedgerControl], [LedgerControlCode], [LedgerDesc], [ToJoinL], [MozLedgerCode], [MozName], [LedgerStatus], [FISCALCODE], [CONTROLTYPE], [BSHEET], [ISOHRECOVERY], [ICCODE] 
		FROM 
		( 
			/*------------------------Include at level 0 - default------------------------*/ 
			/*Select All Contract LEDGERCODES included at default level*/ 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, S.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			CROSS JOIN 
			LEDGERCODES 
			CROSS JOIN 
			( 
			select @sys SYS
			) S 
			left outer join LEDGERCODEGROUPLINK LCGL on LCGL.HID = -1 and LCGL.LEV = 0 
			WHERE CONTRACTS.CONSTATUS <> 2 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND ((LCGL.LEV = 0 and LCGL.INC = 1) OR (LCGL.HID is null)) 

			/*------------------------Include at level 0------------------------*/ 

			/*union with all Contract LEDGERCODES turned on at group level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = -1 and LCGL.LEV = 0 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND CONTRACTS.CONSTATUS <> 2 
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

			/*------------------------Include at level 1------------------------*/ 

			

			/*union with all Contract LEDGERCODES turned on at borg level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND CONTRACTS.CONSTATUS <> 2 
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

			/*------------------------Include at level 2------------------------*/ 

			/*union with all Contract LEDGERCODES turned on at project level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PROJECTS.PROJID and LCGL.LEV = 2 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND CONTRACTS.CONSTATUS <> 2 
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

			/*------------------------Include at level 3------------------------*/ 

			 /*union with all Contract LEDGERCODES turned on at contract level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = CONTRACTS.CONTRID and LCGL.LEV = 3 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND CONTRACTS.CONSTATUS <> 2 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys
		) as TABLEINCLUDE 
		left outer join 
		( 
			/*------------------------Excludes at level 0------------------------*/ 

			/*select all Contract LEDGERCODES excluded at group level, not included at borg or project or contract level*/ 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.LEV = 0 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select CONTRACTS.CONTRID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
				inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = CONTRACTS.CONTRID and LCGL.LEV = 3 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Contracts' 
				AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND PROJECTS.BORGID = @orgId
				AND CONTRACTS.CONSTATUS <> 2 
				AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
				AND LCGH.SYS = @sys
			) IC 
			on IC.CONTRID = CONTRACTS.CONTRID 
			and IC.LEDGERID = LEDGERCODES.LEDGERID 
			and IC.SYS = LCGH.SYS 
			left outer join ( 
				select CONTRACTS.CONTRID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
				inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PROJECTS.PROJID and LCGL.LEV = 2 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Contracts' 
				AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND PROJECTS.BORGID = @orgId
				AND CONTRACTS.CONSTATUS <> 2 
				AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
				AND LCGH.SYS = @sys
			) IP 
			on IP.CONTRID = CONTRACTS.CONTRID 
			and IP.LEDGERID = LEDGERCODES.LEDGERID 
			and IP.SYS = LCGH.SYS 
			left outer join ( 
				select CONTRACTS.CONTRID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
				inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Contracts' 
				AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND PROJECTS.BORGID = @orgId
				AND CONTRACTS.CONSTATUS <> 2 
				AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
				AND LCGH.SYS = @sys
			) IB 
			on IB.CONTRID = CONTRACTS.CONTRID 
			and IB.LEDGERID = LEDGERCODES.LEDGERID 
			and IB.SYS = LCGH.SYS 
			WHERE LCGL.INC = 0 
			and IC.LEDGERID is null 
			and IP.LEDGERID is null 
			and IB.LEDGERID is null 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts'
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 
			AND PROJECTS.BORGID = @orgId
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

			/*------------------------Excludes at level 1------------------------*/ 
    
			/*select all Contract LEDGERCODES excluded at borg level, not included at project or contract level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select CONTRACTS.CONTRID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
				inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = CONTRACTS.CONTRID and LCGL.LEV = 3 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Contracts' 
				AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND PROJECTS.BORGID = @orgId
				AND CONTRACTS.CONSTATUS <> 2 
				AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
				AND LCGH.SYS = @sys
			) IC 
			on IC.CONTRID = CONTRACTS.CONTRID 
			and IC.LEDGERID = LEDGERCODES.LEDGERID 
			and IC.SYS = LCGH.SYS 
			left outer join ( 
				select CONTRACTS.CONTRID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
				inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PROJECTS.PROJID and LCGL.LEV = 2 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Contracts' 
				AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND PROJECTS.BORGID = @orgId
				AND CONTRACTS.CONSTATUS <> 2 
				AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
				AND LCGH.SYS = @sys
			) IP 
			on IP.CONTRID = CONTRACTS.CONTRID 
			and IP.LEDGERID = LEDGERCODES.LEDGERID 
			and IP.SYS = LCGH.SYS 
			WHERE LCGL.INC = 0 
			and IC.LEDGERID is null 
			and IP.LEDGERID is null 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

			/*------------------------Excludes at level 2------------------------*/ 

			/*select all Contract LEDGERCODES excluded at project level, not included at contract level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PROJECTS.PROJID and LCGL.LEV = 2 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select CONTRACTS.CONTRID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
				inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = CONTRACTS.CONTRID and LCGL.LEV = 3 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Contracts' 
				AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND PROJECTS.BORGID = @orgId
				AND CONTRACTS.CONSTATUS <> 2 
				AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
				AND LCGH.SYS = @sys
			) IA 
			on IA.CONTRID = CONTRACTS.CONTRID 
			and IA.LEDGERID = LEDGERCODES.LEDGERID 
			and IA.SYS = LCGH.SYS 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			WHERE LCGL.INC = 0 
			and IA.LEDGERID is null 
			AND PROJECTS.BORGID = @orgId
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

			/*------------------------Excludes at level 3------------------------*/ 

			/*select all Contract LEDGERCODES excluded at contract level*/ 
			UNION ALL 
			select CONTRACTS.CONTRID CONTRID, null DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PROJECTS on PROJECTS.BORGID = BORGS.BORGID 
			inner join CONTRACTS on CONTRACTS.PROJID = PROJECTS.PROJID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = CONTRACTS.CONTRID and LCGL.LEV = 3 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 0 
			AND LCGH.ALLOC = 'Contracts' 
			AND LEDGERCODES.LEDGERALLOC = 'Contracts' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND PROJECTS.BORGID = @orgId
			AND case @contrNumber when '' then '1' else CONTRACTS.CONTRNUMBER end = case @contrNumber when '' then '1' else @contrNumber end
			AND LCGH.SYS = @sys

		) as TABLEEXCLUDE 
		on TABLEINCLUDE.CONTRID = TABLEEXCLUDE.CONTRID 
		AND TABLEINCLUDE.LEDGERID = TABLEEXCLUDE.LEDGERID 
		AND TABLEINCLUDE.SYS = TABLEEXCLUDE.SYS 
		AND TABLEINCLUDE.ALLOC = TABLEEXCLUDE.ALLOC 
		inner join LEDGERCODES on LEDGERCODES.LedgerID = TABLEINCLUDE.LEDGERID

		WHERE 
		TABLEEXCLUDE.LEDGERID IS NULL 
		AND TABLEEXCLUDE.SYS IS NULL 

	END;

	/* OVERHEADS */
	if @allocation = 'Overheads'
	BEGIN
		insert into @tmpValidationData
		SELECT DISTINCT TABLEINCLUDE.LEDGERID, TABLEINCLUDE.CONTRID, TABLEINCLUDE.DIVID, TABLEINCLUDE.PEID, TABLEINCLUDE.SYS, TABLEINCLUDE.BORGID,
		[LedgerCode], [LedgerName], [LedgerAlloc], [LedgerValue], [LedgerDisplay], [LedgerCurrency], [LedgerSummary], [LedgerControl], [LedgerControlCode], [LedgerDesc], [ToJoinL], [MozLedgerCode], [MozName], [LedgerStatus], [FISCALCODE], [CONTROLTYPE], [BSHEET], [ISOHRECOVERY], [ICCODE]  
		FROM 
		( 
			/*------------------------Include at level 0 - default------------------------*/ 

			/*Select All Overheads LEDGERCODES included at default level*/ 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, S.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			CROSS JOIN 
			LEDGERCODES 
			CROSS JOIN 
			( 
			select @sys SYS
			) S 
			left outer join LEDGERCODEGROUPLINK LCGL on LCGL.HID = -1 and LCGL.LEV = 0 
			WHERE DIVISIONS.DIVSTATUS <> 2 
			AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
			AND DIVISIONS.BorgID = @orgId
			AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND ((LCGL.LEV = 0 and LCGL.INC = 1) OR (LCGL.HID is null)) 

			/*------------------------Include at level 0------------------------*/ 
    
			/*union with all Overheads LEDGERCODES turned on at group level*/ 
			UNION ALL 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = -1 and LCGL.LEV = 0 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Overheads' 
			AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
			AND DIVISIONS.DIVSTATUS <> 2 
			AND DIVISIONS.BorgID = @orgId
			AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND LCGH.SYS = @sys

			/*------------------------Include at level 1------------------------*/ 

			/*union with all Overheads LEDGERCODES turned on at borg level*/ 
			UNION ALL 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Overheads' 
			AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
			AND DIVISIONS.DIVSTATUS <> 2 
			AND DIVISIONS.BorgID = @orgId
			AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND LCGH.SYS = @sys

			/*------------------------Include at level 2------------------------*/ 

			/*union with all Overheads LEDGERCODES turned on at division level*/ 
			UNION ALL 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = DIVISIONS.DIVID and LCGL.LEV = 2 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Overheads' 
			AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
			AND DIVISIONS.DIVSTATUS <> 2
			AND DIVISIONS.BorgID = @orgId
			AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND LCGH.SYS = @sys

		) as TABLEINCLUDE 
		left outer join 
		( 
			/*------------------------Excludes at level 0------------------------*/ 
    
			/*select all Overhead LEDGERCODES excluded at group level, not included at borg or division level*/ 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.LEV = 0 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select DIVISIONS.DIVID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = DIVISIONS.DIVID and LCGL.LEV = 2 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Overheads' 
				AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
				AND DIVISIONS.DIVSTATUS <> 2 
				AND DIVISIONS.BorgID = @orgId
				AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND LCGH.SYS = @sys
			) ID 
			on ID.DIVID = DIVISIONS.DIVID 
			and ID.LEDGERID = LEDGERCODES.LEDGERID 
			and ID.SYS = LCGH.SYS 
			left outer join ( 
				select DIVISIONS.DIVID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Overheads' 
				AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
				AND DIVISIONS.DIVSTATUS <> 2 
				AND DIVISIONS.BorgID = @orgId
				AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND LCGH.SYS = @sys
			) IB 
			on IB.DIVID = DIVISIONS.DIVID 
			and IB.LEDGERID = LEDGERCODES.LEDGERID 
			and IB.SYS = LCGH.SYS 
			WHERE LCGL.INC = 0 
			and ID.LEDGERID is null 
			and IB.LEDGERID is null 
			AND LCGH.ALLOC = 'Overheads' 
			AND LEDGERCODES.LEDGERALLOC = 'Overheads' 			

			/*------------------------Excludes at level 1------------------------*/ 

			/*select all Overhead LEDGERCODES excluded at borg level, not included at division level*/ 
			UNION ALL 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select DIVISIONS.DIVID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = DIVISIONS.DIVID and LCGL.LEV = 2 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'OVERHEADS' 
				AND LEDGERCODES.LEDGERALLOC = 'OVERHEADS' 
				AND DIVISIONS.DIVSTATUS <> 2 
				AND DIVISIONS.BorgID = @orgId
				AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND LCGH.SYS = @sys
			) ID 
			on ID.DIVID = DIVISIONS.DIVID 
			and ID.LEDGERID = LEDGERCODES.LEDGERID 
			and ID.SYS = LCGH.SYS 
			WHERE LCGL.INC = 0 
			and ID.LEDGERID is null 
			AND LCGH.ALLOC = 'OVERHEADS' 
			AND LEDGERCODES.LEDGERALLOC = 'OVERHEADS' 
			AND DIVISIONS.BorgID = @orgId
			AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND LCGH.SYS = @sys

			/*------------------------Excludes at level 2------------------------*/ 

			/*select all Overhead LEDGERCODES excluded at divid level*/ 
			UNION ALL 
			select null CONTRID, DIVISIONS.DIVID DIVID, null PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join DIVISIONS on DIVISIONS.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = DIVISIONS.DIVID and LCGL.LEV = 2 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 0 
			AND LCGH.ALLOC = 'Overheads' 
			AND LEDGERCODES.LEDGERALLOC = 'Overheads' 
			AND DIVISIONS.DIVSTATUS <> 2
			AND DIVISIONS.BorgID = @orgId
			AND case @divId when -1 then 1 else DIVISIONS.DivID end = case @divId when -1 then 1 else @divId end
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND LCGH.SYS = @sys

		) as TABLEEXCLUDE 
		on TABLEINCLUDE.CONTRID = TABLEEXCLUDE.CONTRID 
		AND TABLEINCLUDE.LEDGERID = TABLEEXCLUDE.LEDGERID 
		AND TABLEINCLUDE.SYS = TABLEEXCLUDE.SYS 
		AND TABLEINCLUDE.ALLOC = TABLEEXCLUDE.ALLOC 
		inner join LEDGERCODES on LEDGERCODES.LedgerID = TABLEINCLUDE.LEDGERID
		WHERE 
		TABLEEXCLUDE.LEDGERID IS NULL 
		AND TABLEEXCLUDE.SYS IS NULL 
	END;

	/* PLANT */
	if @allocation = 'Plant'
	BEGIN
		insert into @tmpValidationData
		/*Lists per user all cost codes in include selection and not in exclude selection*/ 
		SELECT DISTINCT TABLEINCLUDE.LEDGERID, TABLEINCLUDE.CONTRID, TABLEINCLUDE.DIVID, TABLEINCLUDE.PEID, TABLEINCLUDE.SYS, TABLEINCLUDE.BORGID,
		[LedgerCode], [LedgerName], [LedgerAlloc], [LedgerValue], [LedgerDisplay], [LedgerCurrency], [LedgerSummary], [LedgerControl], [LedgerControlCode], [LedgerDesc], [ToJoinL], [MozLedgerCode], [MozName], [LedgerStatus], [FISCALCODE], [CONTROLTYPE], [BSHEET], [ISOHRECOVERY], [ICCODE]  
		FROM 
		( 
			/*------------------------Include at level 0 - default------------------------*/ 
			/*Select All Plant LEDGERCODES included at default level*/ 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, S.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ 
			on PLANTANDEQ.BORGID = BORGS.BORGID 
			and PLANTANDEQ.PeNumber = cast(@plantNumber as char(10))
			CROSS JOIN 
			LEDGERCODES 
			CROSS JOIN 
			( 
			select @sys SYS
			) S 
			left outer join LEDGERCODEGROUPLINK LCGL on LCGL.HID = -1 and LCGL.LEV = 0 
			WHERE PLANTANDEQ.PESTATUS <> 2 
			AND PLANTANDEQ.BorgID = @orgId
			AND LEDGERCODES.LEDGERALLOC = 'Plant' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
			AND ((LCGL.LEV = 0 and LCGL.INC = 1) OR (LCGL.HID is null)) 

			/*------------------------Include at level 0------------------------*/
			/*union with all Plant LEDGERCODES turned on at group level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = -1 and LCGL.LEV = 0 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Plant' 
			AND LEDGERCODES.LEDGERALLOC = 'Plant' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
			AND PLANTANDEQ.PESTATUS <> 2 
			AND PLANTANDEQ.BorgID = @orgId
      AND LCGH.SYS = @sys

			/*------------------------Include at level 1------------------------*/ 
			/*union with all Plant LEDGERCODES turned on at borg level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Plant' 
			AND LEDGERCODES.LEDGERALLOC = 'Plant' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
			AND PLANTANDEQ.PESTATUS <> 2 
			AND PLANTANDEQ.BorgID = @orgId
      AND LCGH.SYS = @sys

			/*------------------------Include at level 2------------------------*/ 
			/*union with all Plant LEDGERCODES turned on at plant level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PLANTANDEQ.PEID and LCGL.LEV = 2 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 1 
			AND LCGH.ALLOC = 'Plant' 
			AND LEDGERCODES.LEDGERALLOC = 'Plant' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
			AND PLANTANDEQ.PESTATUS <> 2 
			AND PLANTANDEQ.BorgID = @orgId 
      AND LCGH.SYS = @sys
		) as TABLEINCLUDE 
		left outer join 
		( 
			/*------------------------Excludes at level 0------------------------*/     
			/*select all Plant LEDGERCODES excluded at group level, not included at borg or plant level*/ 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.LEV = 0 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select PLANTANDEQ.PEID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PLANTANDEQ.DIVID and LCGL.LEV = 2 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Plant' 
				AND LEDGERCODES.LEDGERALLOC = 'Plant' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
				AND PLANTANDEQ.PESTATUS <> 2 
				AND PLANTANDEQ.BorgID = @orgId
        AND LCGH.SYS = @sys
			) ID 
			on ID.PEID = PLANTANDEQ.PEID 
			and ID.LEDGERID = LEDGERCODES.LEDGERID 
			and ID.SYS = LCGH.SYS 
			AND PLANTANDEQ.BorgID = @orgId
			left outer join ( 
				select PLANTANDEQ.PEID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Plant' 
				AND LEDGERCODES.LEDGERALLOC = 'Plant' 
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
				AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
				AND PLANTANDEQ.PESTATUS <> 2 
				AND PLANTANDEQ.BorgID = @orgId
        AND LCGH.SYS = @sys
			) IB 
			on IB.PEID = PLANTANDEQ.PEID 
			and IB.LEDGERID = LEDGERCODES.LEDGERID 
			and IB.SYS = LCGH.SYS 
			WHERE LCGL.INC = 0 
			and ID.LEDGERID is null 
			and IB.LEDGERID is null 
			AND LCGH.ALLOC = 'Plant' 
			AND LEDGERCODES.LEDGERALLOC = 'Plant' 
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end
			AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
			AND PLANTANDEQ.BorgID = @orgId
      AND LCGH.SYS = @sys

			/*------------------------Excludes at level 1------------------------*/ 
			/*select all Plant LEDGERCODES excluded at borg level, not included at plant level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = BORGS.BORGID and LCGL.LEV = 1 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			left outer join ( 
				select PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LCGH.SYS, BORGS.BORGID 
				from BORGS 
				inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
				inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PLANTANDEQ.PEID and LCGL.LEV = 2 
				inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
				inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
				inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
				WHERE LCGL.INC = 1 
				AND LCGH.ALLOC = 'Plant' 
				AND LEDGERCODES.LEDGERALLOC = 'Plant'
				AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 
				AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
				AND PLANTANDEQ.PESTATUS <> 2 
				AND PLANTANDEQ.BorgID = @orgId
        AND LCGH.SYS = @sys
			) IP 
			on IP.PEID = PLANTANDEQ.PEID 
			and IP.LEDGERID = LEDGERCODES.LEDGERID 
			and IP.SYS = LCGH.SYS 
			WHERE LCGL.INC = 0 
			and IP.LEDGERID is null 
			AND LCGH.ALLOC = 'Plant' 
			AND LEDGERCODES.LEDGERALLOC = 'Plant'
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 
			AND PLANTANDEQ.BorgID = @orgId
      AND LCGH.SYS = @sys

			/*------------------------Excludes at level 2------------------------*/ 
			/*select all Plant LEDGERCODES excluded at divid level*/ 
			UNION ALL 
			select null CONTRID, null DIVID, PLANTANDEQ.PEID PEID, LEDGERCODES.LEDGERID, LEDGERCODES.LEDGERALLOC ALLOC, LCGH.SYS, BORGS.BORGID 
			from BORGS 
			inner join PLANTANDEQ on PLANTANDEQ.BORGID = BORGS.BORGID 
			inner join LEDGERCODEGROUPLINK LCGL on LCGL.THEID = PLANTANDEQ.PEID and LCGL.LEV = 2 
			inner join LEDGERCODEGROUPDETAIL LCGD on LCGL.HID = LCGD.HID and LCGD.TYPE = 'LED' 
			inner join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID 
			inner join LEDGERCODES on LCGD.TID = LEDGERCODES.LEDGERID 
			WHERE LCGL.INC = 0 
			AND LCGH.ALLOC = 'Plant' 
			AND LEDGERCODES.LEDGERALLOC = 'Plant'
			AND case @ledgerCode when '' then '1' else LEDGERCODES.LedgerCode end = case @ledgerCode when '' then '1' else cast(@ledgerCode as char(10)) end 
			AND case @plantNumber when '' then '1' else PLANTANDEQ.PeNumber end = case @plantNumber when '' then '1' else cast(@plantNumber as char(10)) end
			AND PLANTANDEQ.PESTATUS <> 2 
			AND PLANTANDEQ.BorgID = @orgId
      AND LCGH.SYS = @sys
		) as TABLEEXCLUDE 
		on TABLEINCLUDE.CONTRID = TABLEEXCLUDE.CONTRID 
		AND TABLEINCLUDE.LEDGERID = TABLEEXCLUDE.LEDGERID 
		AND TABLEINCLUDE.SYS = TABLEEXCLUDE.SYS 
		AND TABLEINCLUDE.ALLOC = TABLEEXCLUDE.ALLOC 
		inner join LEDGERCODES on LEDGERCODES.LedgerID = TABLEINCLUDE.LEDGERID
		WHERE 
		TABLEEXCLUDE.LEDGERID IS NULL 
		AND TABLEEXCLUDE.SYS IS NULL 
	END;

	/* NO ALLOCATION */
	if @allocation = ''
	BEGIN
		insert into @tmpValidationData
		/*Lists per user all cost codes in include selection and not in exclude selection*/ 
		SELECT DISTINCT TABLEINCLUDE.LEDGERID, TABLEINCLUDE.CONTRID, TABLEINCLUDE.DIVID, TABLEINCLUDE.PEID, TABLEINCLUDE.SYS, TABLEINCLUDE.BORGID,
		[LedgerCode], [LedgerName], [LedgerAlloc], [LedgerValue], [LedgerDisplay], [LedgerCurrency], [LedgerSummary], [LedgerControl], [LedgerControlCode], [LedgerDesc], [ToJoinL], [MozLedgerCode], [MozName], [LedgerStatus], [FISCALCODE], [CONTROLTYPE], [BSHEET], [ISOHRECOVERY], [ICCODE]  
		FROM 
		(
		  select null CONTRID, null DIVID, null PEID, LCGD.SYS, LC.LedgerAlloc ALLOC, @orgId as BORGID, LC.* from LEDGERCODES LC
	    inner join (
		    select distinct(LCD.TID) TID, LCGH.SYS from LEDGERCODEGROUPDETAIL LCD
		    LEFT OUTER join LEDGERCODEGROUPLINK LCGL on LCGL.HID = LCD.HID and LCD.TYPE = 'LED'
		    LEFT OUTER join LEDGERCODEGROUPHEADER LCGH on LCGL.HID = LCGH.ID
		    where LCD.[TYPE] = 'LED' 
        and LCGL.INC = 1 
        and LCGH.SYS = @sys 
        and isnull(LCD.ID, -1) <> -1
	    ) LCGD on LC.LedgerID = LCGD.TID
		) as TABLEINCLUDE
	END;

	insert into @t
	select * from @tmpValidationData

	RETURN
END
		
		