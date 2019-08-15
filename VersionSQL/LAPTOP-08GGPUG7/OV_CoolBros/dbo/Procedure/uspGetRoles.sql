/****** Object:  Procedure [dbo].[uspGetRoles]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRoles](@Id int,@search varchar(100), @enabled int = 0) 
/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	$FunctionName
	Description	:	Retrieve all records in the Role table.
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

	if(@Id=0)
	
			SELECT	
				[id]
				, 
				[code]
				, 
				[name]
				, 
				[description]
				, 
				case when [type] = 'BuiltIn' then 'System' else [type] end as [type]
				, 
				[enabled]
				,
				[usereditable],
				IsLoadRole	
			FROM	[dbo].[Role]
			WHERE (code like '%'+@search +'%' or name  like '%'+@search +'%')
			and (@enabled = 0 OR (@enabled = 1 AND [enabled] = 'Y'))
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
				case when [type] = 'BuiltIn' then 'System' else [type] end as [type]
				, 
				[enabled]
				,
				[usereditable],
				IsLoadRole
			FROM	[dbo].[Role]
			
			WHERE id=@Id 
			and (@enabled = 0 OR (@enabled = 1 AND [enabled] = 'Y'))
	IF @@error != 0
	BEGIN
		
RAISERROR ('General Error', 18, 1)

		RETURN 1		
	END
	
	RETURN 0

