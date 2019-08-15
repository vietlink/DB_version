/****** Object:  Procedure [dbo].[uspAddRole]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddRole]
	
(
	@code	udtCode, 
	@name	udtName, 
	@description	udtDescription, 
	@type	udtName, 
	@enabled	udtYesNo,
	@usereditable	udtYesNo,
	@ReturnValue int output
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddRole
	Description	:	Add a record to the Role table.
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


	
INSERT INTO	[dbo].[Role]
(
	[code],
	[name],
	[description],
	[type],
	[enabled],
	[usereditable]
)
VALUES
(
	@code, 
	@name, 
	@description, 
	@type, 
	@enabled,
	@usereditable
)
SET @ReturnValue =@@IDENTITY 
	
SET NOCOUNT OFF

