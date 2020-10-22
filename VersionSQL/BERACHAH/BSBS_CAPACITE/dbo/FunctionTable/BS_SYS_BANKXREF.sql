/****** Object:  Function [dbo].[BS_SYS_BANKXREF]    Committed by VersionSQL https://www.versionsql.com ******/

--Creates the Bank cross reference function used for user defined reports and automation
--====================================================================================


-- =============================================
-- Author:		<L.Johnston>
-- Create date: <Create Date,,>
-- Description:	<Simple Bank Account details Reference Employees to Creditors and or Sub Contractor Bank Acc >
--Editted:		<T.Forshaw>
--Editted date:	<15/07/2015>
-- =============================================
CREATE FUNCTION [dbo].[BS_SYS_BANKXREF] 
(	
   
     @run int = 0

   
)
RETURNS @t TABLE (

[Employee]									[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[First Name]								[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Payroll ID]								[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Type]										[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Creditor/Subcontractor with Matching Bank]	[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Org ID with Matching Bank]					[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Creditor/Subcontractor Account Name]		[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS,
[Account Number]							[varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS


)

AS
BEGIN
	insert @t     	SELECT       dbo.EMPLOYEES.EMPNUMBER,dbo.EMPLOYEES.KNOWNAS,CONVERT(varchar(3),dbo.EMPLOYEES.PAYROLLID),'Creditor', C.CredNumber,convert (varchar(3),C.CredBankOrgID),c.CredAccName,EMPLOYEES.BANKACCOUNT
FROM            dbo.EMPLOYEES INNER JOIN
                         dbo.CREDITORSBANK AS C ON dbo.EMPLOYEES.BANKACCOUNT = C.CredAccNumber INNER JOIN
                         dbo.CREDITORS AS CM ON C.CredNumber = CM.CredNumber

   
   insert @t
	 	SELECT       dbo.EMPLOYEES.EMPNUMBER,dbo.EMPLOYEES.KNOWNAS,CONVERT(varchar(3),dbo.EMPLOYEES.PAYROLLID),'Subcontractor', S.CredNumber,convert (varchar(3),s.CredBankOrgID),s.CredAccName,EMPLOYEES.BANKACCOUNT
FROM            dbo.EMPLOYEES INNER JOIN
                         dbo.SUBCONTRACTORSBANK AS S ON dbo.EMPLOYEES.BANKACCOUNT = S.CredAccNumber INNER JOIN
                         dbo.SUBCONTRACTORS AS SM ON S.CredNumber = SM.SubNumber
	RETURN 
END

		