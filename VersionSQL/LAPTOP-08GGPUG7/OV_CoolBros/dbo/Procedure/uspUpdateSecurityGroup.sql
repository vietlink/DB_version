/****** Object:  Procedure [dbo].[uspUpdateSecurityGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateSecurityGroup]
	
(
	@id	udtId,
	@code	udtCode, 
	@name	udtName--,
	--@externalid	udtLongName = null
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspUpdateSecurityGroup
	Description	:	Update record(s) in the SecurityGroup table.
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


	
	UPDATE	[dbo].[SecurityGroup]
	SET
	
			[code]	=	@code,
			[name]	=	@name
			--[externalid]	=	@externalid
	WHERE	[id] = @id
	
	IF @@error != 0
	BEGIN
		
RAISERROR ('General Error', 18, 1)

		RETURN 1		
	END
	
ELSE 
RETURN 0	
	
SET NOCOUNT OFF


	

