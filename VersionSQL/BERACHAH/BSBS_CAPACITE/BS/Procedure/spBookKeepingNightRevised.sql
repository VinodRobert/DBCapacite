/****** Object:  Procedure [BS].[spBookKeepingNightRevised]    Committed by VersionSQL https://www.versionsql.com ******/

create   PROCEDURE [BS].[spBookKeepingNightRevised]
as

UPDATE SUBCRECONS 
SET REMARK = REPLACE(REMARK,'''',' ')

 