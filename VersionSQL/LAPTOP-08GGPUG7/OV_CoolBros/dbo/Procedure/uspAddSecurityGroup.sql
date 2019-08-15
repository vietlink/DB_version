/****** Object:  Procedure [dbo].[uspAddSecurityGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddSecurityGroup]
	
(
	@code	udtCode, 
	@name	udtName
	--@externalid	udtLongName = null
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddSecurityGroup
	Description	:	Add a record to the SecurityGroup table.
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


	
INSERT INTO	[dbo].[SecurityGroup]
(
	[code],
	[name]
	--[externalid]
)
VALUES
(
	@code, 
	@name 
	--@externalid
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

RAISERROR ('uspAddSecurityGroup: Error adding record to [orgview].[dbo].[SecurityGroup]', 18, 1)

	RETURN 1		
END
ELSE
return @Id
	


SET NOCOUNT OFF	

