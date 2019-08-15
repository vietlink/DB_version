/****** Object:  Procedure [dbo].[uspUpdateSetting]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateSetting]
	
(
	@id	udtId,	
	@value	udtValue = null,
	@ReturnValue int output
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspUpdateSetting
	Description	:	Update record(s) in the Setting table.
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


	
	UPDATE	[dbo].[Setting]
	SET
	
			
			[value]	=	@value			
	WHERE	[id] = @id
	
	IF @@error != 0
	BEGIN
		SET @ReturnValue = 0
	
	END
	ELSE
	BEGIN 
		SET @ReturnValue = @id 
	END
	
	RETURN @ReturnValue
SET NOCOUNT OFF


	
