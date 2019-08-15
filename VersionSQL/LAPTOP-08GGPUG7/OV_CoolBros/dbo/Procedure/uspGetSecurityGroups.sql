/****** Object:  Procedure [dbo].[uspGetSecurityGroups]    Committed by VersionSQL https://www.versionsql.com ******/


CREATE PROCEDURE [dbo].[uspGetSecurityGroups](@Id int,@search varchar(100)) 
/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	$FunctionName
	Description	:	Retrieve all records in the SecurityGroup table.
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

	if(@Id =0)
	
			SELECT	
				[id]
				, 
				[code]
				, 
				[name]
				, 
				[externalid]
				
			FROM  [dbo].[SecurityGroup] 
			WHERE code like '%'+@search +'%' or name  like '%'+@search +'%'
	else
			SELECT	
				[id]
				, 
				[code]
				, 
				[name]
				, 
				[externalid]
				
			FROM	[dbo].[SecurityGroup]  where ID=@Id 
			
	IF @@error != 0
	BEGIN
		
RAISERROR ('General Error', 18, 1)

		RETURN 1		
	END
	
	RETURN 0
