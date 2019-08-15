/****** Object:  Procedure [dbo].[uspDeleteUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspDeleteUser]
	
(
	@id	udtId
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspDeleteUser
	Description	:	Delete a record from the User table.
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

	--DELETE FROM RoleUser where userid = @id
	
	UPDATE	[dbo].[User] SET IsDeleted = 1 WHERE	id = @id	
	IF @@error != 0
	BEGIN
		
RAISERROR ('uspDeleteUser: Error deleting record from [orgview].[dbo].[User]', 18, 1)

		RETURN 1		
	END
	

	
SET NOCOUNT OFF

RETURN 0

