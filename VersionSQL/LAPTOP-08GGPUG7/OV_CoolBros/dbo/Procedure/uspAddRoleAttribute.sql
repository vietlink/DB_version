/****** Object:  Procedure [dbo].[uspAddRoleAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddRoleAttribute]
	
(
	@roleid	udtId, 
	@attributeid	udtId, 
	@granted	udtYesNo
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddRoleAttribute
	Description	:	Add a record to the RoleAttribute table.
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


	
INSERT INTO	[dbo].[RoleAttribute]
(
	[roleid],
	[attributeid],
	[granted]
)
VALUES
(
	@roleid, 
	@attributeid, 
	@granted
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

RAISERROR ('uspAddRoleAttribute: Error adding record to [orgview].[dbo].[RoleAttribute]', 18, 1)

	RETURN 1		
END
	


SET NOCOUNT OFF


SELECT	
	[id]
	, 
	[roleid]
	, 
	[attributeid]
	, 
	[granted]
	
FROM	[dbo].[RoleAttribute]
WHERE	id = @id
	
	RETURN 0
