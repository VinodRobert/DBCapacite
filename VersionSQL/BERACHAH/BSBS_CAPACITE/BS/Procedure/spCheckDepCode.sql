/****** Object:  Procedure [BS].[spCheckDepCode]    Committed by VersionSQL https://www.versionsql.com ******/

 
               
                        
     
 
  
               
CREATE PROCEDURE BS.spCheckDepCode
as

update assets set assetdepcode='6060000'  where assetoppcode='2200007'
update assets set assetdepcode='6060006'  where assetoppcode='2200006'
update assets set assetdepcode='6060005'  where assetoppcode='2200005'
update assets set assetdepcode='6060004'  where assetoppcode='2200004'
update assets set assetdepcode='6060003'  where assetoppcode='2200003'
update assets set assetdepcode='6060002'  where assetoppcode='2200002'
update assets set assetdepcode='6060009'  where assetoppcode='2200001'
update assets set assetdepcode='6060007'  where assetoppcode='2201000'