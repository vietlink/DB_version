/****** Object:  Procedure [dbo].[uspGetRoleAttributePermissions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRoleAttributePermissions]
(	@roleid		udtId,
	@entityid	udtId
)

/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspGetRoleAttributePermissions
	Description	:	Get the RoleAttribute(s) with a matching Role and for the defined Entity.
	Author(s)	:	Clark Sayers
	Date		:	01-October-2004
	Notes		:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	$
	$Date		:	$
	$History	:	$
	$Revision		:	$
------------------------------------------------------------------------------------------------------------------- */
	
	
AS

SELECT	ra.[id], 
	ra.[roleid], 
	ra.[attributeid], 
	ra.[granted],
	a.longname,
	a.shortname
FROM	[dbo].[RoleAttribute] ra,
	[dbo].[Attribute] a
WHERE	ra.[roleid] = @roleid
AND	ra.[attributeid] = a.[id]
AND	a.[entityid] = @entityid
	

