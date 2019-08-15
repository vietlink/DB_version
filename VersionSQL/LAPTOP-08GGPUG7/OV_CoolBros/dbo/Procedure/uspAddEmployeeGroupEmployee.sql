/****** Object:  Procedure [dbo].[uspAddEmployeeGroupEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddEmployeeGroupEmployee]
	
(
	@employeeid	udtId, 
	@employeegroupid	udtId	
)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspAddEmployeeGroupEmployee
	Description	:	Add a record to the EmployeeGroupEmployee table.
	Author(s)	:	Clark Sayers
	Date		:	01-October-2004
	Notes		:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	Date		:	History		:	Revision	
-------------------------------------------------------------------------------------------------------------------
	Alrie Coetzee	2010/05/05		A00132
------------------------------------------------------------------------------------------------------------------- */
	
	
AS

declare	@err	int
declare	@id	udtId
declare @empidentifier udtName
	
SET NOCOUNT ON

set @empidentifier = (select [identifier] from [Employee] where [id] = @employeeid)
	
INSERT INTO	[dbo].[EmployeeGroupEmployee]
(
	[employeeid],
	[employeegroupid],
	[empidentifier]
)
VALUES
(
	@employeeid, 
	@employeegroupid,
	@empidentifier
)
	
SELECT	@id = @@IDENTITY, @err = @@error

IF @err != 0
BEGIN

RAISERROR ('uspAddEmployeeGroupEmployee: Error adding record to [orgview].[dbo].[EmployeeGroupEmployee]', 18, 1)

	RETURN 1		
END
	


SET NOCOUNT OFF


SELECT	
	[id]
	, 
	[employeeid]
	, 
	[employeegroupid]
	,
	[empidentifier]
	
FROM	[dbo].[EmployeeGroupEmployee]
WHERE	id = @id
	
	RETURN 0
