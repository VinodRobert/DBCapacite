/****** Object:  Function [dbo].[ufn_CountChar]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[ufn_CountChar] ( @pInput VARCHAR(1000), @pSearchChar CHAR(1) )
RETURNS INT
BEGIN

RETURN (LEN(@pInput) - LEN(REPLACE(@pInput      COLLATE SQL_Latin1_General_Cp1_CS_AS, 
                                   @pSearchChar COLLATE SQL_Latin1_General_Cp1_CS_AS, '')))

END