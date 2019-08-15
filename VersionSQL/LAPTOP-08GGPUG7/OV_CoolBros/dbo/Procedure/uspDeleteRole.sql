/****** Object:  Procedure [dbo].[uspDeleteRole]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspDeleteRole]
	
(
	@id	udtId
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspDeleteRole
	Description	:	Delete a record from the Role table.
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
	FROM	[dbo].[RoleUser] WHERE	roleid = @id	
		
	
	DELETE
	FROM	[dbo].[RolePolicy]	WHERE roleid = @id
	
	DELETE
	FROM	[dbo].[RoleAttribute] WHERE roleid = @id

	
	DELETE
	FROM	[dbo].[Role]	WHERE	id = @id	
	IF @@error != 0
	BEGIN
		
RAISERROR ('uspDeleteRole: Error deleting record from [orgview].[dbo].[Role]', 18, 1)

		RETURN 1		
	END
	

	
SET NOCOUNT OFF

RETURN 0

