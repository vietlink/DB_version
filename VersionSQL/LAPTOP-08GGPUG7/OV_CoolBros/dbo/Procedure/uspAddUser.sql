/****** Object:  Procedure [dbo].[uspAddUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddUser]
	
(
	@authenticationmethodid	udtId, 
	@accountname	udtLongName, 
	@displayname	udtLongName, 
	@enabled		udtYesNo,
	@password		udtLongName = null,
	@usereditable	udtYesNo,
	@type			udtName,
	@requirespasswordreset bit,
	@workEmail varchar(255)
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddUser
	Description	:	Add a record to the User table.
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

IF EXISTS (SELECT ID FROM [User] WHERE accountname = @accountname) BEGIN
	UPDATE [User] SET IsDeleted = 0, displayname = @displayname, WorkEmail = @workEmail WHERE accountname = @accountname
	RETURN;
END
	
INSERT INTO	[dbo].[User]
(
	[authenticationmethodid],
	[accountname],
	[password],
	[displayname],
	[enabled],
	[usereditable],
	[type],
	[RequiresPasswordReset],
	[WorkEmail]
	
)
VALUES
(
	@authenticationmethodid, 
	@accountname, 
	@password, 
	@displayname, 
	@enabled,
	@usereditable,
	@type,
	@requirespasswordreset,
	@workEmail
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

RAISERROR ('uspAddUser: Error adding record to [orgview].[dbo].[User]', 18, 1)

	RETURN 1		
END
	
SET NOCOUNT OFF

SELECT	[id], 
		[authenticationmethodid], 
		[accountname], 
		[password], 
		[displayname], 
		[enabled],
		[usereditable],
		[type]
FROM	[dbo].[User]
WHERE	id = @id
	
RETURN 0

