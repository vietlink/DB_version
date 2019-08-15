/****** Object:  Procedure [dbo].[uspGetEmployeeGroups]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetEmployeeGroups](@Id int,@search varchar(100)) 
/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	$FunctionName
	Description	:	Retrieve all records in the EmployeeGroup table.
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
				[icon]
				, 
				[interfaceid],
				(select count(*) from EmployeeGroupEmployee where employeegroupid = eg.id) as count,
				PermissionLevel
				
			FROM	[dbo].[EmployeeGroup] eg
			
			WHERE code like '%'+@search +'%' or name  like '%'+@search +'%'
	else
	
			
			SELECT	
				[id]
				, 
				[code]
				, 
				[name]
				, 
				[icon]
				, 
				[interfaceid],
				(select count(*) from EmployeeGroupEmployee where employeegroupid = eg.id) as count,
				PermissionLevel
				
			FROM	[dbo].[EmployeeGroup] eg
			
			WHERE id=@Id
			
			
	IF @@error != 0
	BEGIN
		
			RAISERROR ('General Error', 18, 1)

			RETURN 1		
	END
	
	RETURN 0

