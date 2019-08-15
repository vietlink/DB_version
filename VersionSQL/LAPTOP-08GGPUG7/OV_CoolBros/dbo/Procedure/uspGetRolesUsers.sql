/****** Object:  Procedure [dbo].[uspGetRolesUsers]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRolesUsers]
(	@roleid		udtId
)
/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspGetRolesUsers
	Description	:	Retrieve all the Users for a defined Role.
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

SELECT	u.[id], 
	u.[authenticationmethodid], 
	u.[accountname], 
	u.[password], 
	u.[displayname], 
	u.[enabled],
	u.[usereditable],
	u.[type]
FROM	[dbo].[RoleUser] ru,
	[dbo].[User] u
WHERE	ru.[roleid] = @roleid
AND	ru.[userid] = u.[id] and u.IsDeleted = 0
	
IF @@error != 0
BEGIN
	RAISERROR ('General Error', 18, 1)
	RETURN 1		
END
	
RETURN 0

