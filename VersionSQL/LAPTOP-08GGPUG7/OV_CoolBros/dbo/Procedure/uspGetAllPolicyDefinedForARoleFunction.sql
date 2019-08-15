/****** Object:  Procedure [dbo].[uspGetAllPolicyDefinedForARoleFunction]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <19-11-2013>      
-- Description: <Get all policy defined for  a role function>      
-- =============================================      
CREATE PROCEDURE [dbo].[uspGetAllPolicyDefinedForARoleFunction]     
 (  
  @RoleId int,
  @modulename varchar(100)
 )
     
AS    
BEGIN    
declare @ModuleId int
SET @ModuleId =(select id from PolicyModules where Modulename =@modulename)
select policyid  from RolePolicy where policyid in(select Id from policy where ModuleId =@ModuleId) and roleid=@RoleId
END 
