/****** Object:  Procedure [BS].[CompletePOGlobally]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [BS].[CompletePOGlobally](@CutOffDate datetime)
as
UPDATE ORD SET ORDSTATUSID=41  WHERE CREATEDATE <=@CUTOFFDATE AND LEFT(ORDNUMBER,3) IN ( 'CIP' , 'CIL' ,'CSL' ,'PCJ'  ) AND RECTYPE='STD'

EXEC  [BT].[spBUDGETAGENT]