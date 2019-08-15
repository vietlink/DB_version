/****** Object:  Procedure [dbo].[uspUpdateEmployeeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateEmployeeGroup]
	
(
	@id	udtId,
	@code	udtCode, 
	@name	udtName, 
	@icon	udtURL,
	@updatedby varchar(100),
	@updateddate datetime,
	@permissionLevel int,
	@interfaceid	udtId = null,
	@ReturnValue int output
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspUpdateEmployeeGroup
	Description	:	Update record(s) in the EmployeeGroup table.
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


	
	UPDATE	[dbo].[EmployeeGroup]
	SET
	
			[code]	=	@code,
			[name]	=	@name,
			[icon]	=	@icon,
			[interfaceid]	=	@interfaceid,
			updatedBy = @updatedby,
			updatedDate = @updateddate,
			PermissionLevel = @permissionLevel
	WHERE	[id] = @id
	
	IF @@error != 0
	BEGIN
		
		SET @ReturnValue =0	
	
	END
	eLSE
		SET @ReturnValue =@id 	

	
	
	
SET NOCOUNT OFF

