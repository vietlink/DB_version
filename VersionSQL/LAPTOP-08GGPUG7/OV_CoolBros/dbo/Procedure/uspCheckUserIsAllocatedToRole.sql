/****** Object:  Procedure [dbo].[uspCheckUserIsAllocatedToRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================    
-- Author:  <Raji Prasad>    
-- Create date: <15-11-2013>    
-- Description: <Check This User is allocated to any Roles>    
-- =============================================    
CREATE PROCEDURE [dbo].[uspCheckUserIsAllocatedToRole]   
 (
  @RoleId int,
  @UserId int,  
  @Allocated int output  
 )  
   
AS  
BEGIN  
  
set @Allocated =(select Id from RoleUser   where UserId =@UserId and roleid =@RoleId  )  
if(@Allocated is null)  
 set @Allocated =0  
return @Allocated  
  
END  
