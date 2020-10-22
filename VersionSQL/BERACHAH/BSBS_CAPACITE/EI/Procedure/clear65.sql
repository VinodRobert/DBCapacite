/****** Object:  Procedure [EI].[clear65]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure ei.clear65
as
delete from transactions where orgid=65
delete from debtrecons where orgid=65
delete from subcrecons where orgid=65
delete from ei.EINVOICEDETAILS
delete from ei.EINVOICE
delete from ei.EINVOICEHEADER
dbcc checkident ("ei.einvoiceheader",reseed,0)
delete from ei.DEBTORINVOICEHEADER
dbcc checkident("ei.DEBTORINVOICEHEADER",reseed,0)
delete from ei.DEBTINVOICEDETAILS
delete  FROM ATTRIBVALUE WHERE TABLENAME='SUBCRECONS' AND ATTRIBUTE='EI'