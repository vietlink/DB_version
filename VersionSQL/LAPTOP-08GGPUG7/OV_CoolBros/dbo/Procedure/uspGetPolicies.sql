/****** Object:  Procedure [dbo].[uspGetPolicies]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetPolicies](@Id int,@search varchar(100)) 
/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	$FunctionName
	Description	:	Retrieve all records in the Policy table.
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
				P.[id]
				, 
				[code]
				, 
				[name]
				, 
				[description]
				, 
				[type]
				,
				PM.Modulename 
				
			FROM	[dbo].[Policy] P
			INNER JOIN PolicyModules PM  on P.ModuleId =PM.Id 
			WHERE code like '%'+@search +'%' or name  like '%'+@search +'%' or PM.Modulename =@search 
			ORDER By ModuleId 
	else
			SELECT	
				[id]
				, 
				[code]
				, 
				[name]
				, 
				[description]
				, 
				[type]
				
			FROM	[dbo].[Policy] 
			
			WHERE id =@Id
	
	IF @@error != 0
	BEGIN
		
RAISERROR ('General Error', 18, 1)

		RETURN 1		
	END
	
	RETURN 0
