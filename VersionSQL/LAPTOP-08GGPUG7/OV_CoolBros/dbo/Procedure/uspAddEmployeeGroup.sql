/****** Object:  Procedure [dbo].[uspAddEmployeeGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddEmployeeGroup]
	
(
	@code	udtCode, 
	@name	udtName, 
	@icon	udtURL,
	@createdby varchar(100),
	@createddate datetime,
	@permissionLevel int,
	@interfaceid	udtId = null,
	@ReturnValue int output
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddEmployeeGroup
	Description	:	Add a record to the EmployeeGroup table.
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


	
INSERT INTO	[dbo].[EmployeeGroup]
(
	[code],
	[name],
	[icon],
	[interfaceid],
	createdBy,
	createdDate,
	PermissionLevel
)
VALUES
(
	@code, 
	@name, 
	@icon, 
	@interfaceid,
	@createdby,
	@createddate,
	@permissionLevel
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

SET @ReturnValue =0	
END
ELSE
BEGIN

SET @ReturnValue =@@IDENTITY
END


SET NOCOUNT OFF

