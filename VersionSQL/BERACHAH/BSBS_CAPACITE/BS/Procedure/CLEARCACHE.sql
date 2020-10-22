/****** Object:  Procedure [BS].[CLEARCACHE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.CLEARCACHE
AS
  DBCC FREEPROCCACHE
  DBCC DROPCLEANBUFFERS
 