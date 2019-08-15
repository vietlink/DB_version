/****** Object:  Procedure [dbo].[uspCheckPolicyIsAllocatedToRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================      
-- Author:  <Raji Prasad>      
-- Create date: <18-11-2013>      
-- Description: <Check Policy is allocated to any Roles>      
-- =============================================      
CREATE PROCEDURE [dbo].[uspCheckPolicyIsAllocatedToRole]     
 (  
  @RoleId int,  
  @PolicyId int,    
  @Allocated int output    
 )    
     
AS    
BEGIN    
    
set @Allocated =(select Id from RolePolicy   where policyid =@PolicyId and roleid =@RoleId  )    
if(@Allocated is null)    
 set @Allocated =0    
return @Allocated    
    
END 
