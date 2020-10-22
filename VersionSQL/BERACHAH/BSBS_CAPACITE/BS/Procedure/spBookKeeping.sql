/****** Object:  Procedure [BS].[spBookKeeping]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   PROCEDURE [BS].[spBookKeeping]
as


EXEC [BS].[spUpdateGSTPercentage]

  
EXEC BS.spAssignContraInvoice

update subcontractors set subselect =customs,subtype=customs  

 