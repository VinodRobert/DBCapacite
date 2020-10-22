/****** Object:  Function [dbo].[BS_ROLEVIEW]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[BS_ROLEVIEW] (@view int = -1)
RETURNS @t TABLE (
	ID int identity(1,1),
	[V] [int] NOT NULL,
	[ROLECATEGORY] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ROLENAME] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LOGINID] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[USERNAME] [nvarchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DEPARTMENT] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BORGID] [int] NOT NULL,
	[HOMEBORGNAME] [nvarchar](75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TYPENAME] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TYPEDESC] [nvarchar](55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MENULEV] [int] NOT NULL,
	[MENUDESCR] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MENULINK] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MENUCLASS] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MENUSEQUENCE] [numeric](18, 0) NULL,
	[ISALLOWED] [int] NULL
)
AS
BEGIN

insert into @t (
[V],[ROLECATEGORY],[ROLENAME],[LOGINID],[USERNAME],[DEPARTMENT],[BORGID],[HOMEBORGNAME],[TYPENAME],[TYPEDESC],[MENULEV],[MENUDESCR],[MENULINK],[MENUCLASS],[MENUSEQUENCE],[ISALLOWED]
)
SELECT * FROM
(
	/*Transaction types on roles*/
	SELECT 1 as V,
	ROLEHEADER.ROLECATEGORY, ROLEHEADER.ROLENAME, 
	'' LOGINID, '' USERNAME, '' DEPARTMENT, -1 BORGID, '' HOMEBORGNAME,
	TRANSTYPES.TYPENAME, TRANSTYPES.TYPEDESC, 
	-1 MENULEV, '' MENUDESCR, '' MENULINK, '' MENUCLASS, -1 MENUSEQUENCE,
	SUBSTRING(RMENU.TRANSPERM, (row_number() over (PARTITION by ROLEHEADER.ROLENAME order by TRANSTYPES.TYPENAME) * 2) - 1, 1) ISALLOWED
	FROM ROLEHEADER
	OUTER APPLY(SELECT TOP 1 ROLES.TRANSPERM
		FROM ROLES 
		INNER JOIN MENUSYS ON ROLES.MENUID = MENUSYS.MENUID
		WHERE ROLES.ROLENAME = ROLEHEADER.ROLENAME
		ORDER BY MENUSYS.SEQUENCE
		) RMENU
	CROSS JOIN TRANSTYPES

	UNION ALL

	/*Users on roles*/
	SELECT 2 as V, 
	ROLEHEADER.ROLECATEGORY, ROLEHEADER.ROLENAME, 
	USERS.LOGINID, USERS.USERNAME, USERS.DEPARTMENT, isnull(BORGS.BORGID, -1) BORGID, isnull(BORGS.BORGNAME, '') HOMEBORGNAME,
	'' TYPENAME, '' TYPEDESC, 
	-1 MENULEV, '' MENUDESCR, '' MENULINK, '' MENUCLASS, -1 MENUSEQUENCE,
	-1 ISALLOWED
	FROM ROLEHEADER 
	LEFT OUTER JOIN USERS ON USERS.ISADMIN = ROLEHEADER.ROLEHEADERID
	LEFT OUTER JOIN USERSINBORG ON USERSINBORG.BORGID = USERS.HOMEORGID and USERSINBORG.USERID = USERS.USERID
	LEFT OUTER JOIN BORGS ON USERSINBORG.BORGID = BORGS.BORGID

	UNION ALL

	/*Menu items on roles*/
	SELECT 3 as V, 
	ROLEHEADER.ROLECATEGORY, ROLEHEADER.ROLENAME, 
	'' LOGINID, '' USERNAME, '' DEPARTMENT, -1 BORGID, '' HOMEBORGNAME,
	'' TYPENAME, '' TYPEDESC, 
	MENUSYS.LEV MENULEV, MENUSYS.DESCR MENUDESCR, MENUSYS.LINK MENULINK, MENUSYS.CLASSNAME MENUCLASS, MENUSYS.SEQUENCE MENUSEQUENCE,
	ROLES.ISALLOWED
	FROM ROLEHEADER 
	LEFT OUTER JOIN ROLES ON ROLES.RoleName = ROLEHEADER.ROLENAME 
	INNER JOIN MENUSYS ON ROLES.MENUID = MENUSYS.MENUID

	UNION ALL

	/*Transaction types on users*/
	SELECT 4 as V, 
	ROLEHEADER.ROLECATEGORY, ROLEHEADER.ROLENAME, 
	USERS.LOGINID, USERS.USERNAME, USERS.DEPARTMENT, isnull(BORGS.BORGID, -1) BORGID, isnull(BORGS.BORGNAME, '') HOMEBORGNAME,
	TRANSTYPES.TYPENAME, TRANSTYPES.TYPEDESC, 
	-1 MENULEV, '' MENUDESCR, '' MENULINK, '' MENUCLASS, -1 MENUSEQUENCE,
	SUBSTRING(RMENU.TRANSPERM, (row_number() over (PARTITION by ROLEHEADER.ROLENAME order by TRANSTYPES.TYPENAME) * 2) - 1, 1) ISALLOWED
	FROM ROLEHEADER
	LEFT OUTER JOIN USERS ON USERS.ISADMIN = ROLEHEADER.ROLEHEADERID
	LEFT OUTER JOIN USERSINBORG ON USERSINBORG.BORGID = USERS.HOMEORGID and USERSINBORG.USERID = USERS.USERID
	LEFT OUTER JOIN BORGS ON USERSINBORG.BORGID = BORGS.BORGID
	OUTER APPLY(SELECT TOP 1 ROLES.TRANSPERM
		FROM ROLES 
		INNER JOIN MENUSYS ON ROLES.MENUID = MENUSYS.MENUID
		WHERE ROLES.ROLENAME = ROLEHEADER.ROLENAME
		ORDER BY MENUSYS.SEQUENCE
		) RMENU
	CROSS JOIN TRANSTYPES 

	UNION ALL

	/*Menu items on users*/
	SELECT 5 as V, 
	ROLEHEADER.ROLECATEGORY, ROLEHEADER.ROLENAME, 
	USERS.LOGINID, USERS.USERNAME, USERS.DEPARTMENT, isnull(BORGS.BORGID, -1) BORGID, isnull(BORGS.BORGNAME, '') HOMEBORGNAME,
	'' TYPENAME, '' TYPEDESC, 
	MENUSYS.LEV MENULEV, MENUSYS.DESCR MENUDESCR, MENUSYS.LINK MENULINK, MENUSYS.CLASSNAME MENUCLASS, MENUSYS.SEQUENCE MENUSEQUENCE,
	ROLES.ISALLOWED
	FROM ROLEHEADER 
	LEFT OUTER JOIN ROLES ON ROLES.RoleName = ROLEHEADER.ROLENAME 
	INNER JOIN MENUSYS ON ROLES.MENUID = MENUSYS.MENUID
	LEFT OUTER JOIN USERS ON USERS.ISADMIN = ROLEHEADER.ROLEHEADERID
	LEFT OUTER JOIN USERSINBORG ON USERSINBORG.BORGID = USERS.HOMEORGID and USERSINBORG.USERID = USERS.USERID
	LEFT OUTER JOIN BORGS ON USERSINBORG.BORGID = BORGS.BORGID
) Q
WHERE V = @view

RETURN
END