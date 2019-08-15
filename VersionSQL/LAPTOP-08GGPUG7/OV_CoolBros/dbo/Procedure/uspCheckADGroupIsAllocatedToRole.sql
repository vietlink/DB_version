/****** Object:  Procedure [dbo].[uspCheckADGroupIsAllocatedToRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  <Raji Prasad>    
-- Create date: <15-11-2013>    
-- Description: <Check ADGroup is allocated to any Roles>    
-- =============================================    
CREATE PROCEDURE [dbo].[uspCheckADGroupIsAllocatedToRole]   
 (
  @RoleId int,
  @ADGroupId int,  
  @Allocated int output  
 )  
   
AS  
BEGIN  
  
set @Allocated =(select Id from RoleSecurityGroup   where securitygroupid =@ADGroupId and roleid =@RoleId  )  
if(@Allocated is null)  
 set @Allocated =0  
return @Allocated  
  
END  
