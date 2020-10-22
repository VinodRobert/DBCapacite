/****** Object:  Procedure [BS].[spResetPeriodOverRide]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE BS.spResetPeriodOverRide
as
UPDATE USERADMINPROCESSES
SET ALLOW=0 
WHERE PROCESS='Period Override' AND
USERID NOT IN ( 1415,1629, 227 ) 
-- Ashok ID - 1629
-- Dinesh ID -- 1415
-- Admin ID - 227