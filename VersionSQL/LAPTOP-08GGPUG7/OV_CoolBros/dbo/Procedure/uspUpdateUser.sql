/****** Object:  Procedure [dbo].[uspUpdateUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateUser]
	
(
	@id	udtId,
	@authenticationmethodid	udtId, 
	@accountname			udtLongName, 
	@displayname			udtLongName, 
	@enabled				udtYesNo,
	@password				udtLongName = null,
	@usereditable			udtYesNo,
	@type					udtName,
	@workEmail				varchar(255)
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspUpdateUser
	Description	:	Update record(s) in the User table.
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

if(@password <>'')

UPDATE	[dbo].[User]
SET		[authenticationmethodid]	=	@authenticationmethodid,
		[accountname]				=	@accountname,
		[password]					=	@password,
		[displayname]				=	@displayname,
		[enabled]					=	@enabled,
		[usereditable]				=	@usereditable,
		[type]						=	@type,
		[WorkEmail]				=   @workEmail
WHERE	[id] = @id

else

UPDATE	[dbo].[User]
SET		[authenticationmethodid]	=	@authenticationmethodid,
		[accountname]				=	@accountname,		
		[displayname]				=	@displayname,
		[enabled]					=	@enabled,
		[usereditable]				=	@usereditable,
		[type]						=	@type,
		[WorkEmail]					=   @workEmail
WHERE	[id] = @id
IF @@error != 0
BEGIN
	RAISERROR ('General Error', 18, 1)
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
WHERE	[id] = @id

RETURN 0

