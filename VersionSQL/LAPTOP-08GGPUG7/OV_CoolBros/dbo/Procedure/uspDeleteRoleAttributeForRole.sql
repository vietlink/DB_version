/****** Object:  Procedure [dbo].[uspDeleteRoleAttributeForRole]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspDeleteRoleAttributeForRole]	
(	@roleid	udtId,
	@EntityId int
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspDeleteRoleAttribute
	Description	:	Delete a record from the RoleAttribute table.
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



SET NOCOUNT ON

DELETE
FROM
RoleAttribute where attributeid in (select id from Attribute where entityid =@EntityId) and roleid =@roleid

IF @@error != 0
BEGIN
	RAISERROR ('uspDeleteRoleAttribute: Error deleting record from [orgview].[dbo].[RoleAttribute]', 18, 1)
	RETURN 1		
END
	

	
SET NOCOUNT OFF

RETURN 0
