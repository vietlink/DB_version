/****** Object:  Procedure [dbo].[uspUpdateRole]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateRole]
	
(
	@id	udtId,
	@code	udtCode, 
	@name	udtName, 
	@description	udtDescription, 
	@type	udtName, 
	@enabled	udtYesNo,
	@usereditable	udtYesNo,
	@ReturnValue int output
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspUpdateRole
	Description	:	Update record(s) in the Role table.
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


	
	UPDATE	[dbo].[Role]
	SET
	
			[code]	=	@code,
			[name]	=	@name,
			[description]	=	@description,
			[type]	=	@type,
			[enabled]	=	@enabled,
			[usereditable]	=	@usereditable
	WHERE	[id] = @id
	
	IF @@error != 0
	BEGIN
		SET @ReturnValue =0
	
	END
	
	ELSE
	BEGIN
	
		SET @ReturnValue =@id 
	END
	
	
SET NOCOUNT OFF


	
