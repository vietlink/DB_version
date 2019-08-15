/****** Object:  Procedure [dbo].[uspGetRolesSecurityGroups]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRolesSecurityGroups]
(	@roleid		udtId
)
/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspGetRolesSecurityGroups
	Description	:	Retrieve all the SecurityGroups for a defined Role.
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

SELECT	sg.[id], 
	sg.[code], 
	sg.[name], 
	sg.[externalid]
FROM	[dbo].[RoleSecurityGroup] rsg,
	[dbo].[SecurityGroup] sg
WHERE	rsg.[roleid] = @roleid
AND	rsg.[securitygroupid] = sg.[id]
	
IF @@error != 0
BEGIN
	RAISERROR ('General Error', 18, 1)
	RETURN 1		
END
	
RETURN 0
