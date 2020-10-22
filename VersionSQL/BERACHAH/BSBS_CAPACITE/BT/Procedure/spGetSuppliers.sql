/****** Object:  Procedure [BT].[spGetSuppliers]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BT.spGetSuppliers 
as
SELECT SUPPID,SUPPNAME FROM SUPPLIERS ORDER BY SUPPNAME 