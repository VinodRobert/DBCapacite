/****** Object:  Function [dbo].[getSnapshotActivityParentAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author: Riaan Engelbrecht
-- Create date: 13-09-2016
-- Description:	returns Snapshot Activity Parent Attributes
-- NOTES:
--  
-- =============================================
CREATE FUNCTION [dbo].[getSnapshotActivityParentAttributes] (@snapshotId int)
    RETURNS @t TABLE (
	  [Activity Number]	nvarchar(10),
	  [Activity Name] nvarchar(100),
	  [PARENTVALUE]	nvarchar(255)
  )
AS
BEGIN

    insert into @t
    select ltrim(rtrim(ACT.ActNumber)) as [Activity Number], ltrim(rtrim(ACT.Actname)) as [Activity Name], ltrim(rtrim(isnull(AV.VALUE, ''))) as PARENTVALUE from ACTIVITIES ACT 
    left outer join ATTRIBVALUE AV on ATTRIBUTE='Rollup Parent' and AV.COLKEY=ACT.ActID;
	
	RETURN
END
		
		