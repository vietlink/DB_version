/****** Object:  Procedure [dbo].[uspAddRoleUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddRoleUser]
	
(
	@roleid	udtId, 
	@userid	udtId
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddRoleUser
	Description	:	Add a record to the RoleUser table.
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

declare	@err	int

			declare	@id	udtId

	
SET NOCOUNT ON


IF NOT EXISTS (SELECT id FROM RoleUser WHERE roleid = @roleid AND userid = @userid) BEGIN
	
INSERT INTO	[dbo].[RoleUser]
(
	[roleid],
	[userid]
)
VALUES
(
	@roleid, 
	@userid
)
	
SELECT	@id = @@IDENTITY, @err = @@error
END
IF @err != 0
BEGIN

RAISERROR ('uspAddRoleUser: Error adding record to [orgview].[dbo].[RoleUser]', 18, 1)

	RETURN 1		
END
	


SET NOCOUNT OFF


SELECT	
	[id]
	, 
	[roleid]
	, 
	[userid]
	
FROM	[dbo].[RoleUser]
WHERE	id = @id
	
	RETURN 0

