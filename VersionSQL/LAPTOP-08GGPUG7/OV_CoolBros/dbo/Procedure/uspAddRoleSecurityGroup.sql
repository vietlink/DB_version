/****** Object:  Procedure [dbo].[uspAddRoleSecurityGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddRoleSecurityGroup]
	
(
	@roleid	udtId, 
	@securitygroupid	udtId
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddRoleSecurityGroup
	Description	:	Add a record to the RoleSecurityGroup table.
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


	
INSERT INTO	[dbo].[RoleSecurityGroup]
(
	[roleid],
	[securitygroupid]
)
VALUES
(
	@roleid, 
	@securitygroupid
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

RAISERROR ('uspAddRoleSecurityGroup: Error adding record to [orgview].[dbo].[RoleSecurityGroup]', 18, 1)

	RETURN 1		
END
	


SET NOCOUNT OFF


SELECT	
	[id]
	, 
	[roleid]
	, 
	[securitygroupid]
	
FROM	[dbo].[RoleSecurityGroup]
WHERE	id = @id
	
	RETURN 0
