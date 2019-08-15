/****** Object:  Procedure [dbo].[uspAddRolePolicy]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddRolePolicy]
	
(
	@roleid	udtId, 
	@policyid	udtId, 
	@granted	udtYesNo
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddRolePolicy
	Description	:	Add a record to the RolePolicy table.
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


	
INSERT INTO	[dbo].[RolePolicy]
(
	[roleid],
	[policyid],
	[granted]
)
VALUES
(
	@roleid, 
	@policyid, 
	@granted
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

RAISERROR ('uspAddRolePolicy: Error adding record to [orgview].[dbo].[RolePolicy]', 18, 1)

	RETURN 1		
END
	


SET NOCOUNT OFF


SELECT	
	[id]
	, 
	[roleid]
	, 
	[policyid]
	, 
	[granted]
	
FROM	[dbo].[RolePolicy]
WHERE	id = @id
	
	RETURN 0
